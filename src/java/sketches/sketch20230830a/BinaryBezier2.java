package sketches.sketch20230830a;

import support.shapes.*;
import support.shapes.attribute.*;
import support.util.*;

import processing.core.*;
import processing.data.FloatList;
import static processing.core.PApplet.*;

import java.util.ArrayList;

public class BinaryBezier2 extends BinaryBezier
{
    private final Attribute attr1, attr2;
    private final ArrayList<Circle> circles;

    protected BinaryBezier2(PApplet pApplet, PVector start, PVector control1, PVector control2, PVector goal, int depth, Attribute attr1, Attribute attr2)
    {
        super(pApplet, start, control1, control2, goal, depth, null);
        this.attr1 = attr1;
        this.attr2 = attr2;
        circles = new ArrayList<>();
    }

    public BinaryBezier2(PApplet pApplet, PVector start, PVector control1, PVector control2, PVector goal, Attribute attr1, Attribute attr2)
    {
        this(pApplet, start, control1, control2, goal, 0, attr1, attr2);
    }

    public BinaryBezier2(PApplet pApplet, PVector start, PVector goal, Attribute attr1, Attribute attr2)
    {
        this(pApplet, start, calcControl1(pApplet, start, goal, null),
                calcControl2(pApplet, start, goal), goal, 0, attr1, attr2);
    }

    @Override
    public void preProcessing(float ratio, float minLength)
    {
        super.preProcessing(ratio, minLength);
        circles.clear();
        float l = calcLength();
        float dl = min(sqrt(l)*.1F, 3);
        FloatList params = calcRegularIntervalParams(dl);
        Attribute attr1 = Util.mixAttribute(this.attr1, this.attr2, 1-pow(ratio, depth));
        Attribute attr2 = Util.mixAttribute(this.attr1, this.attr2, 1-pow(ratio, depth+1));
        for (int i = 0; i < params.size()-1; i++)
        {
            float t1 = params.get(i);
            float t2 = params.get(i+1);
            PVector c = PVector.add(bezierPoint(t1), bezierPoint(t2)).div(2);
            float d = PVector.dist(bezierPoint(t1), bezierPoint(t2));
            Attribute attr = Util.mixAttribute(attr1, attr2, (float)i/params.size());
            circles.add(new Circle(c, d*2, attr));
        }
    }

    protected BinaryBezier createChild(PVector start, PVector control1, PVector control2, PVector goal)
    {
        return new BinaryBezier2(pApplet, start, control1, control2, goal, depth+1, attr1, attr2);
    }

    @Override
    public void drawMe(PGraphics pg)
    {
        circles.forEach(circle -> circle.drawMe(pg));
        if (children != null) { children.forEach(child -> ((BinaryBezier2) child).drawMe(pg)); }
    }
}
