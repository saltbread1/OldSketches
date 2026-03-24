package sketches.sketch20230824a;

import support.shapes.*;
import support.shapes.attribute.*;
import processing.core.*;

import java.util.ArrayList;

import static processing.core.PApplet.*;

public class Ground
{
    private ArrayList<Circle> circleList;
    private ArrayList<BezierCube> cubeList;
    private final PVector center;
    private final int width, height;
    private static final int[] palette = { 0x80ff4500, 0x80ff6347, 0x80ffa500, 0x80ff8c00, 0x80ffd700, 0x80ffb6c1, 0x80ff69b4, 0x80ff1493 };

    public Ground(PVector center, int width, int height)
    {
        this.center = center;
        this.width = width;
        this.height = height;
    }

    public void createCubes(PApplet pApplet, int n)
    {
        circleList = new ArrayList<>();
        for (int i = 0; i < n; i++)
        {
            if (!addCircle(pApplet, 100)) { break; }
        }

        cubeList = new ArrayList<>();
        for (Circle circle : circleList)
        {
            Attribute attr = new Attribute(palette[(int)pApplet.random(palette.length)], DrawStyle.STROKEONLY);
            BezierCube cube = new BezierCube(
                    new PVector(circle.center.x, 0, circle.center.y).sub(width/2, 0, height/2).add(center),
                    pApplet.random(.76F, 1.3F) * circle.radius,
                    attr);
            cube.createFaces();
            cube.faceProcessing(pApplet, new PVector(0, -1, 0), new PVector(0, 1000, 0), circle.radius);
            cubeList.add(cube);
        }
    }

    public void drawMe(PApplet pApplet)
    {
        for (BezierCube cube : cubeList) { cube.drawMe(pApplet); }
    }

    private boolean addCircle(PApplet pApplet, int maxTrialIterations)
    {
        for (int i = 0; i < maxTrialIterations; i++)
        {
            Circle circle = new Circle(
                    new PVector(pApplet.random(width), pApplet.random(height)),
                    min(pApplet.random(.32F, 1F), pApplet.random(.32F, 1F)) * min(width, height) * .064F,
                    new Attribute(0xffffffff, DrawStyle.FILLONLY));
            if (!isOverlap(circle))
            {
                circleList.add(circle);
                return true;
            }
        }
        return false;
    }

    private boolean isOverlap(Circle circle)
    {
        for (Circle other : circleList)
        {
            float d = PVector.dist(circle.center, other.center);
            if (d < circle.radius + other.radius) { return true; }
        }
        return false;
    }
}
