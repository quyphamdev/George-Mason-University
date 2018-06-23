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

public class Signal
{
    private int currentColor = 0;
    public int getCurrentColor()
    {
        return currentColor;
    }
    public void change()
    {
        currentColor = currentColor < 3 ? (currentColor + 1) : 1;
    }
}