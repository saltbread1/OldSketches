package support.util;

import support.shapes.attribute.*;
import processing.core.*;

import static processing.core.PApplet.*;

public class Util
{
    public static void vertex(PGraphics pg, PVector v)
    {
        if (v.z == 0) { pg.vertex(v.x, v.y); }
        else { pg.vertex(v.x, v.y, v.z); }
    }

    public static void vertex(PApplet pApplet, PVector v) { vertex(pApplet.g, v); }

    public static void vertex(PGraphics pg, PVector pv, float u, float v)
    {
        if (pv.z == 0) { pg.vertex(pv.x, pv.y, u, v); }
        else { pg.vertex(pv.x, pv.y, pv.z, u, v); }
    }

    public static void vertex(PApplet pApplet, PVector pv, float u, float v)
    {
        vertex(pApplet.g, pv, u, v);
    }

    public static void curveVertex(PGraphics pg, PVector v)
    {
        if (v.z == 0) { pg.curveVertex(v.x, v.y); }
        else { pg.curveVertex(v.x, v.y, v.z); }
    }

    public static void curveVertex(PApplet pApplet, PVector v) { curveVertex(pApplet.g, v); }

    public static void line(PGraphics pg, PVector v1, PVector v2)
    {
        if (v1.z == 0 && v2.z == 0) { pg.line(v1.x, v1.y, v2.x, v2.y); }
        else { pg.line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z); }
    }

    public static void line(PApplet pApplet, PVector v1, PVector v2)
    {
        line(pApplet.g, v1, v2);
    }

    public static void triangle(PGraphics pg, PVector v1, PVector v2, PVector v3)
    {
        pg.beginShape(PConstants.TRIANGLES);
        vertex(pg, v1);
        vertex(pg, v2);
        vertex(pg, v3);
        pg.endShape();
    }

    public static void triangle(PApplet pApplet, PVector v1, PVector v2, PVector v3)
    {
        triangle(pApplet.g, v1, v2, v3);
    }

    public static void quad(PGraphics pg, PVector v1, PVector v2, PVector v3, PVector v4)
    {
        pg.beginShape(PConstants.QUADS);
        vertex(pg, v1);
        vertex(pg, v2);
        vertex(pg, v3);
        vertex(pg, v4);
        pg.endShape();
    }

    public static void quad(PApplet pApplet, PVector v1, PVector v2, PVector v3, PVector v4)
    {
        quad(pApplet.g, v1, v2, v3, v4);
    }

    public static void circle(PGraphics pg, PVector c, float d)
    {
        pg.ellipse(c.x, c.y, d, d);
    }

    public static void circle(PApplet pApplet, PVector c, float d)
    {
        circle(pApplet.g, c, d);
    }

    public static Attribute mixAttribute(Attribute attr1, Attribute attr2, float t)
    {
        return new Attribute(
                lerpColor(attr1.getStroke(), attr2.getStroke(), t, RGB),
                lerpColor(attr1.getFill(), attr2.getFill(), t, RGB),
                lerp(attr1.getWeight(), attr2.getWeight(), t),
                t < .5F ? attr1.getCapType() : attr2.getCapType(),
                t < .5F ? attr1.getJoinType() : attr2.getJoinType(),
                t < .5F ? attr1.getStyle() : attr2.getStyle());
    }

    public static String timestamp()
    {
        return year() + nf(month(), 2) + nf(day(), 2)
                + "_"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    }

    public static String getFilename(String pathname, String suffix, int... seeds)
    {
        String filename = pathname + "/" + timestamp();
        for (int s : seeds) { filename += "_" + nf(s, 5); }
        filename += "_" + suffix;
        return filename;
    }

    public static int chooseInt(PApplet pApplet, int... x)
    {
        int i = (int) pApplet.random(x.length);
        return x[i];
    }

    public static float chooseFloat(PApplet pApplet, float... x)
    {
        int i = (int) pApplet.random(x.length);
        return x[i];
    }

    @SafeVarargs
    public static <T> T choose(PApplet pApplet, T... x)
    {
        int i = (int) pApplet.random(x.length);
        return x[i];
    }

    public static float[] randomArray(PApplet pApplet, int n)
    {
        float[] ret = new float[n];
        for (int i = 0; i < n; i++)
        {
            ret[i] = pApplet.random(1);
        }
        return ret;
    }

    public static float[] randomArray(PApplet pApplet, int n, float min, float max)
    {
        float[] ret = new float[n];
        for (int i = 0; i < n; i++)
        {
            ret[i] = pApplet.random(min, max);
        }
        return ret;
    }

    public static PVector randomScreen(PApplet pApplet)
    {
        return randomScreen(pApplet, new PVector());
    }

    public static PVector randomScreen(PApplet pApplet, PVector offset)
    {
        return new PVector(pApplet.random(pApplet.width + offset.x * 2) - offset.x,
                pApplet.random(pApplet.height + offset.y * 2) - offset.y);
    }
}
