package sketches.sketch20230828a;

import support.shapes.*;
import support.shapes.attribute.*;

import processing.core.*;

import java.util.ArrayList;

import static processing.core.PApplet.*;

public class CircleManager
{
    private ArrayList<Circle> circles;

    public CircleManager()
    {
    }

    public void preProcessing(PApplet pApplet, float centerRadius, int n)
    {
        circles = new ArrayList<>();
        for (int i = 0; i < n; i++)
        {
            PVector center = PVector.fromAngle(pApplet.random(TAU)).mult(tan(pApplet.random(TAU))*centerRadius)
                    .add(new PVector(pApplet.width/2F, pApplet.height/2F));
            float radius = 0;
            while (radius < 4) { radius = (1-sqrt(pApplet.random(1)))*min(pApplet.width, pApplet.height)*.04F; }
            Attribute attr = pApplet.random(1) < .5
                    ? new Attribute(0xffffffff, 0xff000000, 1.4F, DrawStyle.STROKEANDFILL)
                    : new Attribute(0xff000000, 0xffffffff, 1.4F, DrawStyle.STROKEANDFILL);
            circles.add(new Circle(center, radius, attr));
        }
    }

    public void drawCircles(PApplet pApplet)
    {
        circles.forEach(circle -> circle.drawMe(pApplet));
    }
}
