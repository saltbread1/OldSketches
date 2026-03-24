package support.shapes;

import support.util.*;
import support.shapes.attribute.Attribute;
import processing.core.*;
import static processing.core.PApplet.*;

public class Triangle extends SimpleShape implements Translatable, Rotatable, Rotatable3D
{
    public PVector v1, v2, v3;

    public Triangle(PVector v1, PVector v2, PVector v3, Attribute attr, int id)
    {
        super(attr, id);
        this.v1 = v1;
        this.v2 = v2;
        this.v3 = v3;
    }

    public Triangle(PVector v1, PVector v2, PVector v3, Attribute attr)
    {
        this(v1, v2, v3, attr, 0);
    }

    public Triangle(PVector v1, PVector v2, PVector v3, int id)
    {
        this(v1, v2, v3, null, id);
    }

    public Triangle(PVector v1, PVector v2, PVector v3)
    {
        this(v1, v2, v3, null);
    }

    @Override
    public Triangle copy()
    {
        return new Triangle(v1.copy(), v2.copy(), v3.copy(), attr.copy());
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        Util.triangle(pg, v1, v2, v3);
    }

    @Override
    public void translate(PVector dv)
    {
        v1.add(dv);
        v2.add(dv);
        v3.add(dv);
    }

    @Override
    public void rotate(float rad, PVector init)
    {
        PMath.rotate(v1, rad, init);
        PMath.rotate(v2, rad, init);
        PMath.rotate(v3, rad, init);
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
    }

    public PVector getCenter()
    {
        return PVector.add(v1, v2).add(v3).div(3);
    }

    public float[] getEdges()
    {
        float[] edges = new float[3];
        edges[0] = PVector.dist(v1, v2);
        edges[1] = PVector.dist(v2, v3);
        edges[2] = PVector.dist(v3, v1);
        return edges;
    }

    public PVector getInner()
    {
        float[] edges = getEdges();
        return PVector.mult(v1, edges[1])
                .add(PVector.mult(v2, edges[2]))
                .add(PVector.mult(v3, edges[0]))
                .div(edges[0]+edges[1]+edges[2]);
    }

    public float getArea()
    {
        float[] edges = getEdges();
        float s = (edges[0]+edges[1]+edges[2])/2;
        return sqrt(s*(s-edges[0])*(s-edges[1])*(s-edges[2]));
    }

    public float getInnerRadius()
    {
        float[] edges = getEdges();
        float s = (edges[0]+edges[1]+edges[2])/2;
        return sqrt(s*(s-edges[0])*(s-edges[1])*(s-edges[2])) / s;
    }
}
