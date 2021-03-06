/*
 * Copyright (C) 2009 by Matthias Ringwald
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holders nor the names of
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY MATTHIAS RINGWALD AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MATTHIAS
 * RINGWALD OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
 * THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */

/*
 *  l2cap.c
 *
 *  Logical Link Control and Adaption Protocl (L2CAP)
 *
 *  Created by Matthias Ringwald on 5/16/09.
 */

#include "l2cap.h"
#include "hci.h"

#include <stdarg.h>
#include <string.h>

#include <stdio.h>

// size of HCI ACL + L2CAP Header for regular data packets
#define COMPLETE_L2CAP_HEADER 8

static void null_event_handler(uint8_t *packet, uint16_t size);
static void null_data_handler(uint16_t source_cid, uint8_t *packet, uint16_t size);

static uint8_t * sig_buffer = NULL;
static linked_list_t l2cap_channels = NULL;
static linked_list_t l2cap_services = NULL;
static uint8_t * acl_buffer = NULL;
static void (*event_packet_handler) (uint8_t *packet, uint16_t size) = null_event_handler;
static void (*data_packet_handler)  (uint16_t source_cid, uint8_t *packet, uint16_t size) = null_data_handler;
static connection_t * capture_connection = NULL;

static uint8_t config_options[] = { 1, 2, 150, 0}; // mtu = 48 

void l2cap_init(){
    sig_buffer = malloc( 48 );
    acl_buffer = malloc( 255 + 8 ); 

    // 
    // register callbacks with HCI
    //
    hci_register_event_packet_handler(&l2cap_event_handler);
    hci_register_acl_packet_handler(&l2cap_acl_handler);
}


/** Register L2CAP packet handlers */
static void null_event_handler(uint8_t *packet, uint16_t size){
}
static void null_data_handler(uint16_t  source_cid, uint8_t *packet, uint16_t size){
}
void l2cap_register_event_packet_handler(void (*handler)(uint8_t *packet, uint16_t size)){
    event_packet_handler = handler;
}
void l2cap_register_data_packet_handler  (void (*handler)(uint16_t source_cid, uint8_t *packet, uint16_t size)){
    data_packet_handler = handler;
}

int l2cap_send_signaling_packet(hci_con_handle_t handle, L2CAP_SIGNALING_COMMANDS cmd, uint8_t identifier, ...){
    va_list argptr;
    va_start(argptr, identifier);
    uint16_t len = l2cap_create_signaling_internal(sig_buffer, handle, cmd, identifier, argptr);
    va_end(argptr);
    return hci_send_acl_packet(sig_buffer, len);
}

l2cap_channel_t * l2cap_get_channel_for_source_cid(uint16_t source_cid){
    linked_item_t *it;
    l2cap_channel_t * channel;
    for (it = (linked_item_t *) l2cap_channels; it ; it = it->next){
        channel = (l2cap_channel_t *) it;
        if ( channel->source_cid == source_cid) {
            return channel;
        }
    }
    return NULL;
}
            
// open outgoing L2CAP channel
void l2cap_create_channel_internal(connection_t * connection, bd_addr_t address, uint16_t psm){
    
    // alloc structure
    l2cap_channel_t * chan = malloc(sizeof(l2cap_channel_t));
    // TODO: emit error event
    if (!chan) return;
    
    // fill in 
    BD_ADDR_COPY(chan->address, address);
    chan->psm = psm;
    chan->handle = 0;
    chan->connection = connection;
    
    // set initial state
    chan->state = L2CAP_STATE_CLOSED;
    chan->sig_id = L2CAP_SIG_ID_INVALID;
    
    // add to connections list
    linked_list_add(&l2cap_channels, (linked_item_t *) chan);
    
    // send connection request
    // BD_ADDR, Packet_Type, Page_Scan_Repetition_Mode, Reserved, Clock_Offset, Allow_Role_Switch
    hci_send_cmd(&hci_create_connection, address, 0x18, 0, 0, 0, 0); 
}

