package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;

import java.util.ArrayList;

public abstract class StandingSolid extends SimpleShape3D implements Translatable, Rotatable3D
{
    public ArrayList<SimpleShape> faceList;

    public StandingSolid(Attribute attr) { super(attr); }

    public StandingSolid() { super(); }

    @Override
    public void drawShape(PGraphics pg)
    {
        for (SimpleShape face : faceList) { face.drawMe(pg); }
    }

    @Override
    public void translate(PVector dv)
    {
        for (SimpleShape face : faceList)
        {
            if (!(face instanceof Translatable)) { return; }
        }
        for (SimpleShape face : faceList)
        {
            Translatable tmp = (Translatable) face;
            tmp.translate(dv);
        }
    }

    @Override
    public void rotate3D(PVector dir, float rad, PVector init)
    {
        for (SimpleShape face : faceList)
        {
            if (!(face instanceof Rotatable3D)) { return; }
        }
        for (SimpleShape face : faceList)
        {
            Rotatable3D tmp = (Rotatable3D) face;
            tmp.rotate3D(dir, rad, init);
        }
    }
}
