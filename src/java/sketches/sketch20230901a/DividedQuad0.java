package sketches.sketch20230901a;

import processing.core.*;

import static processing.core.PApplet.*;

import support.util.*;
import support.shapes.attribute.*;

import static sketches.sketch20230901a.DividedType.*;

public class DividedQuad0 extends DividedQuad
{
    protected final int seed1, seed2;

    protected DividedQuad0(PApplet pApplet, PVector v1, PVector v2, PVector v3, PVector v4, Attribute attr,
                           float minEndArea, float maxEndArea, DividedType type, DividedQuad0 parent)
    {
        super(pApplet, v1, v2, v3, v4, attr, minEndArea, maxEndArea, type, parent);
        this.seed1 = (int)pApplet.random(65536);
        this.seed2 = (int)pApplet.random(65536);
    }

    public DividedQuad0(PApplet pApplet, PVector v1, PVector v2, PVector v3, PVector v4, Attribute attr, float minEndArea, float maxEndArea)
    {
        this(pApplet, v1, v2, v3, v4, attr, minEndArea, maxEndArea, TYPE0, null);
    }

    public DividedQuad0(PApplet pApplet, Attribute attr, float minEndArea, float maxEndArea)
    {
        this(pApplet, new PVector(), new PVector(0, pApplet.height), new PVector(pApplet.width, pApplet.height),
                new PVector(pApplet.width, 0), attr, minEndArea, maxEndArea);
    }

    @Override
    protected void createChildren()
    {
        float endArea = calcEndArea();
        if (getArea() < endArea) { return; }

        float s1 = Easing.easeInOutQuad(pApplet.random(1));
        float s2 = s1;
        DividedQuad0 child1, child2;

        if (isVerticalType())
        {
            PVector vd1 = PVector.lerp(v1, v2, s1);
            PVector vd2 = PVector.lerp(v4, v3, s2);
            child1 = createChild(v1, vd1, vd2, v4, TYPE1);
            child2 = createChild(vd1, v2, v3, vd2, TYPE2);
        }
        else
        {
            PVector vd1 = PVector.lerp(v1, v4, s1);
            PVector vd2 = PVector.lerp(v2, v3, s2);
            child1 = createChild(v1, v2, vd2, vd1, TYPE3);
            child2 = createChild(vd1, vd2, v3, v4, TYPE4);
        }
        children.add(child1);
        children.add(child2);
        child1.createChildren();
        child2.createChildren();
    }

    private DividedQuad0 createChild(PVector v1, PVector v2, PVector v3, PVector v4, DividedType type)
    {
        return new DividedQuad0(pApplet, v1, v2, v3, v4, attr, minEndArea, maxEndArea, type, this);
    }

    @Override
    protected float calcEndArea() { return map(sq(pApplet.random(1)), 0, 1, minEndArea, maxEndArea); }
}
