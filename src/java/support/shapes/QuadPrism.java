package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.PVector;

import java.util.ArrayList;

public class QuadPrism extends StandingSolid
{
    public Quad bottomFace, topFace;

    public QuadPrism(Quad bottomFace, Quad topFace, Attribute attr)
    {
        super(attr);
        this.bottomFace = bottomFace;
        this.topFace = topFace;
    }

    public QuadPrism(Quad bottomFace, Quad topFace)
    {
        this(bottomFace, topFace, null);
    }

    public QuadPrism(Quad bottomFace, float height, Attribute attr)
    {
        super(attr);
        PVector normal = PVector.sub(bottomFace.v2, bottomFace.v1)
                .cross(PVector.sub(bottomFace.v4, bottomFace.v1))
                .normalize();
        this.bottomFace = bottomFace;
        topFace = bottomFace.copy();
        topFace.translate(normal.mult(height));
    }

    public QuadPrism(Quad bottomFace, float height)
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
        addFace(bottomFace.v3, bottomFace.v4, topFace.v4, topFace.v3);
        addFace(bottomFace.v4, bottomFace.v1, topFace.v1, topFace.v4);
    }

    @Override
    public void addFace(PVector... v)
    {
        faceList.add(new Quad(v[0].copy(), v[1].copy(), v[2].copy(), v[3].copy(), attr));
    }

    @Override
    public QuadPrism copy()
    {
        return new QuadPrism(bottomFace.copy(), topFace.copy(), attr.copy());
    }
}