void l2cap_disconnect_internal(uint16_t source_cid, uint8_t reason){
    // find channel for source_cid
    l2cap_channel_t * channel = l2cap_get_channel_for_source_cid(source_cid);
    if (channel) {
        channel->sig_id = l2cap_next_sig_id();
        l2cap_send_signaling_packet( channel->handle, DISCONNECTION_REQUEST, channel->sig_id, channel->dest_cid, channel->source_cid);   
        channel->state = L2CAP_STATE_WAIT_DISCONNECT;
    }
}

static void l2cap_handle_connection_failed_for_addr(bd_addr_t address, uint8_t status){
    linked_item_t *it;
    for (it = (linked_item_t *) l2cap_channels; it ; it = it->next){
        l2cap_channel_t * channel = (l2cap_channel_t *) it;
        if ( ! BD_ADDR_CMP( channel->address, address) ){
            if (channel->state == L2CAP_STATE_CLOSED) {
                // failure, forward error code
                l2cap_emit_channel_opened(channel, status);
                // discard channel
                linked_list_remove(&l2cap_channels, (linked_item_t *) channel);
                free (channel);
            }
        }
    }
}

static void l2cap_handle_connection_success_for_addr(bd_addr_t address, hci_con_handle_t handle){
    linked_item_t *it;
    for (it = (linked_item_t *) l2cap_channels; it ; it = it->next){
        l2cap_channel_t * channel = (l2cap_channel_t *) it;
        if ( ! BD_ADDR_CMP( channel->address, address) ){
            if (channel->state == L2CAP_STATE_CLOSED) {
                // success, start l2cap handshake
                channel->handle = handle;
                channel->sig_id = l2cap_next_sig_id();
                channel->source_cid = l2cap_next_source_cid();
                channel->state = L2CAP_STATE_WAIT_CONNECT_RSP;
                l2cap_send_signaling_packet( channel->handle, CONNECTION_REQUEST, channel->sig_id, channel->psm, channel->source_cid);                   
            }
        }
    }
}

void l2cap_event_handler( uint8_t *packet, uint16_t size ){
    
    bd_addr_t address;
    hci_con_handle_t handle;
    
    switch(packet[0]){
            
        // handle connection complete events
        case HCI_EVENT_CONNECTION_COMPLETE:
            bt_flip_addr(address, &packet[5]);
            if (packet[2] == 0){
                handle = READ_BT_16(packet, 3);
                l2cap_handle_connection_success_for_addr(address, handle);
            } else {
                l2cap_handle_connection_failed_for_addr(address, packet[2]);
            }
            break;
            
        // handle successful create connection cancel command
        case HCI_EVENT_COMMAND_COMPLETE:
            if ( COMMAND_COMPLETE_EVENT(packet, hci_create_connection_cancel) ) {
                if (packet[5] == 0){
                    bt_flip_addr(address, &packet[6]);
                    // CONNECTION TERMINATED BY LOCAL HOST (0X16)
                    l2cap_handle_connection_failed_for_addr(address, 0x16);
                }
            }
            break;
            
        // handle disconnection complete events
        case HCI_EVENT_DISCONNECTION_COMPLETE:
            // send l2cap disconnect events for all channels on this handle
            handle = READ_BT_16(packet, 3);
            linked_item_t *it;
            for (it = (linked_item_t *) l2cap_channels; it ; it = it->next){
                l2cap_channel_t * channel = (l2cap_channel_t *) it;
                if ( channel->handle == handle ){
                    l2cap_finialize_channel_close(channel);
                }
            }
            break;
            
        // HCI Connection Timeouts
        case L2CAP_EVENT_TIMEOUT_CHECK:
            if (!capture_connection){
                hci_con_handle_t handle = READ_BT_16(packet, 2);
                linked_item_t *it;
                l2cap_channel_t * channel;
                int used = 0;
                for (it = (linked_item_t *) l2cap_channels; it ; it = it->next){
                    channel = (l2cap_channel_t *) it;
                    if (channel->handle == handle) {
                        used = 1;
                    }
                }
                if (!used) {
                    hci_send_cmd(&hci_disconnect, handle, 0x13); // remote closed connection             
                }
            }
            break;
            
        default:
            break;
    }
    
    // pass on
    (*event_packet_handler)(packet, size);
}

