/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Lab 5: (Lab5.java)
 *
 * Description:
 *      a program which gets names from the user, sorts the names into
 * alphabetical order then prints out the ordered list.
 * Date: 3/23/2010
 */

import java.util.*;
import java.lang.*;

public class Lab5
{
    public static void main(String args[])
    {
        int totalName; // store total number of input names
        String[] names; // array to store names
        String name; // use for swapping names
        Scanner kbd = new Scanner(System.in); // keyboard input
        System.out.print("How many names ? ");
        totalName = Integer.parseInt(kbd.nextLine()); // get number of names
        names = new String[totalName]; // allocate memory for storing names
        for(int i=0; i < totalName; i++) // prompt for names
        {
            System.out.print("--> ");
            names[i] = kbd.nextLine();
        }
        // order names in array in alphabetically
        for(int i=totalName-2; i >= 0; i--) {
            for (int j = i; j <= totalName - 2; j++) {
                // if names[j+1] precedes names[j]
                if (names[j].compareToIgnoreCase(names[j + 1]) > 0) {
                    // swap them
                    name = names[j + 1];
                    names[j + 1] = names[j];
                    names[j] = name;
                }
            }
        }
        System.out.println("\nOrdered:\n");
        // print out ordered list of names
        for(int i=0; i < totalName; i++)
        {
            System.out.println(names[i]);
        }
    }

}