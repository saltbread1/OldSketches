package support.shapes;

import support.util.*;
import support.shapes.attribute.Attribute;
import processing.core.*;
import static processing.core.PApplet.*;

public class Quad extends SimpleShape implements Translatable, Rotatable, Rotatable3D
{
    public PVector v1, v2, v3, v4;

    public Quad(PVector v1, PVector v2, PVector v3, PVector v4, Attribute attr, int id)
    {
        super(attr, id);
        this.v1 = v1;  // v1 ---- v4
        this.v2 = v2;  // |       |
        this.v3 = v3;  // |       |
        this.v4 = v4;  // v2 ---- v3
    }

    public Quad(PVector v1, PVector v2, PVector v3, PVector v4, Attribute attr)
    {
        this(v1, v2, v3, v4, attr, 0);
    }

    public Quad(PVector v1, PVector v2, PVector v3, PVector v4, int id)
    {
        this(v1, v2, v3, v4, null, id);
    }

    public Quad(PVector v1, PVector v2, PVector v3, PVector v4)
    {
        this(v1, v2, v3, v4, null);
    }

    @Override
    public Quad copy()
    {
        return new Quad(v1.copy(), v2.copy(), v3.copy(), v4.copy(), attr.copy());
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        Util.quad(pg, v1, v2, v3, v4);
    }

    @Override
    public void translate(PVector dv)
    {
        v1.add(dv);
        v2.add(dv);
        v3.add(dv);
        v4.add(dv);
    }

    @Override
    public void rotate(float rad, PVector init)
    {
        PMath.rotate(v1, rad, init);
        PMath.rotate(v2, rad, init);
        PMath.rotate(v3, rad, init);
        PMath.rotate(v4, rad, init);
    }

    @Override
    public void rotate(float rad)
    {
        rotate(rad, getCenter());
    }

    @Override
    public void rotate3D(PVector axis, float rad, PVector init)
    {
        PMath.rotate3D(v1, axis, rad, init);
        PMath.rotate3D(v2, axis, rad, init);
        PMath.rotate3D(v3, axis, rad, init);
        PMath.rotate3D(v4, axis, rad, init);
    }

    public PVector getCenter()
    {
        return PVector.add(v1, v2).add(v3).add(v4).div(4);
    }

    public float[] getEdges()
    {
        float[] edges = new float[4];
        edges[0] = PVector.dist(v1, v2);
        edges[1] = PVector.dist(v2, v3);
        edges[2] = PVector.dist(v3, v4);
        edges[3] = PVector.dist(v4, v1);
        return edges;
    }

    public float getArea()
    {
        float[] edges = getEdges();
        float e12 = edges[0];
        float e23 = edges[1];
        float e34 = edges[2];
        float e41 = edges[3];
        // Bretschneider's formula
        float t = (e12 + e23 + e34 + e41)/2;
        float a = PVector.angleBetween(PVector.sub(v2, v1), PVector.sub(v4, v1));
        float c = PVector.angleBetween(PVector.sub(v2, v3), PVector.sub(v4, v3));
        return sqrt( (t-e12)*(t-e23)*(t-e34)*(t-e41) - e12*e23*e34*e41*sq(cos((a+c)/2)) );
    }
}
