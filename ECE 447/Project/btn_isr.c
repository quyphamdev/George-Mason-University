#include "btn_isr.h"
#include "Bluetooth.h"

const char BTRemoteCmd[] = "AT+ZV RemoteCommand E\r\n";
const char BTDiscovery[] = "AT+ZV Discovery All All true\r\n";
const char BTHostEvent[] = "AT+ZV HostEvent E\r\n";
const char BTShowSettings[] = "AT+ZV ShowSettings\r\n";
const char BTName[] = "AT+ZV DefaultLocalName QuyPhamBT\r\n";
const char BTBond[] = "AT+ZV Bond 041E6415A3C7 1234\r\n";

char cnt = 0;

void setupBtnISR(void)
{
  P1DIR &= ~(BIT0+BIT1+BIT2); // input
  P1IE |= BIT0+BIT1+BIT2; // intterupt on button SW1&SW2
  P1IES |= BIT0+BIT1+BIT2; // detect on falling edge
  P1IFG &= ~(BIT0+BIT1+BIT2); // clear any initial int on start up
}

#pragma vector = PORT1_VECTOR
__interrupt void BTN_ISR(void)
{
  if(P1IFG & BIT0) // button SW1 pressed
  {    
    //U1TXBUF = 'A'; // send random msg out to the connected device
    //UCA0TXBUF = 'A'; // send random msg out to the connected device
    LCDPrintStrAt(2,0,"Bonding..");
    //BT_Send(BTShowSettings, sizeof(BTShowSettings));    
    BT_Send(BTBond, sizeof(BTBond));
  }
  else
  {
    if(P1IFG & BIT1) // button SW2 pressed
    {
      //BT_Send(BTRemoteCmd, sizeof(BTRemoteCmd));
      //BT_Send(BTDiscovery, sizeof(BTDiscovery));
      LCDPrintStrAt(2,0,"Name.");
      //BT_Send(BTHostEvent, sizeof(BTHostEvent));
      BT_Send(BTName, sizeof(BTName));
      U1TXBUF = 'A'; // send random msg out to the connected device
    }
    else if(P1IFG & BIT2) // value change on P1.2
    {
      cnt++;
      LCDPrintCharAt(2,5,cnt);
    }
  }
  P1IFG &= ~(BIT0+BIT1+BIT2); // clear int flag in the way out  
}