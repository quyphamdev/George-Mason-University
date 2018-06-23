import java.text.DecimalFormat;

/**
 * @author sunitha
 */
public class DecimalFormatExample {
    static final double PI = 22 /7 ;

    public static void main(String[] args) {
        double area = 2 * PI * 3.5344345 * 3.5344345;
        DecimalFormat fmt = new DecimalFormat("0.###");
        System.out.println("The circle's formatted area is: " + fmt.format(area) +"\n Actual area is:  " + area);
    }
}
