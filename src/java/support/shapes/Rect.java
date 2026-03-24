package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;
import static processing.core.PApplet.*;

public class Rect extends SimpleShape implements Translatable
{ // only 2D renderer
    public PVector topLeft, bottomRight;

    public Rect(PVector topLeft, PVector bottomRight, Attribute attr, int id)
    {
        super(attr, id);
        this.topLeft = topLeft;
        this.bottomRight = bottomRight;
    }

    public Rect(PVector topLeft, PVector bottomRight, Attribute attr)
    {
        this(topLeft, bottomRight, attr, 0);
    }

    public Rect(PVector topLeft, PVector bottomRight, int id)
    {
        this(topLeft, bottomRight, null, id);
    }

    public Rect(PVector topLeft, PVector bottomRight)
    {
        this(topLeft, bottomRight, null);
    }

    public Rect(PVector center, float width, float height, Attribute attr, int id)
    {
        super(attr, id);
        PVector half = new PVector(width, height).div(2);
        topLeft = PVector.sub(center, half);
        bottomRight = PVector.add(center, half);
    }

    public Rect(PVector center, float width, float height, Attribute attr)
    {
        this(center, width, height, attr, 0);
    }

    public Rect(PVector center, float width, float height, int id)
    {
        this(center, width, height, null, 0);
    }

    public Rect(PVector center, float width, float height)
    {
        this(center, width, height, null);
    }

    @Override
    public Rect copy()
    {
        return new Rect(topLeft.copy(), bottomRight.copy(), attr.copy());
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        pg.rectMode(pg.CORNERS);
        pg.rect(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y);
        pg.rectMode(pg.CORNER);
    }

    @Override
    public void translate(PVector dv)
    {
        topLeft.add(dv);
        bottomRight.add(dv);
    }

    public PVector getCenter()
    {
        return PVector.add(topLeft, bottomRight).div(2);
    }

    public float getWidth() { return abs(bottomRight.x - topLeft.x); }

    public float getHeight() { return abs(bottomRight.y - topLeft.y); }

    public float getArea() { return getWidth() * getHeight(); }
}
