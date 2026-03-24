package support.shapes;

import support.util.*;
import support.shapes.attribute.Attribute;
import processing.core.*;
import static processing.core.PApplet.*;

public class Circle extends SimpleShape implements Translatable, Rotatable
{ // only 2D renderer
    public PVector center;
    public float radius;

    public Circle(PVector center, float radius, Attribute attr, int id)
    {
        super(attr, id);
        this.center = center;
        this.radius = radius;
    }

    public Circle(PVector center, float radius, Attribute attr)
    {
        this(center, radius, attr, 0);
    }

    public Circle(PVector center, float radius, int id)
    {
        this(center, radius, null, id);
    }

    public Circle(PVector center, float radius)
    {
        this(center, radius, null, 0);
    }

    public Circle(float x, float y, float radius, Attribute attr, int id)
    {
        this(new PVector(x, y), radius, attr, id);
    }

    public Circle(float x, float y, float radius, Attribute attr)
    {
        this(x, y, radius, attr, 0);
    }

    public Circle(float x, float y, float radius, int id)
    {
        this(x, y, radius, null, id);
    }

    public Circle(float x, float y, float radius)
    {
        this(x, y, radius, 0);
    }

    @Override
    public Circle copy()
    {
        return new Circle(center.copy(), radius, attr.copy());
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        pg.ellipse(center.x, center.y, radius*2, radius*2);
    }

    @Override
    public void translate(PVector dv)
    {
        center.add(dv);
    }

    @Override
    public void rotate(float rad, PVector init) { PMath.rotate(center, rad, init); }

    @Override
    public void rotate(float rad)
    {
    }

    public PVector getCenter() { return center; }

    public float getArea() { return PI * sq(radius); }
}
