package sketches.sketch20230901a;

import processing.core.*;

import support.shapes.*;
import support.shapes.attribute.*;

import java.util.ArrayList;

public class DividedQuad extends Quad
{
    protected final PApplet pApplet;
    protected final float minEndArea, maxEndArea;
    protected final DividedType type;
    protected final DividedQuad parent;
    protected final ArrayList<DividedQuad> children;

    protected DividedQuad(PApplet pApplet, PVector v1, PVector v2, PVector v3, PVector v4, Attribute attr,
                           float minEndArea, float maxEndArea, DividedType type, DividedQuad parent)
    {
        super(v1, v2, v3, v4, attr);
        this.pApplet = pApplet;
        this.minEndArea = minEndArea;
        this.maxEndArea = maxEndArea;
        this.type = type;
        this.parent = parent;
        this.children = new ArrayList<>();
    }

    public void initialize() { createChildren(); }

    protected void createChildren() {}

    protected float calcEndArea() { return pApplet.random(minEndArea, maxEndArea); }

    public void updateMe(float time) {}

    @Override
    public void drawMe(PGraphics pg)
    {
        if (children.isEmpty()) { super.drawMe(pg); }
        children.forEach(child -> child.drawMe(pg));
    }

    /**
     * Determine if it is a vertical or horizontal type
     * @return Return true for vertical type, false otherwise.
     */
    protected final boolean isVerticalType()
    {
        // vertical type        horizontal type
        // vd1, vd2 are internal division points on the edges
        // v1 ---- v4           v1 ----vd1----- v4
        // |       |            |               |
        // vd1     vd2          |               |
        // |       |            v2 ----vd2----- v3
        // v2 ---- v3
        return PVector.dist(v1, v2) + PVector.dist(v3, v4) > PVector.dist(v2, v3) + PVector.dist(v4, v1);
    }
}
