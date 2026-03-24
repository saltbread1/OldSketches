package sketches.sketch20230826a;

import support.shapes.*;
import support.shapes.attribute.*;

import processing.core.*;

import java.util.ArrayList;

import static processing.core.PApplet.*;

public class CircleManager
{
    private ArrayList<Circle> circles;
    private final PVector center;
    private final float width, height;

    public CircleManager(PVector center, float width, float height)
    {
        this.center = center;
        this.width = width;
        this.height = height;
    }

    public void preProcessing(PApplet pApplet, int nd, int nc)
    {
        circles = new ArrayList<>();
        ArrayList<ConvergenceCircle> convergenceCircles = new ArrayList<>();
        for (int i = 0; i < nc; i++)
        {
            ConvergenceCircle circle = getNewConvergenceCircle(pApplet, 100);
            if (circle == null) { break; }
            circles.add(circle);
            convergenceCircles.add(circle);
        }
        for (int i = 0; i < nd; i++)
        {
            DivergenceCircle circle = getNewDivergenceCircle(pApplet, 100);
            if (circle == null) { break; }
            circles.add(circle);
        }
        circles.forEach(circle ->
        {
            if (circle instanceof DivergenceCircle)
            {
                ((DivergenceCircle) circle).preProcessing(pApplet, (int)pApplet.random(4, 10), convergenceCircles);
            }
        });
    }

    public void drawCircles(PApplet pApplet)
    {
        circles.forEach(circle -> circle.drawMe(pApplet));
    }

    private DivergenceCircle getNewDivergenceCircle(PApplet pApplet, int maxTrialIterations)
    {
        for (int i = 0; i < maxTrialIterations; i++)
        {
            PVector c = new PVector(pApplet.random(-1, 1)*width/2, pApplet.random(-1, 1)*height/2).add(center);
            float r = pApplet.random(.1F, 1F) * min(pApplet.width, pApplet.height) * .084F;
            Attribute attr = new Attribute(0xffffffff, DrawStyle.STROKEONLY);
            DivergenceCircle circle = new DivergenceCircle(c, r, attr);
            if (!isOverlap(circle)) { return circle; }
        }
        return null;
    }

    private ConvergenceCircle getNewConvergenceCircle(PApplet pApplet, int maxTrialIterations)
    {
        for (int i = 0; i < maxTrialIterations; i++)
        {
            PVector c = new PVector(pApplet.random(-1, 1)*width/2, pApplet.random(-1, 1)*height/2).add(center);
            float r = pApplet.random(.4F, 1F) * min(pApplet.width, pApplet.height) * .044F;
            Attribute attr = new Attribute(0xffff00ff, DrawStyle.STROKEONLY);
            ConvergenceCircle circle = new ConvergenceCircle(c, r, attr);
            if (!isOverlap(circle)) { return circle; }
            return circle;
        }
        return null;
    }

    private boolean isOverlap(Circle circle)
    {
        for (Circle other : circles)
        {
            float d = PVector.dist(circle.center, other.center);
            if (d < circle.radius + other.radius) { return true; }
        }
        return false;
    }
}
