package sketches.sketch20230902a;

import support.pattern.PatternGrid;
import processing.core.*;

import sketches.Sketch;

public class Sketch20230902a extends Sketch
{
    private PatternUnit0 unit0;
    private PatternGrid grid;

    @Override
    public void settings()
    {
        size(1920, 1080);
        //size(800, 800);
    }

    @Override
    public void setup()
    {
        initialize();
    }

    @Override
    public void initialize()
    {
//        unit0 = new PatternUnit0(this, 400, 400);
//        unit0.createPattern();
        grid = new PatternGrid(this, new PatternUnit0(this, 160, 160));
        grid.preProcessing();
    }

    @Override
    public void draw()
    {
        background(0xff000000);
        //unit0.drawMe(this, new PVector(100, 100));
        grid.drawMe(this);
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230902a.class);
    }
}