static void l2cap_handle_disconnect_request(l2cap_channel_t *channel, uint16_t identifier){
    l2cap_send_signaling_packet( channel->handle, DISCONNECTION_RESPONSE, identifier, channel->dest_cid, channel->source_cid);   
    l2cap_finialize_channel_close(channel);
}

static void l2cap_handle_connection_request(hci_con_handle_t handle, uint8_t sig_id, uint16_t psm, uint16_t dest_cid){
    
    // printf("l2cap_handle_connection_request for handle %u, psm %u cid %u\n", handle, psm, dest_cid);
    l2cap_service_t *service = l2cap_get_service(psm);
    if (!service) {
        // 0x0002 PSM not supported
        // printf("l2cap_handle_connection_request no PSM for psm %u/n", psm);
        l2cap_send_signaling_packet(handle, CONNECTION_RESPONSE, sig_id, 0, 0, 0x0002, 0);
        return;
    }
    
    hci_connection_t * hci_connection = connection_for_handle( handle );
    if (!hci_connection) {
        fprintf(stderr, "no hci_connection for handle %u\n", handle);
        // TODO: emit error
        return;
    }
    // alloc structure
    // printf("l2cap_handle_connection_request register channel\n");
    l2cap_channel_t * channel = malloc(sizeof(l2cap_channel_t));
    // TODO: emit error event
    if (!channel) return;
    
    // fill in 
    BD_ADDR_COPY(channel->address, hci_connection->address);
    channel->psm = psm;
    channel->handle = handle;
    channel->connection = service->connection;
    channel->source_cid = l2cap_next_source_cid();
    channel->dest_cid   = dest_cid;
        
    // set initial state
    channel->state = L2CAP_STATE_WAIT_CLIENT_ACCEPT_OR_REJECT;
    
    // temp. store req sig id
    channel->sig_id = sig_id; 
    
    // add to connections list
    linked_list_add(&l2cap_channels, (linked_item_t *) channel);
    
    // emit incoming connection request
    l2cap_emit_connection_request(channel);
}

void l2cap_accept_connection_internal(uint16_t source_cid){
    l2cap_channel_t * channel = l2cap_get_channel_for_source_cid(source_cid);
    if (!channel) {
        fprintf(stderr, "l2cap_accept_connection_internal called but source_cid 0x%x not found", source_cid);
        return;
    }

    // accept connection
    l2cap_send_signaling_packet(channel->handle, CONNECTION_RESPONSE, channel->sig_id, channel->dest_cid, channel->source_cid, 0, 0);

    // set real sig and state and start config
    channel->sig_id = l2cap_next_sig_id();
    channel->state  = L2CAP_STATE_WAIT_CONFIG_REQ_RSP_OR_CONFIG_REQ;
    l2cap_send_signaling_packet(channel->handle, CONFIGURE_REQUEST, channel->sig_id, channel->dest_cid, 0, 4, &config_options);
}

void l2cap_decline_connection_internal(uint16_t source_cid, uint8_t reason){
    l2cap_channel_t * channel = l2cap_get_channel_for_source_cid( source_cid);
    if (!channel) {
        fprintf(stderr, "l2cap_decline_connection_internal called but source_cid 0x%x not found", source_cid,reason);
        return;
    }
    l2cap_send_signaling_packet(channel->handle, CONNECTION_RESPONSE, channel->sig_id, 0, 0, reason, 0);

    // discard channel
    linked_list_remove(&l2cap_channels, (linked_item_t *) channel);
    free (channel);
}

