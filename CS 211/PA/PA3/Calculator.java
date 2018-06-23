/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Programming Assignment 3: (Calculator.java)
 *
 * Description:
 *      Implementation of the Fraction class in an example of a simple calculator
 * Date: 4/06/2010
 */

import java.util.*;
import java.lang.*;

public class Calculator
{
    private static Fraction accumulator, userFraction;
    private static boolean proper_display; // flag indicates current display mode of fraction(proper/improper)

    public static void printAccumulator()
    {
        if(proper_display)
        {
            System.out.println(accumulator.properFraction());
        } else {
            System.out.println(accumulator);
        }
    }

    public static void printMenu()
    {
        System.out.println("add:         a,  clear:            c");
        System.out.println("subtract:    s,  reverse sign:     n");
        System.out.println("multiply:    m,  proper display:   p");
        System.out.println("divide:      d,  improper display: i");
        System.out.println("reciprocal:  r,  quit:             q");
    }

    public static void getInputFraction()
    {
        Scanner kbd = new Scanner(System.in);
        System.out.print("\t> ");
        userFraction = Fraction.parseFraction(kbd.nextLine());
    }

    public static void main(String args[])
    {
        accumulator = new Fraction();
        proper_display = true; // default display is proper fraction
        boolean loop = true;
        String user_input; // hold the input fraction by user
        // use for take user input
        Scanner kbd = new Scanner(System.in);
        while(loop)
        {
            System.out.println();
            printAccumulator();
            System.out.println();
            printMenu();
            System.out.print("-> ");
            user_input = kbd.nextLine();
            switch(user_input.charAt(0))
            {
                case 'a': // addition
                    System.out.print("\t> ");
                    userFraction = Fraction.parseFraction(kbd.nextLine()); // convert fraction string to fraction instance
                    if(userFraction != null)
                        accumulator = accumulator.add(userFraction); // add the converted fraction to the past result
                    else
                        System.out.println("ERROR: Invalid fraction !!");
                    break;
                case 's': // subtraction
                    System.out.print("\t> ");
                    userFraction = Fraction.parseFraction(kbd.nextLine()); // convert fraction string to fraction instance
                    if(userFraction != null)
                        accumulator = accumulator.sub(userFraction); // subtract the converted fraction to the past result
                    else
                        System.out.println("ERROR: Invalid fraction !!");
                    break;
                case 'm': // multiplication
                    System.out.print("\t> ");
                    userFraction = Fraction.parseFraction(kbd.nextLine()); // convert fraction string to fraction instance
                    if(userFraction != null)
                        accumulator = accumulator.mul(userFraction); // multiply the converted fraction to the past result
                    else
                        System.out.println("ERROR: Invalid fraction !!");
                    break;
                case 'd': // division
                    System.out.print("\t> ");
                    userFraction = Fraction.parseFraction(kbd.nextLine()); // convert fraction string to fraction instance
                    if(userFraction != null)
                        accumulator = accumulator.div(userFraction); // divide the converted fraction to the past result
                    else
                        System.out.println("ERROR: Invalid fraction !!");
                    break;
                case 'r': // reciprocal
                    accumulator = accumulator.reciprocal(); // reciprocal on the current result
                    break;
                case 'c': // clear
                    accumulator.setNumerator(0);
                    accumulator.setDenominator(1);
                    break;
                case 'n': // reverse sign
                    accumulator.setNumerator(-accumulator.getNumerator());
                    break;
                case 'p':
                    proper_display = true; // change to proper display
                    break;
                case 'i':
                    proper_display = false; // change to improper display
                    break;
                case 'q':
                    loop = false; // quit
                    break;
                default: // invalid menu input
                    System.out.println("ERROR: Invalid menu input !!");
                    break;
            }
        }
    }
}