/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Lab 3: (Lab3.java)
 *
 * Description:
 *      There are two generators which generate two random values for a number
 *      of runs that was entered by the user, compares and output which generator
 *      is a winner for the total runs when it's value greater than the other.
 * Date: 2/18/2010
 */

import java.util.*;
import java.lang.*;
import java.io.*;

public class Lab3
{
    public static void main(String[] args)
    {
        Random r_num1 = new Random();
        Random r_num2 = new Random();
        int num1, num2;
        int num_of_run;
        int firstGenCnt, secondGenCnt, tie;
        firstGenCnt = secondGenCnt = tie = 0;
        Scanner kbd = new Scanner(System.in);
        System.out.print("How many run do you refer ? ");
        num_of_run = kbd.nextInt();
        for(int i=0; i<num_of_run; i++)
        {
            num1 = r_num1.nextInt(100)+1;
            num2 = r_num2.nextInt(100)+1;
            if(num1 > num2)
                firstGenCnt++;
            else if(num1 < num2)
                secondGenCnt++;
            else
                tie++;
        }
        if(firstGenCnt > secondGenCnt)
            System.out.println("First generator wins with " + firstGenCnt +" to "+ secondGenCnt +" with "+ tie +" tie");
        else if(firstGenCnt < secondGenCnt)
            System.out.println("Second generator wins with " + secondGenCnt +" to "+ firstGenCnt +" with "+ tie +" tie");
        else
            System.out.println("No winner: "+ tie +" tie");
    }

}