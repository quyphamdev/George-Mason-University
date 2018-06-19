//******************************************************************************
//   MSP430xG46x Demo - USART1, 115200 UART Echo ISR, DCO SMCLK
//
//   Description: Echo a received character, RX ISR used. Normal mode is LPM0.
//   USART1 RX interrupt triggers TX Echo.
//   Baud rate divider with 1048576hz = 1048576/115200 = ~9.1 (009h|08h)
//   ACLK = LFXT1 = 32768Hz, MCLK = SMCLK = default DCO = 32 x ACLK = 1048576Hz
//
//                MSP430FG4618
//             -----------------
//         /|\|                 |
//          | |                 | 
//          --|RST              |
//            |                 |
//            |       P4.0/UTXD1|------------>
//            |                 | 115200 - 8N1
//            |       P4.1/URXD1|<------------
//
//******************************************************************************

#include  <msp430xG46x.h>
#include "Bluetooth.h"
#include "lcd.h"

const char BTLocalName[] = "AT+ZV DefaultLocalName QPBluetooth\r\n";
const char BTEscape[] = "^#^$^%"; // used for escape to cmd mode from bypass mode, NO \r\n
                                  // follow with 2s of no data till BT respond back

static char tx_pos = 0;             // position in command being sent
static char tx_len  = 0;            // length of command being sent
static char rx_pos = 0;
static char rx_len = 0;
static const char *p_tx_buff;  // pointer to command being sent
char rx_buffer [RX_BUFFER_SIZE];    // rx buffer!
char tx_buffer [TX_BUFFER_SIZE];    // tx buffer!
static char BTConnected = 0;  // flag for indicating if bluetooth is connected
char BTCmdStr[20]; // contain received bluetooth command string, used for comparing
char counter = 0;

typedef enum{STATE_STARTUP=0, STATE_LOCALNAME, STATE_WAIT4CONNECTION, STATE_BYPASS} bt_rx_state;
static bt_rx_state BTState = STATE_STARTUP; // current bluetooth state

void configBT(void)
{
//  P4DIR |= BIT0; // ouput TX
//  P4DIR &= ~BIT1; // input RX  
  P4SEL |= BIT0+BIT1; // P4.1,0 = USART1 TXD/RXD
  P4DIR |= BIT2; // P4.2 = bluetooth Reset pin
  
  
  ME2 |= UTXE1 + URXE1;                     // Enable USART1 TXD/RXD
  U1CTL |= CHAR+SWRST;                            // 8-bit character
  U1TCTL |= SSEL1+SSEL0;                          // UCLK= SMCLK
  /* KC21 Bluetooth module runs at 115.2Kbps by default*/
  U1BR0 = 0x09;                             // 1MHz 115200
  U1BR1 = 0x00;                             // 1MHz 115200
  U1MCTL = 0x01;                            // 1MHz 115200 modulation
  U1CTL &= ~SWRST;                          // Initialize USART state machine
  IE2 |= URXIE1|UTXIE1;                     // Enable USART1 RX & TX interrupt
  IFG2 &= ~(URXIFG1|UTXIFG1);     // Clear inital flag on POR for interrupt to work correctly  

  //Reset Bluetooth
//  P4OUT &=(~BIT2);
//  int i=0; int j=0; int k;
//  //Delay a little
//  for (i=0;i<500;i++)
//   for(j=0;j<1000;j++)
//     k=i+j;
//  P4OUT |= BIT2;
//  for (i=0;i<2000;i++)
//   for(j=0;j<1000;j++)
//     k=i+j;

//  LCDPrintStrAt(2,0,"Reseted..");
  initBT();
  
}

void initBT(void)
{
  //BT_Send(BTHostEvent, sizeof(BTHostEvent));
  BT_Send(BTLocalName,sizeof(BTLocalName));
  //BT_Send(BTDiscovery, sizeof(BTDiscovery));
}

void BT_Send(const char buffer[], char len) {

  if (len){                     // if there is data to send

    while(tx_pos>0);            // wait until previous send is finished

    tx_pos = 0;
    tx_len = len;
    p_tx_buff = buffer;

    U1TXBUF = p_tx_buff[tx_pos++];   // send first char, the rest will be interrupt driven.
  }
}


#pragma vector = USART1RX_VECTOR
__interrupt void RX_ISR (void)
{
  char rx = U1RXBUF;
  if(BTConnected) // connection was established, recieved data only, expect no cmd
  {
    
  }
  else
  {
    switch(BTState)
    {
      case STATE_STARTUP:
                  LCDSetCurPos(2,0);
                  LCDPrintChar(rx);
        break;
      case STATE_LOCALNAME:
        break;
      case STATE_WAIT4CONNECTION:
        break;
      case STATE_BYPASS:
        break;
    }
  }
  IFG2 &= ~URXIFG1; // clear int flag in way out
}

#pragma vector = USART1TX_VECTOR
__interrupt void TX_ISR (void)
{
  /*
     A USART0 TX interrupt means MSP430 has finished sending a BYTE to the Bluetooth module.
     If there is more data to send, the interrupt handler sends it
  */
  
  if (tx_pos>=tx_len)   // command send finished
  {
    tx_pos = 0;
    LCDPrintStrAt(1,0,"CmdSent..");    
  }

  if(tx_pos>0)
  {                // command left to be sent
      U1TXBUF = p_tx_buff[tx_pos++];
  }
  else
  {                // not in the middle of a command.
    
  }  
  IFG2 &= ~UTXIFG1; // clear int flag in way out
}

