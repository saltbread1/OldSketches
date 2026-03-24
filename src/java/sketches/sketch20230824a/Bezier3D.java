package sketches.sketch20230824a;

import support.shapes.*;
import support.shapes.attribute.*;
import processing.core.*;
import processing.data.FloatList;
import static processing.core.PApplet.*;

import java.util.ArrayList;

public class Bezier3D extends Bezier
{
    private ArrayList<Circle3D> circleList;

    public Bezier3D(PVector start, PVector control1, PVector control2, PVector goal)
    {
        super(start, control1, control2, goal);
    }

    public void preProcessing(float dl, float startR, float endR, PVector initNorm, Attribute attr)
    {
        circleList = new ArrayList<>();
        FloatList params = calcRegularIntervalParams(dl);
        int n = params.size();
        for (int i = 0; i < n; i++)
        {
            float ct = params.get(i);
            float pt = i == 0 ? 0 : params.get(i-1);
            PVector normal = i == 0 ? initNorm : PVector.sub(bezierPoint(ct), bezierPoint(pt));
            Circle3D circle = new Circle3D(bezierPoint(ct), lerp(startR, endR, sqrt((float)i/n)), 4, normal, attr);
            circleList.add(circle);
        }
    }

    public void preProcessingFade(float dl, float startR, float endR, PVector initNorm, Attribute attr)
    {
        circleList = new ArrayList<>();
        FloatList params = calcRegularIntervalParams(dl);
        int n = params.size();
        for (int i = 0; i < n; i++)
        {
            float ct = params.get(i);
            float pt = i == 0 ? 0 : params.get(i-1);
            PVector normal = i == 0 ? initNorm : PVector.sub(bezierPoint(ct), bezierPoint(pt));
            float t = sqrt((float)i/n);
            Attribute attr2 = attr.copy();
            attr2.setStrokeAlpha((int)(attr.getStrokeAlpha()*(1-t)));
            attr2.setFillAlpha((int)(attr.getFillAlpha()*(1-t)));
            Circle3D circle = new Circle3D(bezierPoint(ct), lerp(startR, endR, t), 4, normal, attr2);
            circleList.add(circle);
        }
    }

    @Override
    public void drawMe(PGraphics pg)
    {
        for (Circle3D circle : circleList) { circle.drawMe(pg); }
    }

    @Override
    public void translate(PVector dv)
    {
        super.translate(dv);
        if (circleList == null) { return; }
        for (Circle3D circle : circleList) { circle.translate(dv); }
    }

    @Override
    public void rotate(float rad, PVector init)
    {
        super.rotate(rad, init);
        if (circleList == null) { return; }
        for (Circle3D circle : circleList) { circle.rotate(rad, init); }
    }

    @Override
    public void rotate(float rad)
    {
        rotate(rad, start);
    }

    @Override
    public void rotate3D(PVector axis, float rad, PVector init)
    {
        super.rotate3D(axis, rad, init);
        if (circleList == null) { return; }
        for (Circle3D circle : circleList) { circle.rotate3D(axis, rad, init); }
    }
}
