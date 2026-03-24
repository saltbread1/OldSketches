package sketches.sketch20230826a;

import support.shapes.*;
import support.shapes.attribute.*;

import processing.core.*;

import java.util.ArrayList;

public class DivergenceCircle extends Circle
{
    private ArrayList<MyBezier> beziers;
    
    public DivergenceCircle(PVector center, float radius, Attribute attr)
    {
        super(center, radius, attr);
    }

    public DivergenceCircle(PVector center, float radius)
    {
        super(center, radius);
    }
    
    public void preProcessing(PApplet pApplet, int n, ArrayList<ConvergenceCircle> circles)
    {
        beziers = new ArrayList<>();
        for (int i = 0; i < n; i++)
        {
            PVector dir = PVector.random2D();
            PVector start = PVector.mult(dir, radius).add(center);
            ConvergenceCircle circle = circles.stream().min((c1, c2) ->
            {
                PVector dir1 = PVector.sub(c1.center, center);
                PVector dir2 = PVector.sub(c2.center, center);
                float val = PVector.angleBetween(dir, dir1) - PVector.angleBetween(dir, dir2);
                if (val > 0) { return 1; }
                else if (val == 0) { return 0; }
                return -1;
            }).get();
//            PVector goal = PVector.sub(start, circle.center).normalize()
//                    .mult(pApplet.random(.5F, 1F)*circle.radius).add(circle.center);
            PVector goal = circle.center;
            MyBezier bezier = new MyBezier(pApplet, start, goal);
            //bezier.preProcessing(pApplet, 4, 2);
            beziers.add(bezier);
        }
    }
    
    @Override
    public void drawShape(PGraphics pg)
    {
        //super.drawShape(pg);
        beziers.forEach(bezier -> bezier.drawMe(pg));
    }
}