//==========================================================================
// UCSI VERSION
//==========================================================================

//******************************************************************************
//   MSP430xG46x Demo - USCI_A0, 115200 UART Echo ISR, DCO SMCLK
//
//   Description: Echo a received character, RX ISR used. Normal mode is LPM0.
//   USCI_A0 RX interrupt triggers TX Echo.
//   Baud rate divider with 1048576hz = 1048576/115200 = ~9.1 (009h|01h)
//   ACLK = LFXT1 = 32768Hz, MCLK = SMCLK = default DCO = 32 x ACLK = 1048576Hz
//   //* An external watch crystal between XIN & XOUT is required for ACLK *//	
//
//                MSP430xG461x
//             -----------------
//         /|\|              XIN|-
//          | |                 | 32kHz
//          --|RST          XOUT|-
//            |                 |
//            |     P4.6/UCA0TXD|------------>
//            |                 | 115200 - 8N1
//            |     P4.7/UCA0RXD|<------------
//
//   K. Quiring/ M. Mitchell
//   Texas Instruments Inc.
//   October 2006
//   Built with CCE Version: 3.2.0 and IAR Embedded Workbench Version: 3.41A
//******************************************************************************

//#include  <msp430xG46x.h>
//#include "Bluetooth.h"
//#include "lcd.h"
//
//const char BTLocalName[] = "AT+ZV DefaultLocalName QPBluetooth\r\n";
//const char BTHostEvent[] = "AT+ZV HostEvent E\r\n";
//const char BTDiscovery[] = "AT+ZV Discovery All All true\r\n";
//const char BTEscape[] = "^#^$^%"; // used for escape to cmd mode from bypass mode, NO \r\n
//                                  // follow with 2s of no data till BT respond back
//
//static char tx_pos = 0;             // position in command being sent
//static char tx_len  = 0;            // length of command being sent
//static char rx_pos = 0;
//static char rx_len = 0;
//static const char *p_tx_buff;  // pointer to command being sent
//char rx_buffer [RX_BUFFER_SIZE];    // rx buffer!
//char tx_buffer [TX_BUFFER_SIZE];    // tx buffer!
//static char BTConnected = 0;  // flag for indicating if bluetooth is connected
//char BTCmdStr[20]; // contain received bluetooth command string, used for comparing
//char counter = 0;
//
//typedef enum{STATE_STARTUP=0, STATE_LOCALNAME, STATE_WAIT4CONNECTION, STATE_BYPASS} bt_rx_state;
//static bt_rx_state BTState = STATE_STARTUP; // current bluetooth state
//
//void configBT(void)
//{
//  P4SEL |= BIT6+BIT7; // P4.6,7 = USCI_A0 TXD/RXD  
//  UCA0CTL1 |= UCSSEL_2;   // SMCLK
//  UCA0BR0 = 0x09;   // 115.2k
//  UCA0BR1 = 0x00;   // 115.2k
//  UCA0MCTL = 0x01;  // modulation
//  UCA0CTL1 &= ~UCSWRST;   // init USCI state machine  
//  IE2 |= UCA0RXIE+UCA0TXIE;       // Enable USCI_A0 RX & TX interrupt
//  IFG2 &= ~(UCA0RXIFG|UCA0TXIFG);     // Clear inital flag on POR for interrupt to work correctly  
//
//  initBT();
//  
//}
//
//void initBT(void)
//{
//  //BT_Send(BTHostEvent, sizeof(BTHostEvent));
//  BT_Send(BTLocalName,sizeof(BTLocalName));
//  //BT_Send(BTDiscovery, sizeof(BTDiscovery));
//}
//
//void BT_Send(const char buffer[], char len) {
//
//  if (len){                     // if there is data to send
//
//    while(tx_pos>0);            // wait until previous send is finished
//
//    tx_pos = 0;
//    tx_len = len;
//    p_tx_buff = buffer;
//
//    UCA0TXBUF = p_tx_buff[tx_pos++];   // send first char, the rest will be interrupt driven.
//  }
//  return;
//}
//
//
//#pragma vector = USCIAB0RX_VECTOR
//__interrupt void UCSIA0_rx (void)
//{
//  char rx = UCA0RXBUF;
//  LCDPrintChar('a');
//  if(BTConnected) // connection was established, recieved data only, expect no cmd
//  {
//    
//  }
//  else
//  {
//    switch(BTState)
//    {
//      case STATE_STARTUP:
//                  LCDPrintChar(rx);
//        break;
//      case STATE_LOCALNAME:
//        break;
//      case STATE_WAIT4CONNECTION:
//        break;
//      case STATE_BYPASS:
//        break;
//    }
//  }
//  IFG2 &= ~UCA0RXIFG;     // Clear int flag  
//}
//
//#pragma vector = USCIAB0TX_VECTOR
//__interrupt void UCSIA0_tx (void)
//{
//  /*
//     A USART0 TX interrupt means MSP430 has finished sending a BYTE to the Bluetooth module.
//     If there is more data to send, the interrupt handler sends it
//  */
//  
//  if (tx_pos>=tx_len)   // command send finished
//  {
//    tx_pos = 0;
//    LCDPrintStrAt(1,0,"CmdSent..");
//  }
//
//  if(tx_pos>0)
//  {                // command left to be sent
//      UCA0TXBUF = p_tx_buff[tx_pos++];
//  }
//  else
//  {                // not in the middle of a command.
//    
//  }  
//  IFG2 &= ~UCA0TXIFG;     // Clear int flag  
//}
