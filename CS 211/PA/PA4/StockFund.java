/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * PA4: StockFund.java (extends Investment class)
 *
 * Date: 5/03/2010
 */

public class StockFund extends Investment implements Sellable
{
    //public enum enum_StockType {smallcap, mediumcap, largecap, blend, international}
    //public enum_StockType StockType;
    public String StockType;

    public StockFund(String s)
    {
        String[] items = s.split(" ");
        name = items[0];
        symbol = items[1];
        //type = enum_type.stock;
        type = items[2];
        StockType = items[7];
        try
        {
            buyingPrice = Double.parseDouble(items[3]);
            currentPrice = buyingPrice;
            sharesBought = Integer.parseInt(items[4]);
            floorSellingPrice = Double.parseDouble(items[5]);
            ceilingSellingPrice = Double.parseDouble(items[6]);
        }
        catch(NumberFormatException ne) // not a legal int, double
        {
            System.out.println("ERROR: Number exception !!");
        }

    }
    /*
    public enum_StockType getStockType()
    {
        return StockType;
    }
    public void setStockType(enum_StockType st)
    {
        StockType = st;
    }
    */

    public String getStockType()
    {
        return StockType;
    }
    public void setStockType(String st)
    {
        StockType = st;
    }

    public void display()
    {
        System.out.printf("%s (%s)\n", name, symbol);
        System.out.printf("buying price: $%.2f," +
                " shares: %i, current price: $%.2f, floor selling price: $%.2f," +
                " ceiling selling price: $%.2f, type: %s\n", buyingPrice, sharesBought, currentPrice, floorSellingPrice, ceilingSellingPrice, StockType);
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