package sketches.sketch20230828a;

import support.shapes.*;
import support.shapes.attribute.*;
import support.util.*;

import processing.core.*;
import processing.data.FloatList;

import java.util.ArrayList;
import java.util.List;

import static processing.core.PApplet.*;

public class FractalBezier extends Bezier
{
    private final List<FractalBezier> children;
    private Circle endCap;
    private final Attribute attr1, attr2;

    public FractalBezier(PVector start, PVector control1, PVector control2, PVector goal, Attribute attr1, Attribute attr2)
    {
        super(start, control1, control2, goal, attr1);
        this.attr1 = attr1;
        this.attr2 = attr2;
        children = new ArrayList<>();
    }

    public FractalBezier(PApplet pApplet, PVector start, PVector goal, Attribute attr1, Attribute attr2)
    {
        this(start, calcControl1(pApplet, start, goal, null), calcControl2(pApplet, start, goal), goal, attr1, attr2);
    }

    public void preProcessing(PApplet pApplet, int divNum, float stepLength)
    {
        float l = calcLength();
        if (l/divNum < stepLength)
        {
            Attribute capAttr = attr.copy();
            capAttr.setFill(0xff000000);
            capAttr.setStyle(DrawStyle.STROKEANDFILL);
            endCap = new Circle(goal.x, goal.y, constrain(l*.2F, 4, 12), capAttr);
            return;
        }
        FloatList params = calcRegularIntervalParams(l/divNum);
        children.clear();
        PVector preControl2 = null;
        for (int i = 0; i < params.size()-1; i++)
        {
            PVector start = bezierPoint(params.get(i));
            PVector goal = bezierPoint(params.get(i+1));
            PVector control1 = calcControl1(pApplet, start, goal, preControl2);
            PVector control2 = calcControl2(pApplet, start, goal);
            preControl2 = control2.copy();
            Attribute newAttr1 = Util.mixAttribute(attr1, attr2, (float)i/(float)(params.size()-1));
            Attribute newAttr2 = Util.mixAttribute(attr1, attr2, (float)(i+1)/(float)(params.size()-1));
            FractalBezier bezier = new FractalBezier(start, control1, control2, goal, newAttr1, newAttr2);
            children.add(bezier);
        }
        children.forEach(bezier -> bezier.preProcessing(pApplet, divNum, stepLength));
    }

    @Override
    public void drawMe(PGraphics pg)
    {
        drawBezier(pg);
        drawCap(pg);
    }

    private void drawBezier(PGraphics pg)
    {
        if (children.isEmpty()) { super.drawMe(pg); }
        children.forEach(bezier -> bezier.drawBezier(pg));
    }

    private void drawCap(PGraphics pg)
    {
        if (children.isEmpty()) { endCap.drawMe(pg); }
        children.forEach(bezier -> bezier.drawCap(pg));
    }

    private static PVector calcControl1(PApplet pApplet, PVector start, PVector goal, PVector preControl2)
    {
        return calcControl1(start, goal, preControl2,
                pApplet.random(.1F, .4F), pApplet.random(.1F, .8F));
    }

    private static PVector calcControl2(PApplet pApplet, PVector start, PVector goal)
    {
        return calcControl2(start, goal, pApplet.random(.6F, .9F),
                Util.choose(pApplet, -1, 1)*pApplet.random(.1F, .8F));
    }
}
