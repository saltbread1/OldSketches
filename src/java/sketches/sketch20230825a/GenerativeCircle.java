package sketches.sketch20230825a;

import support.shapes.*;
import support.shapes.attribute.Attribute;
import support.shapes.attribute.DrawStyle;
import processing.core.*;
import static processing.core.PApplet.*;

import java.util.ArrayList;

public class GenerativeCircle extends Circle
{
    private ArrayList<Particle> particleList;
    private int[] palette = { 0xffca0000, 0xffc0c0c0 };

    public GenerativeCircle(PVector center, float radius)
    {
        super(center, radius);
    }

    public void preProcessing(PApplet pApplet)
    {
        particleList = new ArrayList<>();
        while (addCircle(pApplet, 1000));
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        int i = 0;
        while (true)
        {
            boolean isBreak = true;
            for (Particle p : particleList)
            {
                if (p.drawOneStep(pg, i))
                {
                    isBreak = false;
                }
            }
            if (isBreak) { break; }
            i++;
        }
    }

    private boolean addCircle(PApplet pApplet, int maxTrialIterations)
    {
        for (int i = 0; i < maxTrialIterations; i++)
        {
            float dist = pApplet.random(radius);
            int alpha = (int)(constrain((1F / sq((dist/radius + .001F)) - 1.06F) * .3F, 0, 1) * 75);
            //println(alpha);
            int cs = 0x40000000;
            int cf1 = palette[(int)pApplet.random(palette.length)] & 0x00ffffff | alpha << 24;
            int cf2 = 0x00000000 & 0x00ffffff | alpha << 24;
            Particle p = new Particle(
                    PVector.random2D().mult(dist).add(center),
                    max(4, sq(pApplet.random(1))*radius*.12F),
                    new Attribute(cs, cf1, DrawStyle.STROKEANDFILL));
            if (!isOverlap(p))
            {
                p.preProcessing(pApplet, 2, .99F, new Attribute(cs, cf2, DrawStyle.STROKEANDFILL));
                particleList.add(p);
                return true;
            }
        }
        return false;
    }

    private boolean isOverlap(Particle p)
    {
        for (Particle other : particleList)
        {
            float d = PVector.dist(p.initCenter, other.initCenter);
            if (d < p.initRadius + other.initRadius) { return true; }
        }
        return false;
    }
}
