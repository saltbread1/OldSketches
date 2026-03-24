package sketches.sketch20230824a;

import support.shapes.*;
import support.shapes.attribute.*;
import support.util.*;
import processing.core.*;
import static processing.core.PApplet.*;

public class BezierSquare extends Quad
{
    private Bezier3D bezier;

    public BezierSquare(PVector v1, PVector v2, PVector v3, PVector v4, Attribute attr)
    {
        super(v1, v2, v3, v4, attr);
    }

    public void preProcessing(PApplet pApplet, float length, Attribute attr)
    {
        PVector normal = PVector.sub(v2, v1).cross(PVector.sub(v4, v1)).normalize();
        PVector start = getCenter();
        PVector control1 = PVector.mult(normal, pApplet.random(.12F, .21F) * length).add(start);
        PVector goal = PVector.mult(normal, length).add(start);
        PMath.rotate3D(goal, PMath.randomNormal(normal), pApplet.random(PI*.41F), start);
        PVector s2g = PVector.sub(goal, start);
        PVector u = PMath.randomNormal(s2g);
        PVector v = s2g.cross(u).normalize();
        float r = pApplet.random(.62F, 1.6F) * length;
        float t = pApplet.random(TAU);
        float s = pApplet.random(.72F, 1.8F);
        PVector control2 = PVector.add(u.mult(r*cos(t)), v.mult(r*sin(t))).add(s2g.mult(s).add(start));
        bezier = new Bezier3D(start, control1, control2, goal);
        float d = PVector.dist(v2, v1);
        bezier.preProcessing(8, d*.5F, d*.04F, normal, attr);
    }

    public void preProcessing(PApplet pApplet, PVector goal, PVector goalNorm, float endR, Attribute attr)
    {
        PVector normal = PVector.sub(v2, v1).cross(PVector.sub(v4, v1)).normalize();
        PVector start = getCenter();
        float length = PVector.dist(start, goal);
        PVector control1 = PVector.mult(normal, pApplet.random(.12F, .63F) * length).add(start);
        PVector control2 = PVector.mult(goalNorm, pApplet.random(.12F, .63F) * length).add(goal);
        bezier = new Bezier3D(start, control1, control2, goal);
        float d = PVector.dist(v2, v1);
        bezier.preProcessingFade(8, d*.5F, endR, normal, attr);
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        bezier.drawMe(pg);
    }

    @Override
    public void translate(PVector dv)
    {
        super.translate(dv);
        if (bezier == null) { return; }
        bezier.translate(dv);
    }

    @Override
    public void rotate(float rad, PVector init)
    {
        super.rotate(rad, init);
        if (bezier == null) { return; }
        bezier.rotate(rad, init);
    }

    @Override
    public void rotate(float rad)
    {
        rotate(rad, getCenter());
    }

    @Override
    public void rotate3D(PVector axis, float rad, PVector init)
    {
        super.rotate3D(axis, rad, init);
        if (bezier == null) { return; }
        bezier.rotate3D(axis, rad, init);
    }
}
