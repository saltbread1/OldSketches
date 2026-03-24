package sketches.sketch20230901a;

import support.shapes.attribute.*;
import sketches.Sketch;

import processing.core.*;

import static support.shapes.attribute.DrawStyle.*;

public class Sketch20230901a extends Sketch
{
    private DividedQuad quad;

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
        PVector offset = new PVector(width, height).mult(.05F);
        quad = new DividedQuad2(this, new PVector(-offset.x, -offset.y), new PVector(-offset.x, height+offset.y),
                new PVector(width+offset.x, height+offset.y), new PVector(width+offset.x, -offset.y),
                new Attribute(0xff000000, .4F, STROKEONLY),
                min(width, height)*.24F, min(width, height)*32F);
        quad.initialize();
    }

    @Override
    public void draw()
    {
        background(0xff000000);
        quad.updateMe(frameCount*.01F);
        quad.drawMe(g);
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230901a.class);
    }
}
