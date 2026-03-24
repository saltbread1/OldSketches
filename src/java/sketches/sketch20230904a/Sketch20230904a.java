package sketches.sketch20230904a;

import processing.core.*;

import processing.opengl.PShader;
import sketches.Sketch;

public class Sketch20230904a extends Sketch
{
    private PShader shader;

    @Override
    public void settings()
    {
        size(1080, 1920, P2D);
    }

    @Override
    public void setup()
    {
        shader = loadShader("sketches/sketch20230904a/data/fragment.glsl");
        shader.set("resolution", (float)width, (float)height);
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
        rect(0, 0, width, height);
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20230904a.class);
    }
}
