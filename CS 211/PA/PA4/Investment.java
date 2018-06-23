/*
 * Spring 2010 - CS211
 * Student: QUY PHAM
 * PA4: Investment.java (abstract class)
 *
 * Date: 5/03/2010
 */

abstract class Investment
{
    public String name, symbol;

    //public enum enum_type {stock, bond, cash}
    //public enum_type type;
    public String type;
    
    public double buyingPrice, currentPrice;
    public int sharesBought;
    public double floorSellingPrice, ceilingSellingPrice, profit;

    public Investment()
    {

    }

    public String getName()
    {
        return name;
    }
    public void setName(String n)
    {
        name = n;
    }

    public String getSymbol()
    {
        return symbol;
    }
    public void setSymbol(String s)
    {
        symbol = s;
    }

    /*
    public enum_type getType()
    {
        return type;
    }
    public void setType(enum_type t)
    {
        type = t;
    }
    */
    public String getType()
    {
        return type;
    }
    public void setType(String t)
    {
        type = t;
    }

    public double getBuyingPrice()
    {
        return buyingPrice;
    }
    public void setBuyingPrice(double bp)
    {
        buyingPrice = bp;
    }

    public double getCurrentPrice()
    {
        return currentPrice;
    }
    public void setCurrentPrice(double cp)
    {
        currentPrice = cp;
    }

    public int getSharesBought()
    {
        return sharesBought;
    }
    public void setSharesBought(int sb)
    {
        sharesBought = sb;
    }

    public double getFloorSellingPrice()
    {
        return floorSellingPrice;
    }
    public void setFloorSellingPrice(double fsp)
    {
        floorSellingPrice = fsp;
    }

    public double getCeilingSellingPrice()
    {
        return ceilingSellingPrice;
    }
    public void setCeilingSellingPrice(double csp)
    {
        ceilingSellingPrice = csp;
    }

    public void computeProfit()
    {
        profit = (currentPrice-buyingPrice)/(double)sharesBought;
    }
    public double getProfit()
    {
        computeProfit();
        return profit;
    }

    abstract void display();

}