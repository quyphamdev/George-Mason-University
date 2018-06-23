/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Programming Assignment #2
 * Description:
 *      Read an integer between 2 and 99 and count the number of odd and even
 * integers between 2 and the input number, the sum of those and the sum of total.
 * Date: 3/9/2010
 */

import java.util.*;

public class EvensAndOdds
{
    public static void main(String[] args)
    {
        Scanner kbd = new Scanner(System.in);
        boolean quit = false;
        int inputInt, countEven, totalEvens, countOdd, totalOdds, total, curInt;
        while(!quit)
        {
            System.out.println();
            System.out.print("Enter an integer between 2 and 99, or -1 to quit: ");
            inputInt = kbd.nextInt();
            if(inputInt == -1)
            {
                quit = true;
                System.out.println("Thank you. Goodbye.");
            }
            else if((inputInt >= 2) && (inputInt <= 99))
            {
                countEven = totalEvens = 0;
                countOdd = totalOdds = 0;
                total = 0;
                curInt = 2;
                while(curInt <= inputInt)
                {
                    if((curInt % 2) != 0) // odd
                    {
                        countOdd++;
                        totalOdds += curInt;
                    }
                    else // even
                    {
                        countEven++;
                        totalEvens += curInt;
                    }
                    total += curInt;
                    curInt++;
                }
                System.out.printf("The number of odd integers between 2 and %d: %d\n",inputInt, countOdd);
                System.out.printf("The number of even integers between 2 and %d: %d\n",inputInt, countEven);
                System.out.printf("The sum of odd integers between 2 and %d: %d\n",inputInt, totalOdds);
                System.out.printf("The sum of even integers between 2 and %d: %d\n",inputInt, totalEvens);
                System.out.printf("The sum of all integers between 2 and %d: %d\n",inputInt, total);
            }
            else if(inputInt < 2)
            {
                System.out.println("Too low. Try again");
            }
            else //if(inputInt > 99)
            {
                System.out.println("Too high. Try again");
            }
        }
    }
}