void l2cap_signaling_handler(l2cap_channel_t *channel, uint8_t *packet, uint16_t size){
        
    uint8_t  code       = READ_L2CAP_SIGNALING_CODE( packet );
    uint8_t  identifier = READ_L2CAP_SIGNALING_IDENTIFIER( packet );
    uint16_t result = 0;
    
    switch (channel->state) {
            
        case L2CAP_STATE_WAIT_CONNECT_RSP:
            switch (code){
                case CONNECTION_RESPONSE:
                    result = READ_BT_16 (packet, L2CAP_SIGNALING_DATA_OFFSET+4);
                    switch (result) {
                        case 0:
                            // successful connection
                            channel->dest_cid = READ_BT_16(packet, L2CAP_SIGNALING_DATA_OFFSET);
                            channel->sig_id = l2cap_next_sig_id();
                            l2cap_send_signaling_packet(channel->handle, CONFIGURE_REQUEST, channel->sig_id, channel->dest_cid, 0, 4, &config_options);
                            channel->state = L2CAP_STATE_WAIT_CONFIG_REQ_RSP_OR_CONFIG_REQ;
                            break;
                        case 1:
                            // connection pending. get some coffee
                            break;
                        default:
                            // map l2cap connection response result to BTstack status enumeration
                            l2cap_emit_channel_opened(channel, L2CAP_CONNECTION_RESPONSE_RESULT_SUCCESSFUL + result);
                            break;
                    }
                    break;
                    
                case DISCONNECTION_REQUEST:
                    l2cap_handle_disconnect_request(channel, identifier);
                    break;
                    
                default:
                    //@TODO: implement other signaling packets
                    break;
            }
            break;

        case L2CAP_STATE_WAIT_CONFIG_REQ_RSP_OR_CONFIG_REQ:
            switch (code) {
                case CONFIGURE_RESPONSE:
                    channel->state = L2CAP_STATE_WAIT_CONFIG_REQ;
                    break;
                case CONFIGURE_REQUEST:
                    // accept the other's configuration options
                    l2cap_send_signaling_packet(channel->handle, CONFIGURE_RESPONSE, identifier, channel->dest_cid, 0, 0, size - 16, &packet[16]);
                    channel->state = L2CAP_STATE_WAIT_CONFIG_REQ_RSP;
                    break;
                case DISCONNECTION_REQUEST:
                    l2cap_handle_disconnect_request(channel, identifier);
                    break;
                default:
                    //@TODO: implement other signaling packets
                    break;
            }
            break;
            
        case L2CAP_STATE_WAIT_CONFIG_REQ:
            switch (code) {
                case CONFIGURE_REQUEST:
                    // accept the other's configuration options
                    l2cap_send_signaling_packet(channel->handle, CONFIGURE_RESPONSE, identifier, channel->dest_cid, 0, 0, size - 16, &packet[16]);
                    channel->state = L2CAP_STATE_OPEN;
                    l2cap_emit_channel_opened(channel, 0);  // success
                    break;
                case DISCONNECTION_REQUEST:
                    l2cap_handle_disconnect_request(channel, identifier);
                    break;
                default:
                    //@TODO: implement other signaling packets
                    break;
            }
            break;
            
        case L2CAP_STATE_WAIT_CONFIG_REQ_RSP:
            switch (code) {
                case CONFIGURE_RESPONSE:
                    channel->state = L2CAP_STATE_OPEN;
                    l2cap_emit_channel_opened(channel, 0);  // success
                    break;
                case DISCONNECTION_REQUEST:
                    l2cap_handle_disconnect_request(channel, identifier);
                    break;
                default:
                    //@TODO: implement other signaling packets
                    break;
            }
            break;
            
        case L2CAP_STATE_WAIT_DISCONNECT:
            switch (code) {
                case DISCONNECTION_RESPONSE:
                    l2cap_finialize_channel_close(channel);
                    break;
                case DISCONNECTION_REQUEST:
                    l2cap_handle_disconnect_request(channel, identifier);
                    break;
                default:
                    //@TODO: implement other signaling packets
                    break;
            }
            break;
            
        case L2CAP_STATE_CLOSED:
            // @TODO handle incoming requests
            break;
            
        case L2CAP_STATE_OPEN:
            switch (code) {
                case DISCONNECTION_REQUEST:
                    l2cap_handle_disconnect_request(channel, identifier);
                    break;
                default:
                    //@TODO: implement other signaling packets, e.g. re-configure
                    break;
            }
            break;
    }
}

