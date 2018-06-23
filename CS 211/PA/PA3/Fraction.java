/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * Programming Assignment 3: (Fraction.java)
 *
 * Description:
 *      Fraction class handle all operations: addition, subtraction, multiplication,
 * division, reciprocal and reverse sign.
 * Date: 4/06/2010
 */

public class Fraction
{
    private int numerator,denominator;

    // constructors
    public Fraction(int num, int den)
    {
        numerator = num;
        denominator = den;
        if(den == 0)
        {
            System.out.println("ERROR: Denominator can not be zero (in constructor)");
            System.exit(1);
        }
        if(den < 0)
        {
            // denominator should always be positive
            denominator = -den;
            numerator = -numerator;
        }
        reduce2LowestTerm();
    }
    public Fraction()
    {
        numerator = 0;
        denominator = 1;
    }

    // get and set
    public int getNumerator()
    {
        return numerator;
    }
    public int getDenominator()
    {
        return denominator;
    }
    public void setNumerator(int num)
    {
        numerator = num;
        reduce2LowestTerm(); // reduce both numerator and denominator to their lowest terms
    }
    public void setDenominator(int den)
    {
        if(den == 0) // denominator can't be zero
        {
            System.out.println("ERROR: Denominator can not be zero (in setDenominator)");
            System.exit(1);
        }
        if(den < 0) // if denominator is nagative, set that sign to numerator, denominator always be positive
        {
            // denominator should always be positive
            denominator = -den;
            numerator = -numerator;
        }
        reduce2LowestTerm(); // reduce both numerator and denominator to their lowest terms
    }

    // calculate the greatest common divisor
    private int GCD(int a, int b)
    {
        int maxNum, minNum, remainder;
        if((a == 0)||(b == 0)) return 1;
        maxNum = Math.max(a, b); // get the bigger number of the two
        minNum = Math.min(a, b); // get the smaller number of the two
        remainder = 1; // any number can be divided by 1, set it as default
        do // loop
        {
            remainder = maxNum % minNum;
            if (remainder != 0)
            {
                maxNum = minNum;
                minNum = remainder;
            }
        } while(remainder != 0); // until remainder = 0
        return minNum;
    }

    // divide the numerator and denominator by their gcd
    // to reduce their values to the lowest term
    private void reduce2LowestTerm()
    {
        int num, den, gcd1;
        if(numerator < 0)
            num = -numerator;
        else
            num = numerator;
        den = denominator;
        if(num == 0)
            gcd1 = 1;
        else
            gcd1 = GCD(num,den);
        numerator = numerator/gcd1;
        denominator = denominator/gcd1;
    }

    // public methods for the operations: add,subtract,mul,div,reciprocal,reverse sign
    // addition
    public Fraction add(Fraction other)
    {
        int num = this.getNumerator()*other.getDenominator() + this.getDenominator()*other.getNumerator();
        int den = this.getDenominator()*other.getDenominator();
        return new Fraction(num,den);
    }
    // subtraction
    public Fraction sub(Fraction other)
    {
        int num = this.getNumerator()*other.getDenominator() - this.getDenominator()*other.getNumerator();
        int den = this.getDenominator()*other.getDenominator();
        return new Fraction(num,den);
    }
    // multiplication
    public Fraction mul(Fraction other)
    {
        int num = this.getNumerator()*other.getNumerator();
        int den = this.getDenominator()*other.getDenominator();
        return new Fraction(num,den);
    }
    // division
    public Fraction div(Fraction other)
    {
        int num = this.getNumerator()*other.getDenominator();
        int den = this.getDenominator()*other.getNumerator();
        return new Fraction(num,den);
    }
    // reciprocal
    public Fraction reciprocal()
    {
        return new Fraction(this.getDenominator(),this.getNumerator());
    }
    // reverse sign
    public Fraction reverseSign()
    {
        return new Fraction(-this.getNumerator(),this.getDenominator());
    }

    // print class string method, be called when print class with System.print
    public String toString()
    {
        if (denominator == 1)
            return Integer.toString(numerator);
        else if(numerator == 0)
            return "0";
        else
            return Integer.toString(numerator) + "/" + Integer.toString(denominator);
    }

    // return a string of fraction in a proper fraction form
    public String properFraction()
    {
        int a,b,c;
        if(numerator == 0)
        {
            return "0";
        }
        else if(denominator == 1)
        {
            return Integer.toString(numerator);
        }
        else
        {
            a = numerator / denominator;
            b = numerator % denominator;
            c = denominator;
            if(b < 0) b = -b;
            return Integer.toString(a) + " " + Integer.toString(b) + "/" + Integer.toString(c);
        }
    }

    /*
   This method takes a String representation of a (proper or improper)
   fraction and returns a corresponding instance of Fraction.  If the
   String is invalid null is returned.
    */
    public static Fraction parseFraction(String input)
    {
       boolean negative = input.charAt(0) == '-';     // negative value?
       int numberStartIndex = (negative ? 1 : 0);     // beginning of digits
       int spaceIndex = input.indexOf(' ');    // separates whole and frac parts
       int slashIndex = input.indexOf('/');
       int intPart = 0;                        // whole number part of the input
       if (slashIndex == -1)      // input is a whole number
       {
          try
          {
             // read input as a whole number: no fraction part
             intPart = Integer.parseInt(input.substring(numberStartIndex));
             if (negative)
                intPart = -intPart;           // correct for sign
          }
          catch (NumberFormatException e)
          {
             return null;
          }
          return new Fraction(intPart, 1);   // whole number
       }
       int fractionStart = 0;       // where the fraction starts in input
       if (spaceIndex != -1)        // input is a whole number and a fraction
       {
          // read whole number part
          fractionStart = spaceIndex + 1;  // fraction part starts here
          try
          {
             intPart =
               Integer.parseInt(input.substring(numberStartIndex, spaceIndex));
          }
          catch (NumberFormatException e)
          {
             return null;
          }
       }
       // read the fraction part
       int num, denom;
       try
       {
          // read numerator
          if (input.charAt(fractionStart) == '-')
             fractionStart++;      // may have '-' if not a mixes fraction
          num = Integer.parseInt(input.substring(fractionStart, slashIndex));
       }
       catch (NumberFormatException e)
       {
          return null;
       }
       try
       {
          // read denominator
          denom = Integer.parseInt(input.substring(slashIndex + 1));
       }
       catch (NumberFormatException e)
       {
          return null;
       }
       int numerator = intPart*denom + num;      // total numerator
       if (negative)
          numerator = -numerator;                // correct sign if necessary
       return new Fraction(numerator, denom);
    }

}