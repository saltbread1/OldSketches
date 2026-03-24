package sketches.sketch20230826a;

import support.shapes.*;
import support.shapes.attribute.*;
import support.util.*;

import processing.core.*;

import static processing.core.PApplet.*;

public class MyBezier extends Bezier
{
    private final Triangle head;
    private static final int[] palette = {0xe6aabbcc, 0xe6334455, 0xe6678912, 0xe600e500, 0xe6eeffdd, 0xe6776655, 0xe6443322, 0xe6998877};

    public MyBezier(PApplet pApplet, PVector start, PVector goal)
    {
        super(start, calcControl1(pApplet, start, goal), calcControl1(pApplet, goal, start), goal);
        int color = palette[(int)pApplet.random(palette.length)];
        setAttribute(new Attribute(color, DrawStyle.STROKEONLY));

        PVector headDir = PVector.sub(start, control1).normalize();
        PVector headNorm = new PVector(headDir.y, -headDir.x);
        float a = sqrt(pApplet.width*pApplet.height)*.02F;
        head = new Triangle(
                PVector.mult(headDir, a).add(start),
                PVector.mult(headNorm, a*.35F).add(start),
                PVector.mult(headNorm, a*(-.35F)).add(start),
                new Attribute(color, DrawStyle.FILLONLY));
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        super.drawShape(pg);
        head.drawMe(pg);
    }

    private static PVector calcControl1(PApplet pApplet, PVector start, PVector goal)
    {
        PVector dir = PVector.sub(goal, start);
        PVector normal = new PVector(dir.y, -dir.x).mult(.84F);
        float s = pApplet.random(.45F);
        float t = Util.choose(pApplet, -1, 1)*pApplet.random(.18F, 1);
        return PVector.mult(dir, s).add(start).add(PVector.mult(normal, t));
    }
}
