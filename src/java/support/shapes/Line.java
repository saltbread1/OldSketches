package support.shapes;

import processing.core.*;

import support.util.*;
import support.shapes.attribute.*;

public class Line extends SimpleShape implements Translatable, Rotatable, Rotatable3D
{
    public PVector start, goal;

    public Line(PVector start, PVector goal, Attribute attr, int id)
    {
        super(attr, id);
        this.start = start;
        this.goal = goal;
    }

    public Line(PVector start, PVector goal, Attribute attr)
    {
        this(start, goal, attr, 0);
    }

    public Line(PVector start, PVector goal, int id)
    {
        this(start, goal, null, id);
    }

    public Line(PVector start, PVector goal) { this(start, goal, null, 0); }

    @Override
    public Line copy() { return new Line(start.copy(), goal.copy(), attr.copy()); }

    @Override
    public void drawShape(PGraphics pg)  { Util.line(pg, start, goal); }

    @Override
    public void translate(PVector dv)
    {
        start.add(dv);
        goal.add(dv);
    }

    @Override
    public void rotate(float rad, PVector init)
    {
        PMath.rotate(start, rad, init);
        PMath.rotate(goal, rad, init);
    }

    @Override
    public void rotate(float rad)
    {
        rotate(rad, getCenter());
    }

    @Override
    public void rotate3D(PVector axis, float rad, PVector init)
    {
        PMath.rotate3D(start, axis, rad, init);
        PMath.rotate3D(goal, axis, rad, init);
    }

    public PVector getCenter()
    {
        return PVector.lerp(start, goal, .5F);
    }
}
