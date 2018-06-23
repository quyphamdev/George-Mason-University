/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * PA4: BondFund.java (extends Investment class, implement Sellable)
 *
 * Date: 5/03/2010
 */

public class BondFund extends Investment implements Sellable
{
    public double yield;

    public BondFund(String s)
    {
        String[] items = s.split(" ");
        name = items[0];
        symbol = items[1];
        //type = enum_type.stock;
        type = items[2];
        try
        {
            buyingPrice = Double.parseDouble(items[3]);
            currentPrice = buyingPrice;
            sharesBought = Integer.parseInt(items[4]);
            floorSellingPrice = Double.parseDouble(items[5]);
            ceilingSellingPrice = Double.parseDouble(items[6]);
            yield = Double.parseDouble(items[7]);
        }
        catch(NumberFormatException ne) // not a legal int, double
        {
            System.out.println("ERROR: Number exception !!");
        }
    }

    public double getYield()
    {
        return yield;
    }
    public void setYield(double y)
    {
        yield = y;
    }

    public void display()
    {
        System.out.printf("%s (%s)\n", name, symbol);
        System.out.printf("buying price: $%.2f," +
                " shares: %i, current price: $%.2f, floor selling price: $%.2f," +
                " ceiling selling price: $%.2f, yield: %.2f\n", buyingPrice, sharesBought, currentPrice, floorSellingPrice, ceilingSellingPrice, yield);
        computeProfit();
        System.out.printf("==> profit: $%.2f\n", profit);
        if((sharesBought < floorSellingPrice) || (ceilingSellingPrice < sharesBought))
        {
            System.out.println("SELL");
        }
        else
        {
            System.out.println("HOLD");
        }
    }

    public void sell(int shares)
    {
        sharesBought -= shares;
    }

}