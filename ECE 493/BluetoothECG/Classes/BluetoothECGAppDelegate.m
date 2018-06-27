//
//  BluetoothECGAppDelegate.m
//  BluetoothECG
//
//  Created by Quy Pham on 2/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BluetoothECGAppDelegate.h"
#import "BTInquiryViewController.h"
#import "btstack.h"
#import "run_loop.h"
#import "hci_cmds.h"
#import "BTDevice.h"
#import "rfcomm.h"
#import "ECGSketch.h"

uint16_t l2capECGChannelHandle = 0;
BluetoothECGAppDelegate *mainApp;
UINavigationController *navControl;
ECGSketch *ecgSketchControl;

/*
 * variables for rfcomm
 */
//bd_addr_t addr = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; 
int RFCOMM_CHANNEL_ID = 1;
char PIN[] = "12345";

int DEBUG = 0;

hci_con_handle_t con_handle;
uint16_t source_cid;
int fifo_fd;
// end - rfcomm



@implementation BluetoothECGAppDelegate

@synthesize window;
@synthesize inqViewControl;
//@synthesize navControl;


#pragma mark -
#pragma mark Application lifecycle

/********************************************
 * START OF UPLOADING PRCEDURES
 * in progress...
 * These were test code. Option to upload ECG data to server was not needed.
 */
