package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;

public abstract class SimpleShape implements Comparable<SimpleShape>
{
    protected Attribute attr;
    private int id;

    public SimpleShape(Attribute attr, int id)
    {
        this.attr = attr == null ? new Attribute() : attr;
        this.id = id;
    }

    public SimpleShape(Attribute attr) { this(attr, 0); }

    public SimpleShape(int id) { this(null, id); }

    public SimpleShape() { this(null, 0); }

    public int getId() { return id; }

    public void setId(int id) { this.id = id; }

    public Attribute getAttribute() { return attr; }

    public void setAttribute(Attribute attr) { this.attr = attr; }

    public void setStroke(int argb) { attr.setStroke(argb); }

    public void setStroke(int r, int g, int b, int a) { attr.setStroke(r, g, b, a); }

    public void setStroke(int r, int g, int b) { attr.setStroke(r, g, b); }

    public void setStrokeAlpha(int a) { attr.setStrokeAlpha(a); }

    public void setFill(int argb) { attr.setFill(argb); }

    public void setFill(int r, int g, int b, int a) { attr.setFill(r, g, b, a); }

    public void setFill(int r, int g, int b) { attr.setFill(r, g, b); }

    public void setFillAlpha(int a) { attr.setFillAlpha(a); }

    public abstract SimpleShape copy();

    public abstract void drawShape(PGraphics pg);

    public void drawMe(PGraphics pg, int mode)
    {
        if (attr == null)
        {
            drawShape(pg);
        }
        else
        {
            pg.pushStyle();
            attr.apply(pg, mode);
            drawShape(pg);
            pg.popStyle();
        }
    }

    public void drawMe(PGraphics pg) { drawMe(pg, PApplet.RGB); }

    public void drawMe(PApplet pApplet, int mode)
    {
        drawMe(pApplet.g, mode);
    }

    public void drawMe(PApplet pApplet)
    {
        drawMe(pApplet.g, PApplet.RGB);
    }

    @Override
    public final int compareTo(SimpleShape shape)
    {
        return id - shape.id;
    }
}
