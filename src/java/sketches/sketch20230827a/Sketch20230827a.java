package sketches.sketch20230827a;

import processing.opengl.PShader;
import sketches.Sketch;

import processing.core.*;

public class Sketch20230827a extends Sketch
{
    private PShader shader;
    private CircleManager cm1, cm2;

    @Override
    public void settings()
    {
        size(1920, 1080, P2D);
    }

    @Override
    public void setup()
    {
        shader = loadShader("sketches/sketch20230827a/data/fragment.glsl");
        initialize();
    }

    @Override
    public void initialize()
    {
        cm1 = new CircleManager();
        cm2 = new CircleManager();
        cm1.preProcessing(this, shader, new PVector(0, 1), 0, width/8);
        cm2.preProcessing(this, shader, new PVector(0, -1), height, width/8);
    }

    @Override
    public void draw()
    {
        background(0xffffffff);
        cm1.drawCircles(this);
        cm2.drawCircles(this);
    }

    @Override
    public void additionalKeyPressed()
    {
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230827a.class);
    }
}
