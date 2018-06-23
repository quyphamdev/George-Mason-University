/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Lab8: Lab8.java
 *
 * Description: A program takes 2 integers from the console and print out
 * the representation of the first number base on the second number
 * 
 * Date: 5/04/2010
 */

public class Lab8
{
    public static void main(String[] args)
    {
        int num, base, remainder, idx;
        char[] hold = new char[20]; // to hold the character representation of a number

        idx = 0;

        if(args.length == 2) // 2 arguments, first is number, second is the base
        {                   // to represent the first number
            try
            {
                num = Integer.parseInt(args[0]); // convert string to integer number
                base = Integer.parseInt(args[1]);
                while(num > 0)
                {
                    remainder = num % base;
                    num /= base;
                    if((0 <= remainder) && (remainder < base))
                    {
                        // store the digit represented by remainder to hold[]
                        if(remainder < 10)
                        {
                            hold[idx] = (char)((int)'0' + remainder);
                        }
                        else
                        {
                            hold[idx] = (char)((int)'a' + remainder-10);
                        }
                        idx++; // advance to next position in array
                    }
                }
                // print out the result
                // it's in reverse order to have to print out backward
                for(int i=idx-1; i>=0; i--)
                {
                    System.out.print(hold[i]);
                }
            }
            catch(NumberFormatException e)
            {
                System.out.println("ERROR: Number format exception !!");
                System.exit(0);
            }
        }
        else
        {
            System.out.println("ERROR: There should be two arguments !!");
        }
    }
}