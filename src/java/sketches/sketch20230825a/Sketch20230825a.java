package sketches.sketch20230825a;

import sketches.Sketch;
import processing.core.*;

public class Sketch20230825a extends Sketch
{
    private GenerativeCircle circle;
    private int seed;

    @Override
    public void settings()
    {
        size(1080, 1080);
    }

    @Override
    public void setup()
    {
        initialize();
    }

    @Override
    public void initialize()
    {
        seed = (int)random(65536);
        noiseSeed(seed);
        println(seed);
        circle = new GenerativeCircle(new PVector(width/2, height/2), height*.5F);
        circle.preProcessing(this);
    }

    @Override
    public void draw()
    {
        background(0xff000000);
        circle.drawMe(this);
    }

    @Override
    public void additionalKeyPressed()
    {
        if (key == 'S') { saveImage(seed); }
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230825a.class);
    }
}
