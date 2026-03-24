package sketches.sketch20230909a;

import processing.core.*;

import processing.opengl.PShader;

import sketches.Sketch;

public class Sketch20230909a extends Sketch
{
    private PShader shader;

    @Override
    public void settings()
    {
        size(1920, 1440, P2D);
        //size(960, 540);
    }

    @Override
    public void setup()
    {
        shader = loadShader("sketches/sketch20230909a/data/fragment.glsl");
        initialize();
    }

    @Override
    public void initialize()
    {
    }

    @Override
    public void draw()
    {
        background(0xff000000);
        shader(shader);
        pushStyle();
        noStroke();
        fill(255);
        rect(0, 0, width, height);
        popStyle();
        resetShader();
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230909a.class);
    }
}
