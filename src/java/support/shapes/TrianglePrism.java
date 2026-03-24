package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;

import java.util.ArrayList;

public class TrianglePrism extends StandingSolid
{
    public Triangle bottomFace, topFace;

    public TrianglePrism(Triangle bottomFace, Triangle topFace, Attribute attr)
    {
        super(attr);
        this.bottomFace = bottomFace;
        this.topFace = topFace;
    }

    public TrianglePrism(Triangle bottomFace, Triangle topFace)
    {
        this(bottomFace, topFace, null);
    }

    public TrianglePrism(Triangle bottomFace, float height, Attribute attr)
    {
        super(attr);
        PVector normal = PVector.sub(bottomFace.v2, bottomFace.v1)
                .cross(PVector.sub(bottomFace.v3, bottomFace.v1))
                .normalize();
        this.bottomFace = bottomFace;
        topFace = bottomFace.copy();
        topFace.translate(normal.mult(height));
    }

    public TrianglePrism(Triangle bottomFace, float height)
    {
        this(bottomFace, height, null);
    }

    @Override
    public void createFaces()
    {
        faceList = new ArrayList<>();
        faceList.add(bottomFace);
        faceList.add(topFace);
        addFace(bottomFace.v1, bottomFace.v2, topFace.v2, topFace.v1);
        addFace(bottomFace.v2, bottomFace.v3, topFace.v3, topFace.v2);
        addFace(bottomFace.v3, bottomFace.v1, topFace.v1, topFace.v3);
    }

    @Override
    public void addFace(PVector... v)
    {
        faceList.add(new Quad(v[0].copy(), v[1].copy(), v[2].copy(), v[3].copy(), attr));
    }

    @Override
    public TrianglePrism copy()
    {
        return new TrianglePrism(bottomFace.copy(), topFace.copy(), attr.copy());
    }
}
