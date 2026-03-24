package support.shapes;

import processing.core.*;

import static processing.core.PApplet.*;

import support.util.*;
import support.shapes.attribute.Attribute;

import java.util.Arrays;

public class VerticesCurveShape extends VerticesShape
{
    public VerticesCurveShape(PVector[] vertices, int kind, boolean isClose, Attribute attr, int id)
    {
        super(vertices, kind, isClose, attr, id);
    }

    public VerticesCurveShape(PVector[] vertices, boolean isClose, Attribute attr, int id)
    {
        super(vertices, isClose, attr, id);
    }

    public VerticesCurveShape(PVector[] vertices, int kind, boolean isClose, Attribute attr)
    {
        this(vertices, kind, isClose, attr, 0);
    }

    public VerticesCurveShape(PVector[] vertices, boolean isClose, Attribute attr)
    {
        this(vertices, 20, isClose, attr, 0);
    }

    public VerticesCurveShape(PVector[] vertices, int kind, boolean isClose, int id)
    {
        this(vertices, kind, isClose, null, id);
    }

    public VerticesCurveShape(PVector[] vertices, boolean isClose, int id)
    {
        this(vertices, 20, isClose, null, id);
    }

    public VerticesCurveShape(PVector[] vertices, boolean isClose)
    {
        this(vertices, 20, isClose, null, 0);
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        pg.beginShape(kind);
        Arrays.asList(vertices).forEach(vertex -> Util.curveVertex(pg, vertex));
        pg.endShape(isClose ? CLOSE : 1);
    }
}
