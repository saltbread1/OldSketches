package support.shapes.attribute;

import processing.core.*;
import static processing.core.PApplet.*;
import static support.shapes.attribute.DrawStyle.*;

public class Attribute
{
    private int argbs, argbf;
    private float weight; // weight of stroke
    private int cap; // stroke cap type: ROUND, SQUARE or PROJECT
    private int join; // stroke join type: MITER, BEVEL or ROUND
    private DrawStyle style;

    public Attribute(int argbs, int argbf, float weight, int cap, int join, DrawStyle style)
    {
        this.argbs = argbs;
        this.argbf = argbf;
        this.style = style;
        this.weight = weight;
        this.cap = cap;
        this.join = join;
    }

    public Attribute(int argbs, int argbf, float weight, int cap, int join)
    {
        this(argbs, argbf, weight, cap, join, STROKEANDFILL);
    }

    public Attribute(int argb, float weight, int cap, int join, DrawStyle style)
    {
        this(argb, argb, weight, cap, join, style);
    }

    public Attribute(int argbs, int argbf, float weight, DrawStyle style) { this(argbs, argbf, weight, ROUND, MITER, style); }

    public Attribute(int argbs, int argbf, float weight)
    {
        this(argbs, argbf, weight, STROKEANDFILL);
    }

    public Attribute(int argb, float weight, DrawStyle style)
    {
        this(argb, argb, weight, style);
    }

    public Attribute(int argbs, int argbf, DrawStyle style)
    {
        this(argbs, argbf, 1, style);
    }

    public Attribute(int argbs, int argbf)
    {
        this(argbs, argbf, STROKEANDFILL);
    }

    public Attribute(int argb, DrawStyle style)
    {
        this(argb, argb, style);
    }

    public Attribute()
    { // default colors
        this(0xff000000, 0xffffffff, 1, ROUND, MITER, STROKEANDFILL);
    }

    public int getStroke() { return argbs; }

    public int getStrokeAlpha() { return getAlpha(argbs); }

    public int getFill() { return argbf; }

    public int getFillAlpha() { return getAlpha(argbf); }

    public float getWeight() { return weight; }

    public int getCapType() { return cap; }

    public int getJoinType() { return join; }

    public DrawStyle getStyle() { return style; }

    public void setStroke(int argb) { argbs = argb; }

    public void setStroke(int r, int g, int b, int a)
    {
        this.argbs = getARGB(r, g, b, a);
    }

    public void setStroke(int r, int g, int b)
    {
        setStroke(r, g, b, 255);
    }

    public void setStrokeAlpha(int a)
    {
        setStroke(getRed(argbs), getGreen(argbs), getBlue(argbs), a);
    }

    public void setFill(int argb) { argbf = argb; }

    public void setFill(int r, int g, int b, int a)
    {
        this.argbf = getARGB(r, g, b, a);
    }

    public void setFill(int r, int g, int b)
    {
        setFill(r, g, b, 255);
    }

    public void setFillAlpha(int a)
    {
        setFill(getRed(argbf), getGreen(argbf), getBlue(argbf), a);
    }

    public void setWeight(int sw) { this.weight = sw; }

    public void setCapType(int cap) { this.cap = cap; }

    public void setJoinType(int join) { this.join = join; }

    public void setStyle(DrawStyle style) { this.style = style; }

    private static int getARGB(int r, int g, int b, int a)
    {
        a = constrain(a, 0, 255) << 24;
        r = constrain(r, 0, 255) << 16;
        g = constrain(g, 0, 255) << 8;
        b = constrain(b, 0, 255);
        return a | r | g | b;
    }

    private static int getAlpha(int argb) { return argb >> 24 & 255; }

    private static int getRed(int argb) { return argb >> 16 & 255; }

    private static int getGreen(int argb) { return argb >> 8 & 255; }

    private static int getBlue(int argb) { return argb & 255; }

    public void apply(PGraphics pg, int mode)
    {
        if (style == null) { return; }

        if (mode == HSB) { pg.colorMode(HSB, 255, 255, 255); }
        else { pg.colorMode(RGB, 255, 255, 255); }

        switch (style)
        {
            case STROKEONLY:
                pg.stroke(argbs);
                pg.noFill();
                break;
            case FILLONLY:
                pg.noStroke();
                pg.fill(argbf);
                break;
            case STROKEANDFILL:
                pg.stroke(argbs);
                pg.fill(argbf);
                break;
        }
        pg.strokeWeight(weight);
        pg.strokeCap(cap);
        pg.strokeJoin(join);
    }

    public void apply(PGraphics pg) { apply(pg, RGB); }

    public Attribute copy() { return new Attribute(argbs, argbf, weight, cap, join, style); }

    @Override
    public boolean equals(Object o)
    {
        if (!(o instanceof Attribute)) { return false; }
        Attribute other = (Attribute)o;
        return (argbs == other.argbs && argbf == other.argbf && weight == other.weight
                && cap == other.cap && join == other.join && style == other.style);
    }

    @Override
    public String toString()
    {
        String stroke = "(" + getRed(argbs) + ", " + getGreen(argbs) + ", " + getBlue(argbs) + ", " + getAlpha(argbs) + ")";
        String fill = "(" + getRed(argbf) + ", " + getGreen(argbf) + ", " + getBlue(argbf) + ", " + getAlpha(argbf) + ")";
        String str = "stroke: " + stroke + ", fill: " + fill + ", style: ";
        switch (style)
        {
            case STROKEONLY: str += "STROKEONLY"; break;
            case FILLONLY:  str += "FILLONLY"; break;
            case STROKEANDFILL: str += "STROKEANDFILL"; break;
        }
        str += ", stroke weight: " + weight + ", stroke cap: ";
        switch (cap)
        {
            case ROUND: str += "ROUND"; break;
            case SQUARE: str += "SQUARE"; break;
            case PROJECT: str += "PROJECT"; break;
        }
        return str;
    }
}
