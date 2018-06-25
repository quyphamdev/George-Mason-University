/*
 *  rfcomm.c
 *  BluetoothECG
 *
 *  Created by Quy Pham on 2/20/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */


/**
 * @param credits - only used for RFCOMM flow control in UIH wiht P/F = 1
 */
#import "rfcomm.h"

void rfcomm_send_packet(uint16_t source_cid, uint8_t address, uint8_t control, uint8_t credits, uint8_t *data, uint16_t len){
	
	uint16_t pos = 0;
	uint8_t crc_fields = 3;
	
	rfcomm_out_buffer[pos++] = address;
	rfcomm_out_buffer[pos++] = control;
	
	// length field can be 1 or 2 octets
	if (len < 128){
		rfcomm_out_buffer[pos++] = (len << 1)| 1;     // bits 0-6
	} else {
		rfcomm_out_buffer[pos++] = (len & 0x7f) << 1; // bits 0-6
		rfcomm_out_buffer[pos++] = len >> 7;          // bits 7-14
		crc_fields++;
	}
	
	// add credits for UIH frames when PF bit is set
	if (control == BT_RFCOMM_UIH_PF){
		rfcomm_out_buffer[pos++] = credits;
	}
	
	// copy actual data
	memcpy(&rfcomm_out_buffer[pos], data, len);
	pos += len;
	
	// UIH frames only calc FCS over address + control (5.1.1)
	if ((control & 0xef) == BT_RFCOMM_UIH){
		crc_fields = 2;
	}
	rfcomm_out_buffer[pos++] =  crc8_calc(rfcomm_out_buffer, crc_fields); // calc fcs
    bt_send_l2cap( source_cid, rfcomm_out_buffer, pos);
}

void _bt_rfcomm_send_sabm(uint16_t source_cid, uint8_t initiator, uint8_t channel)
{
	uint8_t address = (1 << 0) | (initiator << 1) |  (initiator << 1) | (channel << 3); 
	rfcomm_send_packet(source_cid, address, BT_RFCOMM_SABM, 0, NULL, 0);
}

void _bt_rfcomm_send_uih_data(uint16_t source_cid, uint8_t initiator, uint8_t channel, uint8_t *data, uint16_t len) {
	uint8_t address = (1 << 0) | (initiator << 1) |  (initiator << 1) | (channel << 3); 
	rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH, 0, data, len);
}       

void _bt_rfcomm_send_uih_msc_cmd(uint16_t source_cid, uint8_t initiator, uint8_t channel, uint8_t signals)
{
	uint8_t address = (1 << 0) | (initiator << 1); // EA and C/R bit set - always server channel 0
	uint8_t payload[4]; 
	uint8_t pos = 0;
	payload[pos++] = BT_RFCOMM_MSC_CMD;
	payload[pos++] = 2 << 1 | 1;  // len
	payload[pos++] = (1 << 0) | (1 << 1) | (0 << 2) | (channel << 3); // shouldn't D = initiator = 1 ?
	payload[pos++] = signals;
	rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH, 0, (uint8_t *) payload, pos);
}

void _bt_rfcomm_send_uih_pn_command(uint16_t source_cid, uint8_t initiator, uint8_t channel, uint16_t max_frame_size){
	uint8_t payload[10];
	uint8_t address = (1 << 0) | (initiator << 1); // EA and C/R bit set - always server channel 0
	uint8_t pos = 0;
	payload[pos++] = BT_RFCOMM_PN_CMD;
	payload[pos++] = 8 << 1 | 1;  // len
	payload[pos++] = channel << 1;
	payload[pos++] = 0xf0; // pre defined for Bluetooth, see 5.5.3 of TS 07.10 Adaption for RFCOMM
	payload[pos++] = 0; // priority
	payload[pos++] = 0; // max 60 seconds ack
	payload[pos++] = max_frame_size & 0xff; // max framesize low
	payload[pos++] = max_frame_size >> 8;   // max framesize high
	payload[pos++] = 0x00; // number of retransmissions
	payload[pos++] = 0x00; // unused error recovery window
	rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH, 0, (uint8_t *) payload, pos);
}

static void hex_dump(void *data, int size)
{
    /* dumps size bytes of *data to stdout. Looks like:
     * [0000] 75 6E 6B 6E 6F 77 6E 20
     *                  30 FF 00 00 00 00 39 00 unknown 0.....9.
     * (in a single line of course)
     */
	
    unsigned char *p = data;
    unsigned char c;
    int n;
    char bytestr[4] = {0};
    char addrstr[10] = {0};
    char hexstr[ 16*3 + 5] = {0};
    char charstr[16*1 + 5] = {0};
    for(n=1;n<=size;n++) {
        if (n%16 == 1) {
            /* store address for this line */
            snprintf(addrstr, sizeof(addrstr), "%.4x",
					 ((unsigned int)p-(unsigned int)data) );
        }
		
        c = *p;
        if (isalnum(c) == 0) {
            c = '.';
        }
		
        /* store hex str (for left side) */
        snprintf(bytestr, sizeof(bytestr), "%02X ", *p);
        strncat(hexstr, bytestr, sizeof(hexstr)-strlen(hexstr)-1);
		
        /* store char str (for right side) */
        snprintf(bytestr, sizeof(bytestr), "%c", c);
        strncat(charstr, bytestr, sizeof(charstr)-strlen(charstr)-1);
		
        if(n%16 == 0) {
            /* line completed */
            printf("[%4.4s]   %-50.50s  %s\n", addrstr, hexstr, charstr);
            hexstr[0] = 0;
            charstr[0] = 0;
        } else if(n%8 == 0) {
            /* half line: add whitespaces */
            strncat(hexstr, "  ", sizeof(hexstr)-strlen(hexstr)-1);
            strncat(charstr, " ", sizeof(charstr)-strlen(charstr)-1);
        }
        p++; /* next byte */
    }
	
    if (strlen(hexstr) > 0) {
        /* print rest of buffer if not empty */
        printf("[%4.4s]   %-50.50s  %s\n", addrstr, hexstr, charstr);
    }
}