- (void) uploadData:(char *)data {
	NSString *encodedData = [[[NSString alloc] initWithCString:data] stringByAddingPercentEscapesUsingEncoding:4];
	NSString *urlStr = [NSString stringWithFormat:@"http://mycodeteacher.com/server/login.php?username=%@",encodedData];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
	NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	if(urlConnection) {
		receivedData = [[NSMutableData alloc] init];
	} else {
		UIAlertView *eView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Connection problem to the Server !!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[eView show];
		[eView release];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connection release];
	[receivedData release];
	
	UIAlertView *eView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There was a problem connecting to the MyCodeTeacher server." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[eView show];
	[eView release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *finalString = [NSString stringWithCString:(const char *)[receivedData bytes]];
	if([finalString isEqualToString:@"success"]){
		UIAlertView *sView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You have successfully logged in!" delegate:nil cancelButtonTitle:@"Great!" otherButtonTitles:nil];
		[sView show];
		[sView release];
	} else {
		UIAlertView *eView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Invalid login information!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[eView show];
		[eView release];
	}
}

/*
 * END OF UPLOADING PRCEDURES
 ********************************************/


void packet_handler(uint8_t packet_type, uint16_t channel, uint8_t *packet, uint16_t size)
{
	bd_addr_t event_addr;
	
	static uint8_t msc_resp_send = 0;
	static uint8_t msc_resp_received = 0;
	static uint8_t credits_used = 0;
	static uint8_t credits_free = 0;
	uint8_t packet_processed = 0;
	
	switch (packet_type) {
			
		case L2CAP_DATA_PACKET:
			// rfcomm: data[8] = addr
			// rfcomm: data[9] = command
			
			//      received 1. message BT_RF_COMM_UA
			if (size == 4 && packet[1] == BT_RFCOMM_UA && packet[0] == 0x03){
				packet_processed++;
				NSLog(@"Received RFCOMM unnumbered acknowledgement for channel 0 - multiplexer working");
				NSLog(@"Sending UIH Parameter Negotiation Command");
				_bt_rfcomm_send_uih_pn_command(source_cid, 1, RFCOMM_CHANNEL_ID, 100);
			}
			
			//  received UIH Parameter Negotiation Response
			if (size == 14 && packet[1] == BT_RFCOMM_UIH && packet[3] == BT_RFCOMM_PN_RSP){
				packet_processed++;
				NSLog(@"UIH Parameter Negotiation Response");
				NSLog(@"Sending SABM #%u", RFCOMM_CHANNEL_ID);
				_bt_rfcomm_send_sabm(source_cid, 1, RFCOMM_CHANNEL_ID);
			}
			
			//      received 2. message BT_RF_COMM_UA
			if (size == 4 && packet[1] == BT_RFCOMM_UA && packet[0] == ((RFCOMM_CHANNEL_ID << 3) | 3) ){
				packet_processed++;
				NSLog(@"Received RFCOMM unnumbered acknowledgement for channel %u - channel opened", RFCOMM_CHANNEL_ID);
				NSLog(@"Sending MSC  'I'm ready'");
				_bt_rfcomm_send_uih_msc_cmd(source_cid, 1, RFCOMM_CHANNEL_ID, 0x8d);  // ea=1,fc=0,rtc=1,rtr=1,ic=0,dv=1
			}
			
			// received BT_RFCOMM_MSC_CMD
			if (size == 8 && packet[1] == BT_RFCOMM_UIH && packet[3] == BT_RFCOMM_MSC_CMD){
				packet_processed++;
				NSLog(@"Received BT_RFCOMM_MSC_CMD");
				NSLog(@"Responding to 'I'm ready'");
				// fine with this
				uint8_t address = packet[0] | 2; // set response 
				packet[3]  = BT_RFCOMM_MSC_RSP;  //  "      "
				rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH, 0x30, (uint8_t*)&packet[3], 4);
				msc_resp_send = 1;
			}
			
			// received BT_RFCOMM_MSC_RSP
			if (size == 8 && packet[1] == BT_RFCOMM_UIH && packet[3] == BT_RFCOMM_MSC_RSP){
				packet_processed++;
				msc_resp_received = 1;
			}
			
			if (packet[1] == BT_RFCOMM_UIH && packet[0] == ((RFCOMM_CHANNEL_ID<<3)|1)){
				packet_processed++;
				NSLog(@"if (packet[1] == BT_RFCOMM_UIH && packet[0] == ((RFCOMM_CHANNEL_ID<<3)|1))");
				
				credits_used++;
				/*
				if(DEBUG){
					NSLog(@"RX: address %02x, control %02x: ", packet[0], packet[1]);
					hexdump( (uint8_t*) &packet[3], size-4);
				}
				int written = 0;
				int length = size-4;
				int start_of_data = 3;
				//write data to fifo
				while (length) {
					if ((written = write(fifo_fd, &packet[start_of_data], length)) == -1) {
						NSLog(@"Error writing to FIFO\n");
					} else {
						length -= written;
					}
				}
				*/
				// Create a hex string of the serial packet
				unsigned char *p = &packet[3];
				int n;
				char buff[size-4];
				char hex_dump[32] = ""; // What does this have to be?
				char delim[4] = ":";
				for(n=1;n<=size-4;n++) {
					sprintf(buff, "%02x", *p);
					strcat(hex_dump, buff);
					if (n<size-4){
						strcat(hex_dump, delim);
					}
					p++;
				}
				
				NSLog(@"Hex dump BT_RFCOMM_UIH: %s", hex_dump);
				// upload data to the server
				[mainApp uploadData:hex_dump];
			}
			
			if (packet[1] == BT_RFCOMM_UIH_PF && packet[0] == ((RFCOMM_CHANNEL_ID<<3)|1)){
				packet_processed++;
				NSLog(@"if (packet[1] == BT_RFCOMM_UIH_PF && packet[0] == ((RFCOMM_CHANNEL_ID<<3)|1))");				
				
				credits_used++;
				if (!credits_free) {
					NSLog(@"Got %u credits, can send!\n", packet[2]);
				}				
				credits_free = packet[2];
				/*
				if(DEBUG){
					NSLog(@"RX: address %02x, control %02x: ", packet[0], packet[1]);
					hexdump( (uint8_t *) &packet[4], size-5);                               
				}
				int written = 0;
				int length = size-5;
				int start_of_data = 4;
				//write data to fifo
				while (length) {
					if ((written = write(fifo_fd, &packet[start_of_data], length)) == -1) {
						NSLog(@"Error writing to FIFO\n");
					} else {
						length -= written;
					}
				}
				*/
				// Create a hex string of the serial packet
				unsigned char *p = &packet[3];
				int n;
				char buff[size-5];
				char hex_dump[500] = ""; // What does this have to be?
				char delim[4] = ":";
				for(n=1;n<=size-5;n++) {
					sprintf(buff, "%02x", *p);
					strcat(hex_dump, buff);
					if (n<size-4){
						strcat(hex_dump, delim);
					}
					p++;
				}
				
				NSLog(@"Hex dump BT_RFCOMM_UIH_PF: %s", hex_dump);
				// upload data to the server
				[mainApp uploadData:hex_dump];
			}
			
			uint8_t send_credits_packet = 0;
			
			if (credits_used > 40) {	//>= 0x30 ) {
				send_credits_packet = 1;
				credits_used = 0;	//-= 0x30;
			}
			
			if (msc_resp_send && msc_resp_received) {
				send_credits_packet = 1;
				msc_resp_send = msc_resp_received = 0;
				
				NSLog(@"RFCOMM up and running!");
			}
			
			if (send_credits_packet) {
				// send 0x30 credits
				uint8_t initiator = 1;
				uint8_t address = (1 << 0) | (initiator << 1) |  (initiator << 1) | (RFCOMM_CHANNEL_ID << 3); 
				rfcomm_send_packet(source_cid, address, BT_RFCOMM_UIH_PF, 0x30, NULL, 0);
			}
			
			if (!packet_processed) {
				// just dump data for now
				NSLog(@"??: address %02x, control %02x: ", packet[0], packet[1]);
				//hexdump( packet, size );
			}			
			
			break;
			
		case HCI_EVENT_PACKET:
			
			switch (packet[0]){
					
				case BTSTACK_EVENT_POWERON_FAILED:
					// handle HCI init failure
					NSLog(@"HCI Init failed - make sure you have turned off Bluetooth in the System Settings");
					// bt_close();
					break;          
					
				case BTSTACK_EVENT_STATE:
					// bt stack activated, get started - set local name
					if (packet[2] == HCI_STATE_WORKING) {
						bt_send_cmd(&hci_write_local_name, "Quy's iPhone ECG");
					}
					break;
				/*	
				case HCI_EVENT_LINK_KEY_REQUEST:
					NSLog(@"Link key request");
					// link key request
					bt_flip_addr(event_addr, &packet[2]); 
					bt_send_cmd(&hci_link_key_request_negative_reply, &event_addr);
					break;
				*/	
				case HCI_EVENT_PIN_CODE_REQUEST:
					// inform about pin code request
					bt_flip_addr(event_addr, &packet[2]); 
					bt_send_cmd(&hci_pin_code_request_reply, &event_addr, 5, PIN);
					NSLog(@"Please enter PIN %s on remote device", PIN);
					UIAlertView* alertView = [[UIAlertView alloc] init];
					alertView.title = @"Bluetooth PIN";
					alertView.message = @"Please enter PIN '12345' on remote device";			
					[alertView addButtonWithTitle:@"Dismiss"];
					[alertView show];					
					break;
					
				case L2CAP_EVENT_CHANNEL_OPENED:
					if (packet[2] == 0) {
						// inform about new l2cap connection
						bt_flip_addr(event_addr, &packet[3]);
						uint16_t psm = READ_BT_16(packet, 11); 
						source_cid = READ_BT_16(packet, 13); 
						//l2capECGChannelHandle = READ_BT_16(packet, 9);
						con_handle = READ_BT_16(packet, 9);
						NSLog(@"Channel successfully opened: handle 0x%02x, psm 0x%02x, source cid 0x%02x, dest cid 0x%02x",
							  con_handle, psm, source_cid,  READ_BT_16(packet, 15));
						NSLog(@"Sending SABM #0");
						_bt_rfcomm_send_sabm(source_cid, 1, 0); // (source_cid, initiator, channel)						
						
						/***********************************
						 * make new view controller and start sketching ECG (using core-plot)
						 */
						ecgSketchControl = [[ECGSketch alloc] initWithNibName:@"ECGSketch" bundle:nil];
						[navControl pushViewController:ecgSketchControl animated:YES];
						
					} else {
						NSLog(@"L2CAP connection to device failed. Status code %u", packet[2]);
					}					
					break;

				case HCI_EVENT_DISCONNECTION_COMPLETE:
					// connection closed -> quit test app
					NSLog(@"Basebank connection closed, exit.");
					bt_close();
					break;
					
				case HCI_EVENT_COMMAND_COMPLETE:
					
					// use pairing yes/no
					if ( COMMAND_COMPLETE_EVENT(packet, hci_write_local_name) ) {
						bt_send_cmd(&hci_write_authentication_enable, 1);
					}
					/*
					// connect to RFCOMM device (PSM 0x03) at addr
					if ( COMMAND_COMPLETE_EVENT(packet, hci_write_authentication_enable) ) {
						bt_send_cmd(&l2cap_create_channel, addr, 0x03);
						NSLog(@"Turn on the Arduino BT");
					}
					*/
					break;
					
				default:
					// unhandled event
					break;
			}
			break;
			
		default:
			// unhandled packet type
			break;
	}
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{      
	NSLog(@"Started");
    // Override point for customization after app launch    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// create bluetooth inquiry view
	inqViewControl = [[BTInquiryViewController alloc] init];
	[inqViewControl setTitle:@"Bluetooh ECG"];
	[inqViewControl setDelegate:self];
	
	// create navigation view controller
	navControl = [[UINavigationController alloc] initWithRootViewController:inqViewControl];
	
	[window addSubview:[navControl view]];
    [window makeKeyAndVisible];
	
	mainApp = self;
	
	// start Bluetooth
	run_loop_init(RUN_LOOP_COCOA);
	
	int res = bt_open();
	if (res){
		UIAlertView* alertView = [[UIAlertView alloc] init];
		alertView.title = @"Bluetooth not accessible!";
		alertView.message = @"Connection to BTstack failed!\n"
		"Please make sure that BTstack is installed correctly.";
		NSLog(@"Alert: %@ - %@", alertView.title, alertView.message);
		[alertView addButtonWithTitle:@"Dismiss"];
		[alertView show];
	} else {
		bt_register_packet_handler(packet_handler);
		NSLog(@"Start Inquiry");
		[inqViewControl startInquiry];
	}
	
}


// BTInquiryDelegates

- (void) deviceChoosen:(BTInquiryViewController *) inqView device:(BTDevice*) device {
	NSLog(@"deviceChoosen %@", [device toString]);
	
	[inqViewControl stopInquiry];
	[inqViewControl showConnecting:device];
	
	// connect to devie
	[device setConnectionState:kBluetoothConnectionConnecting];
	[[inqViewControl tableView] reloadData];
	bt_send_cmd(&l2cap_create_channel, [device address], 0x03);
}

- (void) deviceDetected:(BTInquiryViewController *) inqView device:(BTDevice*) device {
	
	NSLog(@"deviceDetected %@", [device toString]);
	if ([device name] && [[device name] caseInsensitiveCompare:@"ECG Bluetooth"] == NSOrderedSame) {
		NSLog(@"Found ECG Bluetooth at address %@", [BTDevice stringForAddress:[device address]]);
		[inqViewControl stopInquiry];
		[inqViewControl showConnecting:device];
		
		// connect to device
		[device setConnectionState:kBluetoothConnectionConnecting];
		[[inqViewControl tableView] reloadData];
		bt_send_cmd(&l2cap_create_channel, [device address], 0x03); // 0x03 for rfcomm ?
	}
}

- (void) disconnectDevice:(BTInquiryViewController *) inqView device:(BTDevice*) device {
	
}

- (void) inquiryStopped {
	NSLog(@"inquiryStopped");
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// disconnect
	if (con_handle) {
		bt_send_cmd(&hci_disconnect, con_handle, 0x03); // remote close connection
	}
	NSLog(@"Closed");
	bt_close();
	
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[window release];
	[super dealloc];
}


@end

