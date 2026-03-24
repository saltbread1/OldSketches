package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;

import java.util.stream.IntStream;

import static processing.core.PApplet.*;

public class RegularPolygon extends VerticesShape implements Translatable, Rotatable, Rotatable3D
{
    public PVector center;
    public float radius;
    public PVector normal;

    public RegularPolygon(PVector center, float radius, int n, PVector normal, Attribute attr, int id)
    {
        super(IntStream.range(0, max(n, 3))
                .mapToObj(i -> PVector.fromAngle(TAU / max(n, 3) * i).mult(radius).add(center))
                .toArray(PVector[]::new), 20, true, attr, id);

        //super(attr, id);
        this.center = center;
        this.radius = radius;
        this.normal = normal;
//        n = max(n, 3);
//        vertices = new PVector[n];
//        for (int i = 0; i < n; i++)
//        {
//            vertices[i] = PVector.fromAngle(TAU/n*i).mult(radius).add(center);
//        }
        if (normal != null)
        {
            PVector ez = new PVector(0, 0, 1);
            PVector axis = ez.cross(normal);
            float rad = PVector.angleBetween(ez, normal);
            rotate3D(axis, rad, center);
        }
    }

    public RegularPolygon(PVector center, float radius, int n, PVector normal, Attribute attr)
    {
        this(center, radius, n, normal, attr, 0);
    }

    public RegularPolygon(PVector center, float radius, int n, PVector normal, int id)
    {
        this(center, radius, n, normal, null, id);
    }

    public RegularPolygon(PVector center, float radius, int n, PVector normal)
    {
        this(center, radius, n, normal, null);
    }

    public RegularPolygon(PVector center, float radius, int n, Attribute attr, int id)
    {
        this(center, radius, n, null, attr, id);
    }

    public RegularPolygon(PVector center, float radius, int n, Attribute attr)
    {
        this(center, radius, n, attr, 0);
    }

    public RegularPolygon(PVector center, float radius, int n, int id)
    {
        this(center, radius, n, (Attribute) null, id);
    }

    public RegularPolygon(PVector center, float radius, int n)
    {
        this(center, radius, n, null, null);
    }

    private RegularPolygon(PVector[] vertices, Attribute attr)
    {
        super(vertices, 20, true, attr);
    }

    @Override
    public RegularPolygon copy()
    {
        PVector[] vert = new PVector[vertices.length];
        for (int i = 0; i < vert.length; i++) { vert[i] = vertices[i].copy(); }
        return new RegularPolygon(vert, attr.copy());
    }

    @Override
    public PVector getCenter() { return center; }
}
