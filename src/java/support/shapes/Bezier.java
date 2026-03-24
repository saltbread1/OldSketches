package support.shapes;

import support.shapes.attribute.Attribute;
import support.util.*;
import processing.core.*;
import processing.data.FloatList;

import static processing.core.PApplet.*;

public class Bezier extends SimpleShape implements Curve, Translatable, Rotatable, Rotatable3D
{
    public PVector start, control1, control2, goal;

    public Bezier(PVector start, PVector control1, PVector control2, PVector goal, Attribute attr, int id)
    {
        super(attr, id);
        this.start = start;
        this.control1 = control1;
        this.control2 = control2;
        this.goal = goal;
    }

    public Bezier(PVector start, PVector control1, PVector control2, PVector goal, Attribute attr)
    {
        this(start, control1, control2, goal, attr, 0);
    }

    public Bezier(PVector start, PVector control1, PVector control2, PVector goal, int id)
    {
        this(start, control1, control2, goal, null, id);
    }

    public Bezier(PVector start, PVector control1, PVector control2, PVector goal)
    {
        this(start, control1, control2, goal, null);
    }

    /**
     * only 2D renderer
     */
    @Override
    public void drawShape(PGraphics pg)
    {
        pg.bezier(start.x, start.y, control1.x, control1.y, control2.x, control2.y, goal.x, goal.y);
    }

    @Override
    public Bezier copy()
    {
        return new Bezier(start.copy(), control1.copy(), control2.copy(), goal.copy(), attr.copy());
    }

    @Override
    public float calcLength(int detail)
    {
        float l = 0;
        for (int i = 0; i < detail; i++)
        {
            float t1 = (float)i/detail;
            float t2 = (float)(i+1)/detail;
            PVector p1 = bezierPoint(t1);
            PVector p2 = bezierPoint(t2);
            l += PVector.dist(p1, p2);
        }
        return l;
    }

    @Override
    public float calcLength()
    {
        return calcLength((int)(PVector.dist(start, goal)*.25F));
    }

    @Override
    public FloatList calcRegularIntervalParams(float dl)
    {
        FloatList params = new FloatList();
        float l = calcLength();
        int n = (int)(l/dl);
        float stepDist = l/n;
        int m = n*32;
        PVector p = start;
        params.append(0);
        for (int i = 1; i < m; i++)
        {
            float t = (float)i/m;
            PVector q = bezierPoint(t);
            if (PVector.dist(p, q) > stepDist)
            {
                p = q;
                params.append(t);
            }
        }
        params.append(1);

        return params;
    }

    public PVector bezierPoint(float t)
    {
        float t1 = 1 - t;
        return PVector.mult(start, t1).add(PVector.mult(control1, 3*t)).mult(t1*t1)
                .add(PVector.mult(control2, 3*t1).add(PVector.mult(goal, t)).mult(t*t));
    }

    @Override
    public void translate(PVector dv)
    {
        start.add(dv);
        control1.add(dv);
        control2.add(dv);
        goal.add(dv);
    }

    @Override
    public void rotate(float rad, PVector init)
    {
        PMath.rotate(start, rad, init);
        PMath.rotate(control1, rad, init);
        PMath.rotate(control2, rad, init);
        PMath.rotate(goal, rad, init);
    }

    @Override
    public void rotate(float rad)
    {
        rotate(rad, start);
    }

    @Override
    public void rotate3D(PVector axis, float rad, PVector init)
    {
        PMath.rotate3D(start, axis, rad, init);
        PMath.rotate3D(control1, axis, rad, init);
        PMath.rotate3D(control2, axis, rad, init);
        PMath.rotate3D(goal, axis, rad, init);
    }

    /**
     * calculating first control point to smoothly connect two Bézier curves
     * M: line connecting start and goal
     * L: length of M
     * @param start first anker point
     * @param goal second anchor point
     * @param preControl2 second control point of the previous bezier
     * @param r1 ratio of the distance between start and new control1 projected the M; ex: random(.1F, .4F) > 0
     * @param r2 ratio of the distance between new control1 and the M against the L; ex: random(.1F, .8F) > 0
     * @return new first control point
     */
    public static PVector calcControl1(PVector start, PVector goal, PVector preControl2, float r1, float r2)
    {
        if (preControl2 == null) { return calcControl2(goal, start, 1-r1, r2); }
        float l = PVector.dist(start, goal);
        PVector dir = PVector.sub(start, preControl2).normalize();
        float rad = PVector.angleBetween(PVector.sub(goal, start), dir);
        float a = min(r1, r2/tan(rad));
        float b = min(l, l*a/cos(rad));
        return PVector.mult(dir, b).add(start);
    }

    /**
     * calculating second control point
     * M: line connecting start and goal
     * L: length of M
     * @param start first anker point
     * @param goal second anchor point
     * @param r1 ratio of the distance between start and new control2 projected the M; ex: random(.6F, .9F) > 0
     * @param r2 ratio of the distance between new control2 and the M against the L; ex: pApplet.random(-.8F, .8F)
     * @return new second control point
     */
    public static PVector calcControl2(PVector start, PVector goal, float r1, float r2)
    {
        PVector dir = PVector.sub(goal, start);
        PVector normal = new PVector(dir.y, -dir.x);
        return PVector.mult(dir, r1).add(start).add(PVector.mult(normal, r2));
    }
}
