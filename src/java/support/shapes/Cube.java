package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;

import java.util.ArrayList;

public class Cube extends SimpleShape3D implements Translatable, Rotatable3D
{
    public PVector center;
    public float edge;
    public ArrayList<Quad> faceList;

    public Cube(PVector center, float edge, Attribute attr)
    {
        super(attr);
        this.center = center;
        this.edge = edge;
    }

    public Cube(PVector center, float edgeLength)
    {
        this(center, edgeLength, null);
    }

    @Override
    public void createFaces()
    {
        faceList = new ArrayList<>();
        PVector vt1 = new PVector(-edge/2, -edge/2, -edge/2).add(center);
        PVector vt2 = new PVector(-edge/2, -edge/2,  edge/2).add(center);
        PVector vt3 = new PVector( edge/2, -edge/2,  edge/2).add(center);
        PVector vt4 = new PVector( edge/2, -edge/2, -edge/2).add(center);
        PVector vb1 = new PVector(-edge/2,  edge/2, -edge/2).add(center);
        PVector vb2 = new PVector(-edge/2,  edge/2,  edge/2).add(center);
        PVector vb3 = new PVector( edge/2,  edge/2,  edge/2).add(center);
        PVector vb4 = new PVector( edge/2,  edge/2, -edge/2).add(center);

//        PVector vt1 = new PVector(-edge/2, -edge/2, -edge/2).add(center);
//        PVector vt2 = new PVector(-edge/2,  edge/2, -edge/2).add(center);
//        PVector vt3 = new PVector( edge/2,  edge/2, -edge/2).add(center);
//        PVector vt4 = new PVector( edge/2, -edge/2, -edge/2).add(center);
//        PVector vb1 = new PVector(-edge/2, -edge/2, -edge/2).add(center);
//        PVector vb2 = new PVector(-edge/2,  edge/2,  edge/2).add(center);
//        PVector vb3 = new PVector( edge/2,  edge/2,  edge/2).add(center);
//        PVector vb4 = new PVector( edge/2, -edge/2,  edge/2).add(center);
        addFace(vt1, vt4, vt3, vt2);
        addFace(vt1, vt2, vb2, vb1);
        addFace(vt2, vt3, vb3, vb2);
        addFace(vt3, vt4, vb4, vb3);
        addFace(vt4, vt1, vb1, vb4);
        addFace(vb1, vb2, vb3, vb4);
    }

    @Override
    public void addFace(PVector... v)
    {
        faceList.add(new Quad(v[0], v[1], v[2], v[3], attr));
    }

    @Override
    public Cube copy() { return new Cube(center.copy(), edge, attr.copy()); }

    @Override
    public void drawShape(PGraphics pg)
    {
        for (Quad face : faceList) { face.drawMe(pg); }
    }

    @Override
    public void translate(PVector dv)
    {
        for (Quad face : faceList)
        {
            face.translate(dv);
        }
    }

    @Override
    public void rotate3D(PVector axis, float rad, PVector init)
    {
        for (Quad face : faceList)
        {
            face.rotate3D(axis, rad, init);
        }
    }
}
