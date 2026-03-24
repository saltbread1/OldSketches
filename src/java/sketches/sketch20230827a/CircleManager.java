package sketches.sketch20230827a;

import processing.core.*;
import processing.opengl.PShader;

import java.util.ArrayList;

import static processing.core.PApplet.*;

public class CircleManager
{
    private ArrayList<CircleStick> circles;

    public CircleManager()
    {
    }

    public void preProcessing(PApplet pApplet, PShader shader, PVector dir, float initY, int n)
    {
        circles = new ArrayList<>();
        for (int i = 0; i < n; i++)
        {
            float offX = pApplet.width*.05F;
            float initX = pApplet.random(-offX, pApplet.width+offX);
            float radius = 0;
            while (radius < 16) { radius = (1 - sqrt(pApplet.random(1))) * pApplet.height * .12F; }
            float rand = -1;
            while (rand < 0) { rand = pApplet.randomGaussian()+2F; }
            float length = rand * pApplet.height * .12F;
            CircleStick circle = new CircleStick(new PVector(initX, initY), radius);
            circle.preProcessing(pApplet, shader, dir, length);
            circles.add(circle);
        }
        circles.sort((c1, c2) ->
        {
            float r1 = c1.getRadius();
            float r2 = c2.getRadius();
            if (r1 > r2) { return -1; }
            else if (r1 == r2) { return 0; }
            return 1;
        });
    }

    public void drawCircles(PApplet pApplet)
    {
        circles.forEach(circle -> circle.drawMe(pApplet));
    }
}
