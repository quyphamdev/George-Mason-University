#define RX_BUFFER_SIZE 200
#define TX_BUFFER_SIZE 100


extern char tx_pos;             // position in command being sent
extern char tx_len;            // length of command being sent
extern const char *p_tx_buff;  // pointer to command being sent
extern char rx_buffer [RX_BUFFER_SIZE];    // rx buffer!
extern char tx_buffer [TX_BUFFER_SIZE];    // tx buffer!

void configBT(void);
void BT_Send(const char buffer[], char len);
void initBT(void);