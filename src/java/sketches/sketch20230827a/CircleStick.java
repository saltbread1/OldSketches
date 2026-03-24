package sketches.sketch20230827a;

import support.shapes.attribute.*;

import processing.core.*;
import processing.opengl.PShader;

import java.util.ArrayList;

public class CircleStick
{
    private final PVector initCenter;
    private final float radius;
    private ArrayList<ShaderCircle> circles;
    private final int[] palette = {0xffaabbcc, 0xff334455, 0xff668811, 0xff33ffee, 0xffeeffdd, 0xffcc9922, 0xff44aa22, 0xff998877};

    public CircleStick(PVector initCenter, float radius)
    {
        this.initCenter = initCenter;
        this.radius = radius;
    }

    public float getRadius() { return radius; }

    public void preProcessing(PApplet pApplet, PShader shader, PVector dir, float length)
    {
        circles = new ArrayList<>();
        float dl = radius*.36F;
        float l = 0;
        float time = pApplet.random(64);
        Attribute attr = new Attribute(palette[(int)pApplet.random(palette.length)], DrawStyle.FILLONLY);
        while (l < length)
        {
            PVector center = PVector.mult(dir, l).add(initCenter);
            ShaderCircle circle = new ShaderCircle(pApplet, shader, center, radius, attr);
            circle.setupGraphics(time);
            circles.add(circle);
            l += dl;
            time += .32F;
        }
    }

    public void drawMe(PApplet pApplet)
    {
        circles.forEach(circle -> circle.drawMe(pApplet));
    }
}
