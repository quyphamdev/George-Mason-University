/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * PA4: MainClass.java (Main Class)
 *
 * Date: 5/03/2010
 */

import java.lang.*;
import java.util.*;

public class MainClass
{
    public static void main(String[] args)
    {
        boolean loop = true;
        String user_input, fundName;
        int shares;
        double curPrice;
        ArrayList funds;

        Scanner kbd = new Scanner(System.in);
        Portfolio pf = new Portfolio();
        pf.inputPortfolio("portfolio.txt");
        while(loop)
        {
            System.out.println("Choose:");
            System.out.println("update prices: u");
            System.out.println("sell: s");
            System.out.println("quit: q");
            System.out.println("==>");

            user_input = kbd.nextLine();
            switch(user_input.charAt(0))
            {
                case 'u':
                    pf.getCurrentPrices();
                    System.out.printf("Total Profit: $%.2f\n", pf.computeProfit());
                    break;
                case 's':
                    System.out.print("Enter Fund ");
                    fundName = kbd.nextLine();
                    System.out.print("Number of shares to sell: ");
                    shares = Integer.parseInt(kbd.nextLine());
                    System.out.print("Current Price: $");
                    curPrice = Double.parseDouble(kbd.nextLine());
                    funds = pf.getFunds();
                    for(int i=0; i<funds.size(); i++)
                    {
                        if(funds.get(i).getName() == fundName)
                        {
                            funds.get(i).setSharesBought((funds.get(i).getSharesBought-shares));
                            break;
                        }
                    }
                    break;
                case 'q':
                    loop = false;
                    break;

            }
        }
    }
}