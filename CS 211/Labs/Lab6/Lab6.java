/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Lab 6: (Lab6.java)
 *
 * Description:
 *      A program which gets 2 positive interger numbers from user and
 * calculate the greatest common divisor.
 * Date: 4/01/2010
 */

import java.util.*;
import java.lang.*;

public class Lab6
{
    public static void main(String args[])
    {
        int num1, num2, maxNum, minNum, remainder;
        // use for take user input
        Scanner kbd = new Scanner(System.in);
        System.out.print("Enter a positive number: ");
        num1 = kbd.nextInt(); // get first number
        System.out.print("Enter another positive number: ");
        num2 = kbd.nextInt(); // second number
        maxNum = Math.max(num1, num2); // get the bigger number of the two
        minNum = Math.min(num1, num2); // get the smaller number of the two
        remainder = 1; // any number can be divided by 1, set it as default
        do // loop
        {
            remainder = maxNum % minNum;
            if (remainder != 0)
            {
                maxNum = minNum;
                minNum = remainder;
            }
        } while(remainder != 0); // until remainder = 0
        // print out the result
        System.out.printf("The Greatest Common Divisor is: %d", minNum);
    }

}