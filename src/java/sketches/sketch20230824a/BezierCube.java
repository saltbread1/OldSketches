package sketches.sketch20230824a;

import support.shapes.*;
import support.shapes.attribute.*;
import support.util.*;
import processing.core.*;
import static processing.core.PApplet.*;

public class BezierCube extends Cube
{
    public BezierCube(PVector center, float edge, Attribute attr)
    {
        super(center, edge, attr);
    }

    @Override
    public void addFace(PVector... v)
    {
        faceList.add(new BezierSquare(v[0], v[1], v[2], v[3], attr));
    }

    public void faceProcessing(PApplet pApplet, PVector normal, PVector center2bottom, float endR)
    {
        rotate3D(normal, pApplet.random(TAU), center);
        rotate3D(PMath.randomNormal(normal), pApplet.random(PI*.19F), center);
        PVector bottom = null;
        for (Quad q : faceList)
        {
            BezierSquare sq = (BezierSquare) q;
            if (q.equals(faceList.get(faceList.size()-1)))
            {
                bottom = PVector.mult(normal, -pApplet.random(2.3F, 6.1F) * edge).add(sq.getCenter());
                sq.preProcessing(pApplet, bottom, normal, endR, attr);
            }
            else { sq.preProcessing(pApplet, pApplet.random(1.4F, 2.6F) * edge, attr); }
        }
        translate(PVector.add(center, center2bottom).sub(bottom));
    }
}
