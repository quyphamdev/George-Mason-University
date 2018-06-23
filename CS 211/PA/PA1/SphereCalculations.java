/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Programming Assignment #1: (SphereCalculations.java)
 *
 * Description:
 *      This program generates a random value for the radius of a sphere and
 *      calculate it's volume and surface area.
 * Date: 2/18/2010
 */

import java.util.*;
import java.io.*;
import java.lang.*;
import java.text.DecimalFormat;

public class SphereCalculations
{
    public static void main(String[] args)
    {
        // use for generate a random number
        Random r_radius = new Random();
        // use for formatting number, 4 decimal points
        DecimalFormat fmt = new DecimalFormat("0.####");
        int radius;
        double volume, area;
        // generate a random number in range 1..10 for radius
        radius = r_radius.nextInt(10) + 1;
        // calculate volume and area using the random radius value above
        volume = (4.0/3.0)*Math.PI*Math.pow((double)radius,3.0);
        area = 4.0*Math.PI*Math.pow((double)radius, 2.0);
        // print out the results with number in 4 decimals format
        System.out.println("For a sphere with radius: " + radius);
        System.out.println("Volume: " + fmt.format(volume));
        System.out.println("Surface area: " + fmt.format(area));
    }
}
