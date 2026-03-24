package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;

public class Arc extends Circle
{
    public float startRad, stopRad;
    public int mode; // DEFAULT=0, OPEN, CHORD, PIE

    public Arc(PVector center, float radius, float startRad, float stopRad, int mode, Attribute attr, int id)
    {
        super(center, radius, attr, id);
        this.startRad = startRad;
        this.stopRad = stopRad;
        this.mode = mode;
    }

    public Arc(PVector center, float radius, float startRad, float stopRad, int mode, Attribute attr)
    {
        this(center, radius, startRad, stopRad, mode, attr, 0);
    }

    public Arc(PVector center, float radius, float startRad, float stopRad, int mode, int id)
    {
        this(center, radius, startRad, stopRad, mode, null, id);
    }

    public Arc(PVector center, float radius, float startRad, float stopRad, int mode)
    {
        this(center, radius, startRad, stopRad, mode, 0);
    }

    public Arc(float x, float y, float radius, float startRad, float stopRad, int mode, Attribute attr, int id)
    {
        this(new PVector(x, y), radius, startRad, stopRad, mode, attr, id);
    }

    public Arc(float x, float y, float radius, float startRad, float stopRad, int mode, Attribute attr)
    {
        this(x, y, radius, startRad, stopRad, mode, attr, 0);
    }

    public Arc(float x, float y, float radius, float startRad, float stopRad, int mode, int id)
    {
        this(x, y, radius, startRad, stopRad, mode, null, id);
    }

    public Arc(float x, float y, float radius, float startRad, float stopRad, int mode)
    {
        this(x, y, radius, startRad, stopRad, mode, 0);
    }

    @Override
    public Arc copy()
    {
        return new Arc(center.copy(), radius, startRad, stopRad, mode, attr.copy());
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        pg.arc(center.x, center.y, radius*2, radius*2, startRad, stopRad, mode);
    }

    @Override
    public void rotate(float rad, PVector init)
    {
        super.rotate(rad, init);
        this.rotate(rad);
    }

    @Override
    public void rotate(float rad)
    {
        startRad += rad;
        stopRad += rad;
    }
}
