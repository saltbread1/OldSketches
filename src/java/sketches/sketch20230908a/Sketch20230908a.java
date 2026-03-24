package sketches.sketch20230908a;

import processing.core.*;

import processing.opengl.PShader;
import sketches.Sketch;

public class Sketch20230908a extends Sketch
{
    private PShader shader;
    private FlowerManager fm;

    @Override
    public void settings()
    {
        size(1920, 1080, P2D);
        //size(960, 540, P2D);
    }

    @Override
    public void setup()
    {
        shader = loadShader("sketches/sketch20230908a/data/fragment.glsl");
        initialize();
    }

    @Override
    public void initialize()
    {
        fm = new FlowerManager(this);
        fm.preProcessing(1024);
    }

    @Override
    public void draw()
    {
        background(0xff000000);
        blendMode(ADD);
        fm.display();
        filter(shader);
//        blendMode(BLEND);
//        resetShader();
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230908a.class);
    }
}
