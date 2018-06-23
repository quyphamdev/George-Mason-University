/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * PA4: Portfolio.java
 *
 * Date: 5/03/2010
 */

import java.io.*;
import java.util.*;
import java.lang.*;

public class Portfolio
{
    //public enum enum_type {stock, bond, cash}
    public ArrayList funds;

    public Portfolio()
    {

    }
    public void inputPortfolio(String path)
    {
        File f;
        Scanner fread;
        String line;
        String[] items;
        int num;

        funds = new ArrayList();
        
        try
        {
            f = new File(path);
            fread = new Scanner(f);
            while(fread.hasNext()) // any available data to read ?
            {
                line = fread.next();
                items = line.split(" ");
                if(items[2] == "stock")
                {
                    funds.add(new StockFund(line));

                }
                else if(items[2] == "bond")
                {
                    funds.add(new BondFund(line));
                }
                else // cash
                {
                    funds.add(new CashFund(line));
                }
                
            }

        }
        catch(FileNotFoundException fe)
        {
                System.out.println("ERROR: File not found !!");
                System.exit(0);
        }


    }

    public void getCurrentPrices()
    {
        Scanner kbd = new Scanner(System.in);
        String user_input;

        for(int i=0; i<funds.size();i++)
        {
            System.out.printf("Enter the current price for %s (%s): ",funds.get(i).getName(), funds.get(i).getSymbol());
            user_input = kbd.nextLine();
            funds.get(i).setCurrentPrice(Double.parseDouble(user_input));
        }

        for(int i=0; i<funds.size();i++)
        {
            funds.get(i).display();
        }
    }

    public double computeProfit()
    {
        double totalProfit = 0.0;
        for(int i=0; i<funds.size();i++)
        {
            if((funds.get(i).getType() == "stock") || (funds.get(i).getType() == "bond"))
            {
                totalProfit += funds.get(i).getProfit();
            }
        }
        return totalProfit;
    }

    public void displayAnalysis(double shares, double floor, double ceiling)
    {
        if((shares < floor) || (ceiling < shares))
        {
            System.out.println("SELL");
        }
        else
        {
            System.out.println("HOLD");
        }
    }

    public ArrayList getFunds()
    {
        return funds;
    }
   
}