// finalize closed channel
void l2cap_finialize_channel_close(l2cap_channel_t *channel){
    channel->state = L2CAP_STATE_CLOSED;
    l2cap_emit_channel_closed(channel);
    
    // discard channel
    linked_list_remove(&l2cap_channels, (linked_item_t *) channel);
    free (channel);
}

l2cap_service_t * l2cap_get_service(uint16_t psm){
    linked_item_t *it;
    
    // close open channels
    for (it = (linked_item_t *) l2cap_services; it ; it = it->next){
        l2cap_service_t * service = ((l2cap_service_t *) it);
        if ( service->psm == psm){
            return service;
        };
    }
    return NULL;
}

void l2cap_register_service_internal(connection_t *connection, uint16_t psm, uint16_t mtu){
    // check for alread registered psm // TODO: emit error event
    l2cap_service_t *service = l2cap_get_service(psm);
    if (service) return;
    
    // alloc structure     // TODO: emit error event
    service = malloc(sizeof(l2cap_service_t));
    if (!service) return;
    
    // fill in 
    service->psm = psm;
    service->mtu = mtu;
    service->connection = connection;

    // add to services list
    linked_list_add(&l2cap_services, (linked_item_t *) service);
}

void l2cap_unregister_service_internal(connection_t *connection, uint16_t psm){
    l2cap_service_t *service = l2cap_get_service(psm);
    if (service) return;
    linked_list_remove(&l2cap_services, (linked_item_t *) service);
    free( service );
}

//
void l2cap_close_connection(connection_t *connection){
    linked_item_t *it;
    
    // close open channels
    l2cap_channel_t * channel;
    for (it = (linked_item_t *) l2cap_channels; it ; it = it->next){
        channel = (l2cap_channel_t *) it;
        if (channel->connection == connection) {
            channel->sig_id = l2cap_next_sig_id();
            l2cap_send_signaling_packet( channel->handle, DISCONNECTION_REQUEST, channel->sig_id, channel->dest_cid, channel->source_cid);   
            channel->state = L2CAP_STATE_WAIT_DISCONNECT;
        }
    }   
    
    // unregister services
    l2cap_service_t *service;
    for (it = (linked_item_t *) &l2cap_services; it ; it = it->next){
        channel = (l2cap_channel_t *) it->next;
        if (service->connection == connection){
            it->next = it->next->next;
            return;
        }
    }
}

//  notify client
void l2cap_emit_channel_opened(l2cap_channel_t *channel, uint8_t status) {
    uint8_t event[17];
    event[0] = L2CAP_EVENT_CHANNEL_OPENED;
    event[1] = sizeof(event) - 2;
    event[2] = status;
    bt_flip_addr(&event[3], channel->address);
    bt_store_16(event,  9, channel->handle);
    bt_store_16(event, 11, channel->psm);
    bt_store_16(event, 13, channel->source_cid);
    bt_store_16(event, 15, channel->dest_cid);
    socket_connection_send_packet(channel->connection, HCI_EVENT_PACKET, 0, event, sizeof(event));
}

void l2cap_emit_channel_closed(l2cap_channel_t *channel) {
    uint8_t event[4];
    event[0] = L2CAP_EVENT_CHANNEL_CLOSED;
    event[1] = sizeof(event) - 2;
    bt_store_16(event, 2, channel->source_cid);
    socket_connection_send_packet(channel->connection, HCI_EVENT_PACKET, 0, event, sizeof(event));
}

