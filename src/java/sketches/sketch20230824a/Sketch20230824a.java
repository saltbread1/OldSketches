package sketches.sketch20230824a;

import sketches.Sketch;
import processing.core.*;

public class Sketch20230824a extends Sketch
{
    private Ground ground;

    @Override
    public void settings()
    {
        size(1920, 1080, P3D);
    }
    
    @Override
    public void setup()
    {
        camera(0, -height*.72F, height, 0, 0, 0, 0, 1, 0);
        initialize();
    }
    
    @Override
    public void initialize()
    {
        ground = new Ground(new PVector(0, 0, -height*1.4F), width*4, height*4);
        ground.createCubes(this, 150);
    }
    
    @Override
    public void draw()
    {
        background(0xff000000);
        ground.drawMe(this);
    }
    
    public static void main(String[] args)
    {
        PApplet.main(Sketch20230824a.class);
    }
}
