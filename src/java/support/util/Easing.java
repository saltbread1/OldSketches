package support.util;

import static processing.core.PApplet.*;

public class Easing
{
    public static float easeInPolynomial(float t, float d)
    {
        float x = constrain(t, 0, 1);
        return pow(x, d);
    }

    public static float easeOutPolynomial(float t, float d)
    {
        float x = constrain(t, 0, 1);
        return 1 - pow(1 - x, d);
    }

    public static float easeInOutPolynomial(float t, float d)
    {
        float x = constrain(t, 0, 1);
        return x < .5F ? pow(2 * x, d) / 2 : 1 - pow(2 - 2 * x, d) / 2;
    }

    public static float easeMiddlePolynomial(float t, float d)
    {
        float x = constrain(t, 0, 1);
        return x < .5F ? .5F - pow(1 - 2 * x, d) / 2 : .5F + pow(2 * x - 1, d) / 2;
    }

    public static float easeInQuad(float t) { return easeInPolynomial(t, 2); }

    public static float easeOutQuad(float t) { return easeOutPolynomial(t, 2); }

    public static float easeInOutQuad(float t) { return easeInOutPolynomial(t, 2); }

    public static float easeMiddleQuad(float t) { return easeMiddlePolynomial(t, 2); }

    public static float easeInCubic(float t) { return easeInPolynomial(t, 3); }

    public static float easeOutCubic(float t) { return easeOutPolynomial(t, 3); }

    public static float easeInOutCubic(float t) { return easeInOutPolynomial(t, 3); }

    public static float easeMiddleCubic(float t) { return easeMiddlePolynomial(t, 3); }

    public static float easeInQuart(float t) { return easeInPolynomial(t, 4); }

    public static float easeOutQuart(float t) { return easeOutPolynomial(t, 4); }

    public static float easeInOutQuart(float t) { return easeInOutPolynomial(t, 4); }

    public static float easeMiddleQuart(float t) { return easeMiddlePolynomial(t, 4); }

    public static float easeInQuint(float t) { return easeInPolynomial(t, 5); }

    public static float easeOutQuint(float t) { return easeOutPolynomial(t, 5); }

    public static float easeInOutQuint(float t) { return easeInOutPolynomial(t, 5); }

    public static float easeMiddleQuint(float t) { return easeMiddlePolynomial(t, 5); }

    public static float easeInBack(float t, float a)
    {
        float x = constrain(t, 0, 1);
        float b = a + 1;
        return b * pow(x, 3) - a * sq(x);
    }

    public static float easeInBack(float t) { return easeInBack(t, 1.70158F); }

    public static float easeOutBack(float t, float a)
    {
        float x = constrain(t, 0, 1);
        float b = a + 1;
        return 1 + b * pow(x - 1, 3) + a * sq(x - 1);
    }

    public static float easeOutBack(float t) { return easeOutBack(t, 1.70158F); }

    public static float easeInOutBack(float t, float a)
    {
        float x = constrain(t, 0, 1);
        return x < .5F
                ? sq(2 * x) * ((a + 1) * 2 * x - a) / 2
                : (sq(2 * x - 2) * ((a + 1) * (2 * x - 2) + a) + 2) / 2;
    }

    public static float easeInOutBack(float t) { return easeInOutBack(t, 1.70158F + 1.525F); }
}
