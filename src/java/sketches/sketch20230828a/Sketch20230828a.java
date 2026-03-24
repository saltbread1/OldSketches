package sketches.sketch20230828a;

import sketches.Sketch;

import processing.core.*;

public class Sketch20230828a extends Sketch
{
    private CircleManager cm;
    private BezierManager bm;

    @Override
    public void settings()
    {
        size(1920, 1080);
    }

    @Override
    public void setup()
    {
        initialize();
    }

    @Override
    public void initialize()
    {
        float r = min(width, height)*.4F;
        cm = new CircleManager();
        bm = new BezierManager();
        cm.preProcessing(this, r, 2000);
        bm.preProcessing(this, r, 200);
    }

    @Override
    public void draw()
    {
        background(0xffffffff);
        cm.drawCircles(this);
        bm.drawBeziers(this);
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230828a.class);
    }
}
