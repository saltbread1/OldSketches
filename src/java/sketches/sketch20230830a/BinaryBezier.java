package sketches.sketch20230830a;

import support.shapes.*;
import support.shapes.attribute.*;
import support.util.*;

import processing.core.*;

import java.util.ArrayList;

import static processing.core.PApplet.*;

public class BinaryBezier extends Bezier
{
    protected final PApplet pApplet;
    protected final ArrayList<BinaryBezier> children;
    protected final int depth;

    protected BinaryBezier(PApplet pApplet, PVector start, PVector control1, PVector control2, PVector goal, int depth, Attribute attr)
    {
        super(start, control1, control2, goal, attr);
        this.pApplet = pApplet;
        this.depth = depth;
        children = new ArrayList<>();
    }

    public BinaryBezier(PApplet pApplet, PVector start, PVector control1, PVector control2, PVector goal, Attribute attr)
    {
        this(pApplet, start, control1, control2, goal, 0, attr);
    }

    public BinaryBezier(PApplet pApplet, PVector start, PVector goal, Attribute attr)
    {
        this(pApplet, start, calcControl1(pApplet, start, goal, null),
                calcControl2(pApplet, start, goal), goal, 0, attr);
    }

    public void preProcessing(float ratio, float minLength)
    {
        createChildren(ratio, minLength);
    }

    protected void createChildren(float ratio, float minLength)
    {
        float l = calcLength();
        if (l < minLength) { return; }
        children.clear();
        for (int i = 0; i < 2; i++)
        {
            PVector newStart = goal.copy();
            PVector newGoal = PVector.sub(goal, start).mult(ratio).rotate(1-pApplet.random(PI*.28F)*2).add(newStart);
            PVector newControl1 = calcControl1(pApplet, newStart, newGoal, control2);
            PVector newControl2 = calcControl2(pApplet, newStart, newGoal);
            BinaryBezier bezier = createChild(newStart, newControl1, newControl2, newGoal);
            bezier.preProcessing(ratio, minLength);
            children.add(bezier);
        }
    }

    protected BinaryBezier createChild(PVector start, PVector control1, PVector control2, PVector goal)
    {
        return new BinaryBezier(pApplet, start, control1, control2, goal, depth+1, attr);
    }

    @Override
    public void drawMe(PGraphics pg)
    {
        super.drawMe(pg);
        if (children != null) { children.forEach(child -> child.drawMe(pg)); }
    }

    public static PVector calcControl1(PApplet pApplet, PVector start, PVector goal, PVector preControl2)
    {
        return calcControl1(start, goal, preControl2,
                pApplet.random(.2F, .3F), pApplet.random(.1F, .8F));
    }

    public static PVector calcControl2(PApplet pApplet, PVector start, PVector goal)
    {
        return calcControl2(start, goal, pApplet.random(.7F, .8F),
                Util.choose(pApplet, -1, 1)*pApplet.random(.1F, .8F));
    }
}
