package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;
import static processing.core.PApplet.*;

import java.util.ArrayList;

public class RegularPolygonalPrism extends StandingSolid
{
    public RegularPolygon bottomFace, topFace;

    public RegularPolygonalPrism(RegularPolygon bottomFace, RegularPolygon topFace, Attribute attr)
    {
        super(attr);
        this.bottomFace = bottomFace;
        this.topFace = topFace;
    }

    public RegularPolygonalPrism(RegularPolygon bottomFace, RegularPolygon topFace)
    {
        this(bottomFace, topFace, null);
    }

    public RegularPolygonalPrism(RegularPolygon bottomFace, float height, Attribute attr)
    {
        super(attr);
        PVector[] vertices = bottomFace.vertices;
        PVector normal = PVector.sub(vertices[1], vertices[0])
                .cross(PVector.sub(vertices[vertices.length-1], vertices[0]))
                .normalize();
        this.bottomFace = bottomFace;
        topFace = bottomFace.copy();
        topFace.translate(normal.mult(height));
    }

    public RegularPolygonalPrism(RegularPolygon bottomFace, float height)
    {
        this(bottomFace, height, null);
    }

    @Override
    public void createFaces()
    {
        faceList = new ArrayList<>();
        faceList.add(bottomFace);
        faceList.add(topFace);
        PVector[] vb = bottomFace.vertices;
        PVector[] vt = topFace.vertices;
        int n = min(vb.length, vt.length);
        for (int i = 0; i < n; i++) { addFace(vb[i], vb[(i+1)%n], vt[(i+1)%n], vt[i]); }
    }

    @Override
    public void addFace(PVector... v)
    {
        faceList.add(new Quad(v[0].copy(), v[1].copy(), v[2].copy(), v[3].copy(), attr));
    }

    @Override
    public RegularPolygonalPrism copy()
    {
        return new RegularPolygonalPrism(bottomFace.copy(), topFace.copy(), attr.copy());
    }
}