void l2cap_emit_connection_request(l2cap_channel_t *channel) {
    uint8_t event[16];
    event[0] = L2CAP_EVENT_INCOMING_CONNECTION;
    event[1] = sizeof(event) - 2;
    bt_flip_addr(&event[2], channel->address);
    bt_store_16(event,  8, channel->handle);
    bt_store_16(event, 10, channel->psm);
    bt_store_16(event, 12, channel->source_cid);
    bt_store_16(event, 14, channel->dest_cid);
    socket_connection_send_packet(channel->connection, HCI_EVENT_PACKET, 0, event, sizeof(event));
}
void l2cap_acl_handler( uint8_t *packet, uint16_t size ){
    
    // Capturing?
    if (capture_connection) {
        socket_connection_send_packet(capture_connection, HCI_ACL_DATA_PACKET, 0, packet, size);
        return;
    }
    
    // forward to higher layers - not needed yet
    // (*data_packet_handler)(channel_id, packet, size);
    
    // Get Channel ID and command code 
    uint16_t channel_id = READ_L2CAP_CHANNEL_ID(packet); 
    uint8_t  code       = READ_L2CAP_SIGNALING_CODE( packet );
    
    // Get Connection
    hci_con_handle_t handle = READ_ACL_CONNECTION_HANDLE(packet);
    
    // printf("l2cap_acl_handler channel %u, code %u\n", channel_id, code);
    
    // Signaling Packet?
    if (channel_id == 1) {
        
        if (code < 1 || code >= 8){
            // not for a particular channel, and not CONNECTION_REQUEST 
            return;
        }
        
        // Get Signaling Identifier
        uint8_t sig_id    = READ_L2CAP_SIGNALING_IDENTIFIER(packet);

        // CONNECTION_REQUEST
        if (code == CONNECTION_REQUEST){
            uint16_t psm =      READ_BT_16(packet, L2CAP_SIGNALING_DATA_OFFSET);
            uint16_t dest_cid = READ_BT_16(packet, L2CAP_SIGNALING_DATA_OFFSET+2);
            l2cap_handle_connection_request(handle, sig_id, psm, dest_cid);
            return;
        }
        
        // Get potential destination CID
        uint16_t dest_cid = READ_BT_16(packet, L2CAP_SIGNALING_DATA_OFFSET);

        // Find channel for this sig_id and connection handle
        linked_item_t *it;
        for (it = (linked_item_t *) l2cap_channels; it ; it = it->next){
            l2cap_channel_t * channel = (l2cap_channel_t *) it;
            if (channel->handle == handle) {
                if (code & 1) {
                    // match odd commands by previous signaling identifier 
                    if (channel->sig_id == sig_id) {
                        l2cap_signaling_handler( channel, packet, size);
                    }
                } else {
                    // match even commands by source channel id
                    if (channel->source_cid == dest_cid) {
                        l2cap_signaling_handler( channel, packet, size);
                    }
                }
            }
        }
        return;
    }
    
    // Find channel for this channel_id and connection handle
    l2cap_channel_t * channel = l2cap_get_channel_for_source_cid(channel_id);
    if (channel) {
        socket_connection_send_packet(channel->connection, L2CAP_DATA_PACKET, channel_id,
                                      &packet[COMPLETE_L2CAP_HEADER], size-COMPLETE_L2CAP_HEADER);
    }
}


void l2cap_send_internal(uint16_t source_cid, uint8_t *data, uint16_t len){
    // find channel for source_cid, construct l2cap packet and send
    l2cap_channel_t * channel = l2cap_get_channel_for_source_cid(source_cid);
    if (channel) {
         // 0 - Connection handle : PB=10 : BC=00 
         bt_store_16(acl_buffer, 0, channel->handle | (2 << 12) | (0 << 14));
         // 2 - ACL length
         bt_store_16(acl_buffer, 2,  len + 4);
         // 4 - L2CAP packet length
         bt_store_16(acl_buffer, 4,  len + 0);
         // 6 - L2CAP channel DEST
         bt_store_16(acl_buffer, 6, channel->dest_cid);
         // 8 - data
         memcpy(&acl_buffer[8], data, len);
         // send
         hci_send_acl_packet(acl_buffer, len+8);
     }
}

void l2cap_set_capture_connection(connection_t * connection){
    capture_connection = connection;
}

    