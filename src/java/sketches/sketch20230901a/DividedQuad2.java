package sketches.sketch20230901a;

import processing.core.*;

import support.util.*;
import support.shapes.attribute.*;

import static processing.core.PApplet.*;
import static sketches.sketch20230901a.DividedType.*;

public class DividedQuad2 extends DividedQuad
{
    // params[i] is internal division ratio on the edge (i = 0, 1, 2, 3, 0 < params[i] < 1).
    // ex: params[0] is on the edge by v1 and v2, params[3] is on the edge by v4 and v1.
    private final float[] params;
    private final int depth;
    private final int[] palette = {0xffe63946, 0xff1d3557, 0xff4a2545, 0xff0b5351, 0xfff5e663, 0xfff34213, 0xff415d43, 0xfff42272};

    protected DividedQuad2(PApplet pApplet, PVector v1, PVector v2, PVector v3, PVector v4, Attribute attr,
                        float minEndArea, float maxEndArea, float[] params, DividedType type, DividedQuad parent, int depth)
    {
        super(pApplet, v1, v2, v3, v4, attr, minEndArea, maxEndArea, type, parent);
        this.params = params;
        this.depth = depth;
    }

    public DividedQuad2(PApplet pApplet, PVector v1, PVector v2, PVector v3, PVector v4, Attribute attr, float minEndArea, float maxEndArea)
    {
        super(pApplet, v1, v2, v3, v4, attr, minEndArea, maxEndArea, TYPE0, null);
        params = new float[4];
        for (int i = 0; i < 4; i++) { params[i] = Easing.easeMiddleQuad(pApplet.random(.1F, .9F)); }
        depth = 0;
    }

    public DividedQuad2(PApplet pApplet, Attribute attr, float minEndArea, float maxEndArea)
    {
        this(pApplet, new PVector(), new PVector(0, pApplet.height), new PVector(pApplet.width, pApplet.height),
                new PVector(pApplet.width, 0), attr, minEndArea, maxEndArea);
    }

    @Override
    protected void createChildren()
    {
        if (depth > 10 && getArea() < calcEndArea()) { return; }

        DividedQuad2 child1, child2;
        float sd = Easing.easeInOutQuad(pApplet.random(.2F, .8F));

        if (isVerticalType())
        {
            PVector vd1 = PVector.lerp(v1, v2, params[0]);
            PVector vd2 = PVector.lerp(v4, v3, params[2]);
            child1 = createChild(v1, vd1, vd2, v4, new float[]{params[0], sd, params[2], params[3]}, TYPE1);
            child2 = createChild(vd1, v2, v3, vd2, new float[]{params[0], params[1], params[2], sd}, TYPE2);
        }
        else
        {
            PVector vd1 = PVector.lerp(v1, v4, params[3]);
            PVector vd2 = PVector.lerp(v2, v3, params[1]);
            child1 = createChild(v1, v2, vd2, vd1, new float[]{params[0], params[1], sd, params[3]}, TYPE3);
            child2 = createChild(vd1, vd2, v3, v4, new float[]{sd, params[1], params[2], params[3]}, TYPE4);
        }
        children.add(child1);
        children.add(child2);
        child1.createChildren();
        child2.createChildren();
    }

    private DividedQuad2 createChild(PVector v1, PVector v2, PVector v3, PVector v4, float[] params, DividedType type)
    {
        return new DividedQuad2(pApplet, v1, v2, v3, v4, attr, minEndArea, maxEndArea, params, type, this, depth+1);
    }

    @Override
    protected float calcEndArea() { return map(1 - sqrt(pApplet.random(1)), 0, 1, minEndArea, maxEndArea); }

    @Override
    public void drawMe(PGraphics pg)
    {
        if (children.isEmpty())
        {
            int n = palette.length;
            pg.pushStyle();
            for (int i = 0; i < n; i++)
            {
                float t1 = (float)i/n;
                float t2 = (float)(i+1)/n;
                PVector a = PVector.lerp(v1, v2, t1);
                PVector b = PVector.lerp(v1, v2, t2);
                PVector c = PVector.lerp(v4, v3, t2);
                PVector d = PVector.lerp(v4, v3, t1);
                pg.noStroke();
                pg.fill(palette[i]);
                Util.quad(pg, a, b, c, d);
                pg.stroke(0, 222);
                pg.strokeWeight(.4F);
                pg.noFill();
                Util.line(pg, a, d);
            }
            pg.popStyle();
            super.drawMe(pg);
        }
        children.forEach(child -> child.drawMe(pg));
    }
}
