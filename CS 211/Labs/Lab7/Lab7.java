/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Lab 7: (Lab7.java)
 *
 * Description:
 *      A program that takes one argument from command line for the file path
 * read the file's contain, calculate the sum of integers and also count the
 * number of non-integer and then output result to console.
 * Date: 4/19/2010
 */

import java.io.*;
import java.util.*;
import java.lang.*;

public class Lab7
{
    public static void main(String[] args)
    {
        File f;
        Scanner fscanner;
        int num, sum, countInt, countNotInt;
        String line;
        String[] items;

        // init
        sum = countInt = countNotInt = 0;

        if(args.length == 1)
        {
            try // try..catch block for file exception
            {
                // open a file to read
                // file path is in the first argument of args[]
                f = new File(args[0]);
                fscanner = new Scanner(f);
                while(fscanner.hasNext()) // any available data to read ?
                {
                    try // try..catch block for integer number
                    {
                        line = fscanner.next(); // read a line
                        items = line.split(" "); // each line contain items, saperated by space
                        for(int i=0; i<items.length; i++) // loop thru each item
                        {
                            num = Integer.parseInt(items[i]); // will throw exception if not int
                            countInt++; // count for integers
                            sum += num; // sum of all integers
                        }
                    }
                    catch(NumberFormatException ne) // not a legal integer
                    {
                        countNotInt++; // count for a not legal integer
                    }
                }
            }
            catch(FileNotFoundException fe)
            {
                System.out.println("ERROR: File not found !!");
                System.exit(0);
            }

            // print out result
            System.out.printf("Sum: %d with %d bad integer(s)\n", sum, countNotInt);
        }
        else
        {
            System.out.println("ERROR: more than one argument or none !! Need file path !");
        }
    }
}
