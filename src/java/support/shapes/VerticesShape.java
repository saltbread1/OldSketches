package support.shapes;

import support.util.*;
import support.shapes.attribute.Attribute;
import processing.core.*;

import java.util.Arrays;

import static processing.core.PApplet.*;

public class VerticesShape extends SimpleShape implements Translatable, Rotatable, Rotatable3D
{
    public PVector[] vertices;
    public int kind; // POINTS, LINES, TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP, QUADS, or QUAD_STRIP
    public boolean isClose;

    public VerticesShape(PVector[] vertices, int kind, boolean isClose, Attribute attr, int id)
    {
        super(attr, id);
        this.vertices = vertices;
        this.kind = kind;
        this.isClose = isClose;
    }

    public VerticesShape(PVector[] vertices, boolean isClose, Attribute attr, int id)
    {
        super(attr, id);
        this.vertices = vertices;
        this.kind = 20;
        this.isClose = isClose;
    }

    public VerticesShape(PVector[] vertices, int kind, boolean isClose, Attribute attr)
    {
        this(vertices, kind, isClose, attr, 0);
    }

    public VerticesShape(PVector[] vertices, boolean isClose, Attribute attr)
    {
        this(vertices, 20, isClose, attr, 0);
    }

    public VerticesShape(PVector[] vertices, int kind, boolean isClose, int id)
    {
        this(vertices, kind, isClose, null, id);
    }

    public VerticesShape(PVector[] vertices, boolean isClose, int id)
    {
        this(vertices, 20, isClose, null, id);
    }

    public VerticesShape(PVector[] vertices, boolean isClose)
    {
        this(vertices, 20, isClose, null, 0);
    }

    @Override
    public VerticesShape copy()
    {
        PVector[] vert = new PVector[vertices.length];
        for (int i = 0; i < vert.length; i++) { vert[i] = vertices[i].copy(); }
        return new VerticesShape(vert, kind, isClose, attr.copy());
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        pg.beginShape(kind);
        Arrays.asList(vertices).forEach(vertex -> Util.vertex(pg, vertex));
        pg.endShape(isClose ? CLOSE : 1);
    }

    @Override
    public void translate(PVector dv)
    {
        Arrays.asList(vertices).forEach(vertex -> vertex.add(dv));
    }

    @Override
    public void rotate(float rad, PVector init)
    {
        Arrays.asList(vertices).forEach(vertex -> PMath.rotate(vertex, rad, init));
    }

    @Override
    public void rotate(float rad)
    {
        rotate(rad, getCenter());
    }

    @Override
    public void rotate3D(PVector axis, float rad, PVector init)
    {
        Arrays.asList(vertices).forEach(vertex -> PMath.rotate3D(vertex, axis, rad, init));
    }

    public PVector getCenter()
    {
        PVector center = new PVector();
        Arrays.asList(vertices).forEach(center::add);
        return center.div(vertices.length);
    }
}
