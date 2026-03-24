package sketches.sketch20231013a;

import processing.core.*;

import sketches.Sketch;

public class Sketch20231013a extends Sketch
{
    private ParticleManager pm;

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
        pm = new ParticleManager(this, 8, 32, 6400, 32, 64);
        pm.initialize();
    }

    @Override
    public void draw()
    {
        background(0xff000000);
        pm.updateParticles(4);
        pm.drawParticles();
    }

    public static void main(String[] args)
    {
        PApplet.main(Sketch20231013a.class);
    }
}
