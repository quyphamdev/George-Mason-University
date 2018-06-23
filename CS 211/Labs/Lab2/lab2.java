/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Lab 2: (lab2.java)
 *      Summation of Two Integer
 * Description:
 *      Write a program which will ask user to enter
 * two integer numbers and then output the summation of those numbers
 * Date: 2/10/2010
 */
import java.io.*;
import java.text.DecimalFormat;

class lab2
{
    static final double CONVERSION_FACTOR = 5.0/9.0;
    static final double BASE = 32.0;
    
    public static void main(String[] args) throws IOException
    {
	double tempF, tempC; // temperature in fahrenheit and celcius
        // define standard input stream
	BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
	System.out.print("Enter a Fahrenheit temperature: ");
        // get user input for temperature in fahrenheit
        // because the input is a string, convert it to number in type of double
	tempF = Double.parseDouble(stdin.readLine());
        // convert temperature in fahrenheit to celcius
	// Tc = (5/9)*(Tf-32)
	tempC = CONVERSION_FACTOR*(tempF-BASE);
        // format the converted number, round it to 3 decimal points
	DecimalFormat fmt = new DecimalFormat("0.###");
        // print out final result
	System.out.println("Celcius equivalent: " + fmt.format(tempC));
    }
}
