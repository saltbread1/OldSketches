package sketches.sketch20230826a;

import sketches.Sketch;

import processing.core.*;

public class Sketch20230826a extends Sketch
{
    private CircleManager cm;

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
        cm = new CircleManager(new PVector(width/2, height/2), width*1.3F, height*1.3F);
        cm.preProcessing(this, 80, 10);
    }

    @Override
    public void draw()
    {
        background(0xff000000);
        cm.drawCircles(this);
    }

    @Override
    public void additionalKeyPressed() {}

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230826a.class);
    }
}
