/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Lab 4:
 *      - Signal.java
 *      - RunSignal.java
 * Description:
 *      Practice with classes.
 * Date: 2/28/2010
 */

import java.io.*;
import java.util.*;

public class RunSignal
{
    public static void main(String[] arg)
    {
        Signal mySignal = new Signal(); // declare a instance of custome class
        Scanner kbd = new Scanner(System.in); // for reading user input
        boolean loop = true;
        String resp; // hold string response from user
        while(loop)
        {
            System.out.print("Change ? y/n ");
            resp = kbd.next(); // response with y/n (yes/no)
            if ( resp.equals("y") ) // yes
            {
                mySignal.change(); // change color
                switch(mySignal.getCurrentColor())
                {
                    case 1: System.out.println("Signal is green"); break;
                    case 2: System.out.println("Signal is yellow"); break;
                    case 3: System.out.println("Signal is red"); break;
                    default: break;
                }
            }
            else if( resp.equals("n")) // no, exit loop and program terminated
            {
                loop = false;
            }
        }
    }
}