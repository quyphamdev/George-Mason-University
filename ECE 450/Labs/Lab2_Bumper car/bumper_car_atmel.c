//==================================
// Lab 2 - Bumper Car Extra Credit
// Team #6
// Quy Pham, Van Nguyen
//==================================

#include<avr/io.h>
#include<avr/interrupt.h>
#include <util/delay.h>

/*Port Definitions */
int RIGHT_MOTOR = 1; /* Motor Slot 0 */
int LEFT_MOTOR = 2; /* Motor Slot 2 */
int LEFT_BUMPER = 7;
int RIGHT_BUMPER = 15;

/* Logic */
#define TRUE 1
#define FALSE 0
/* Motor Commands */
#define REST 0
#define STOP 1
#define FORWARD 2
#define REVERSE 3
#define TURN_RIGHT 4
#define TURN_LEFT 5

/* Global Variables */
int reset_action;
int escape_action;
float escape_time;
int escape_bumper;

//#define LEFT_MOTOR 1
//#define RIGHT_MOTOR 2

unsigned int timecount = 0;
unsigned int mseconds = 0;

unsigned int start = FALSE;
unsigned int left = FALSE;
unsigned int right = FALSE;


void motor( int mtr, int speed)
{
	static int up;
	static int back;
	if(speed > 0)
	{
		up = speed;
		back = 0;
	}
	else if(speed<0)
	{
		up = 0;
		back = -speed;
	}
	else
	{
		up = 0;
		back = 0;
	}
	if(mtr == LEFT_MOTOR)
	{
		OCR0A = up;
		OCR0B = back;
	}
	else // right motor
	{
		OCR1A = up;
		OCR1B = back;
	}
}

void reset()
{
    if (!start)
      {
        reset_action = STOP;
    }
}


void motor_control(int motor_cmd) // Defines motor actions
{
    if (motor_cmd == FORWARD)
      {
        motor(LEFT_MOTOR,255);
        motor(RIGHT_MOTOR,255);
    }
    if (motor_cmd == REVERSE)
      {
        motor(LEFT_MOTOR,-255);
        motor(RIGHT_MOTOR,-255);
    }
    if (motor_cmd == TURN_RIGHT) // 45 right ????
      {
        motor(LEFT_MOTOR,100);
        motor(RIGHT_MOTOR,-10);
    }
    if (motor_cmd == TURN_LEFT) // 45 left ?????
      {
        motor(LEFT_MOTOR,-10);
        motor(RIGHT_MOTOR,100);
    }
    if (motor_cmd == STOP)
      {
        motor(LEFT_MOTOR,0);
        motor(RIGHT_MOTOR,0);
    }
}//end of motor_control definition

ISR (TIMER2_OVF_vect)
{
	TCNT2 = 6; /* start counting at 6 for 250 clock cycles */
	if (++timecount == 4) // every 4 interrupts equals one millisecond
	{
		timecount = 0;
		++ mseconds;
	}
}

unsigned int seconds()
{
	return mseconds;
}


void escape()
{ 
	if (escape_action == REST)
      { 
        if (left)
          {
            escape_bumper = LEFT_BUMPER;
            escape_action = REVERSE;
            escape_time = seconds() + 2.0;
			left = FALSE;

        }
        else if (right)
          {
            escape_bumper = RIGHT_BUMPER;
            escape_action = REVERSE;
            escape_time = seconds() + 2.0;
			right = FALSE;

        }
    }
    else if (escape_action == REVERSE)
      {
        if (seconds() > escape_time)
          {
            if (escape_bumper == LEFT_BUMPER)
              escape_action = TURN_RIGHT;
            else
              escape_action = TURN_LEFT;
            escape_time = seconds() + 1.0;
        }
    }
    else if (escape_action == TURN_LEFT || escape_action == TURN_RIGHT)
      {
        if (seconds() > escape_time)
          escape_action = REST;
    }
}

ISR( PCINT1_vect)
{
	unsigned int x = PINC;
	// button pressed, bit C4 is 0
	if(!(x & 0b00010000)) // start/stop
	{
		start = !start;
	}
	else if(!(x & 0b00001000)) // bumper left
	{
    	left = TRUE;
	}
	else if(!(x & 0b00000100)) // bumper right
	{
		right = TRUE;
	}	
}

int main (void)
{
	int motor_cmd;
    int old_motor_cmd;
    int flag;

	/* Left Motor */
	//Setup the PWM on pin 12 (PD6)
	TCCR0A = (3<<COM0A0)|(1<<WGM00) ; // Setup for 0 Volts when counter is low; Phase Correct PWM
	TCCR0B = (0<<WGM02)|(2<<CS00) ; // Use an 8-bit prescaler
	OCR0A = (unsigned int) 0; // Initialize motor so that it is off
	DDRD = (1<<PORTD6) ; // Don’t forget to set this pin as an output
	//Setup the PWM on pin 11 (PD5)
	TCCR0A = (3<<COM0B0)|TCCR0A ;// Setup for 0 Volts when counter is low; Phase Correct PWM
	OCR0B = (unsigned int) 0 ; // Initialize motor so that it is off
	DDRD = DDRD|(1<<PORTD5) ;// Don’t forget to set this pin as an output

		/* Right Motor */
	//Setup the PWM on pin 16 (PB2)
	TCCR1A = (3<<COM1A0)|(1<<WGM10) ; // Setup for 0 Volts when counter is low; Phase Correct PWM
	TCCR1B = (0<<WGM12)|(2<<CS10) ; // Use an 8-bit prescaler
	OCR1B = (unsigned int) 0; // Initialize motor so that it is off
	DDRB = (1<<PORTB2) ; // Don’t forget to set this pin as an output
	//Setup the PWM on pin 15 (PB1)
	TCCR1A = (3<<COM1B0)|TCCR1A ;// Setup for 0 Volts when counter is low; Phase Correct PWM
	OCR1A = (unsigned int) 0 ; // Initialize motor so that it is off
	DDRB = DDRB|(1<<PORTB1) ;// Don’t forget to set this pin as an output


	// Setup for External Interrupt PCINT12 (uses PC4 which is also pin 27)
	SREG = ( 1<<SREG_I );
	// timer
	TCCR2B = (2 << CS20); //Set prescaler to 8
	TCNT2 = 0; //Counter starts at 0 (will change in Interrupt)
	TIMSK2 = (1<<TOIE2); //Enables timer overflow interrupt

	PCICR = ( 1<<PCIE1 );
	PCMSK1 = ( 1<<PCINT12 )|( 1<<PCINT11 )|( 1<<PCINT10 );
	PORTC = ( 1<<PORTC4 )|( 1<<PORTC3 )|( 1<<PORTC2 ); //Use PC4,PC3,PC2,PC1's pull-up resistor

    
    while(TRUE)
      {
	  	while(!start){} // start_press();
        //Initialize the behaviors
        escape_action = REST;
        reset_action = REST;
        
        //Initialize local variables
        old_motor_cmd = -1;
        flag = TRUE;
        while(flag) //Arbitrate
          {            
            //Call Behaviors
            reset();
            escape();
            //Arbitration
            motor_cmd = FORWARD; //Default
            if (reset_action != REST)
              { 
                flag = FALSE;
                motor_cmd = reset_action;
            }
            else if (escape_action != REST)
              {
                motor_cmd = escape_action;
            }
            if (motor_cmd != old_motor_cmd)
              { 
                motor_control(motor_cmd);
                old_motor_cmd = motor_cmd;
            }
        }
    }
}
