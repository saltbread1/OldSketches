package sketches.sketch20230830a;

import support.shapes.*;
import support.util.*;

import processing.core.*;
import java.util.ArrayList;
import static processing.core.PApplet.*;

public class BezierCircleManager
{
    private final PApplet pApplet;
    private final float maxRadius;
    private ArrayList<BezierCircle> circles;

    public BezierCircleManager(PApplet pApplet)
    {
        this.pApplet = pApplet;
        maxRadius = min(pApplet.width, pApplet.height) * .12F;
    }

    public ArrayList<BezierCircle> getCircles() { return circles; }

    public void preProcessing()
    {
        circles = new ArrayList<>();
        while (true)
        {
            BezierCircle circle = addCircle(360);
            if (circle == null) { break; }
            float r = circle.radius / maxRadius;
            circle.preProcessing((int)((.14F+sqrt(r))*360), (int)(PMath.smoothstep(-.04F, .85F, r)*16));
            circles.add(circle);
        }
    }

    public void drawBezierCircles()
    {
        circles.forEach(circle -> circle.drawMe(pApplet.g));
    }

    private BezierCircle addCircle(int maxTrialIterations)
    {
        for (int i = 0; i < maxTrialIterations; i++)
        {
            PVector c = new PVector(pApplet.random(-.1F, 1.1F)*pApplet.width, pApplet.random(-.1F, 1.1F)*pApplet.height);
            float r = 0;
            while (r < 24) { r = Easing.easeInOutQuad(pApplet.random(1F)) * maxRadius; }
            BezierCircle circle = new BezierCircle(pApplet, c, r);
            if (!isOverlap(circle)) { return circle; }
        }
        return null;
    }

    private boolean isOverlap(Circle circle)
    {
        for (Circle other : circles)
        {
            float d = PVector.dist(circle.center, other.center);
            if (d < (circle.radius + other.radius)*1.6) { return true; }
        }
        return false;
    }
}
