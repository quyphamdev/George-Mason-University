/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Lab 1: (lab1.java)
 *      Summation of Two Integer
 * Description:
 *      Write a program which will ask user to enter
 * two integer numbers and then output the summation of those numbers
 * Data: 2/3/2010
 */
import java.io.*;

class lab1
{
    public static void main(String[] args) throws IOException
    {
        // define standard input stream
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        int num1, num2;
        System.out.print("Enter an integer: ");
        // read in a string of number and then convert them into integer
        num1 = Integer.parseInt(stdin.readLine());
        System.out.print("Enter an integer: ");
        // read in a string of number and then convert them into integer
        num2 = Integer.parseInt(stdin.readLine());
        // display the sum of those two integer on screen
        System.out.println("Sum = " + (num1+num2));
        //
        stdin.readLine();
    }
}
