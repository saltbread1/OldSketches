package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;
import static processing.core.PApplet.*;

public class Circle3D extends RegularPolygon
{
    private final float threshEdgeLen;

    public Circle3D(PVector center, float radius, float threshEdgeLen, PVector normal, Attribute attr)
    {
        super(center, radius, calcVerticesNum(radius, threshEdgeLen, 6), normal, attr);
        this.threshEdgeLen = threshEdgeLen;
    }

    public Circle3D(PVector center, float radius, float threshEdgeLen, PVector normal)
    {
        this(center, radius, threshEdgeLen, normal, null);
    }

    @Override
    public Circle3D copy()
    {
        return new Circle3D(center.copy(), radius, threshEdgeLen, normal.copy(), attr.copy());
    }

    /**
     * get number of vertices which makes this object's edge length less than threshold
     * @param radius circle radius
     * @param threshEdgeLen threshold of edge length
     * @param minNum minimum number of vertices
     * @return number of vertices
     */
    public static int calcVerticesNum(float radius, float threshEdgeLen, int minNum)
    {
        int n = minNum-1;
        float el;
        do { el = 2 * sq(radius) * (1 - cos(TAU / ++n)); }
        while (el >= threshEdgeLen);

        return n;
    }
}
