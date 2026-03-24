package sketches.sketch20230830a;

import sketches.Sketch;
import processing.core.*;

public class Sketch20230830a extends Sketch
{
    private BezierCircleManager bcm;

    @Override
    public void settings()
    {
        size(1920, 1080);
        //size(960, 540);
    }

    @Override
    public void setup()
    {
        initialize();
    }

    @Override
    public void initialize()
    {
        bcm = new BezierCircleManager(this);
        bcm.preProcessing();
    }

    @Override
    public void draw()
    {
        background(0xff000000);
        bcm.drawBezierCircles();
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230830a.class);
    }
}
