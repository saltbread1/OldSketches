package sketches.sketch20230825a;

import support.shapes.*;
import support.shapes.attribute.*;
import support.util.*;
import processing.core.*;
import static processing.core.PApplet.*;

import java.util.ArrayList;

public class Particle extends SimpleShape
{
    public final PVector initCenter;
    public final float initRadius;
    private ArrayList<Circle> circleList;

    public Particle(PVector initCenter, float initRadius, Attribute attr)
    {
        super(attr);
        this.initCenter = initCenter;
        this.initRadius = initRadius;
    }

    public void preProcessing(PApplet pApplet, float speed, float shrinkRatio, Attribute initAttr)
    {
        PVector center = initCenter;
        float radius = initRadius;
        circleList = new ArrayList<>();
        //circleList.add(new Circle(center, radius, attr));
        while (radius > 1)
        {
            float size = min(pApplet.width, pApplet.height);
            float n = pApplet.noise(center.x/size, center.y/size);
            float rad = PMath.mod(n*100, TAU);
            PVector dir = new PVector(
                    pow(abs(cos(rad)), sqrt(rad)+1) * PMath.sign(cos(rad)),
                    pow(abs(sin(rad)), sqrt(rad)+1) * PMath.sign(sin(rad)))
                    .normalize();
            center = dir.mult(speed).add(center);
            radius *= shrinkRatio;
            float t = sqrt(map(radius, 1, initRadius, 1, 0));
            circleList.add(new Circle(center, radius, Util.mixAttribute(initAttr, attr, t)));
        }
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        for (Circle circle : circleList) { circle.drawMe(pg); }
    }

    public boolean drawOneStep(PGraphics pg, int i)
    {
        if (i < 0 || i >= circleList.size()) { return false; }
        circleList.get(i).drawMe(pg);
        return true;
    }

    @Override
    public Particle copy() { return new Particle(initCenter.copy(), initRadius, attr); }
}
