package support.pattern;

import support.shapes.*;
import processing.core.*;

import java.util.ArrayList;
import java.util.Collections;

import static processing.core.PApplet.*;

public class PatternGrid
{
    protected final PApplet pApplet;
    private final PatternUnit unit;
    private final PVector topLeft, bottomRight;
    private final int row, col;
    private final ArrayList<SimpleShape> shapes;

    public PatternGrid(PApplet pApplet, PatternUnit unit, PVector topLeft, PVector bottomRight)
    {
        this.pApplet = pApplet;
        this.unit = unit;
        this.topLeft = topLeft;
        this.bottomRight = bottomRight;
        float r = abs(bottomRight.x-topLeft.x)/unit.width;
        float c = abs(bottomRight.y-topLeft.y)/unit.height;
        row = ceil(r);
        col = ceil(c);
        topLeft.sub((row-r)/2*unit.width, (col-c)/2*unit.height);
        shapes = new ArrayList<>();
    }

    public PatternGrid(PApplet pApplet, PatternUnit unit)
    {
        this(pApplet, unit, new PVector(), new PVector(pApplet.width, pApplet.height));
    }

    public void preProcessing()
    {
        shapes.clear();
        for (int ci = 0; ci < col; ci++)
        {
            float y = unit.height * ci + topLeft.y;
            for (int ri = 0; ri < row; ri++)
            {
                float x = unit.width * ri + topLeft.x;
                shapes.addAll(unit.getShapes(new PVector(x, y), createRadians()));
            }
        }
        Collections.sort(shapes);
    }

    protected float createRadians()
    {
        return (int) pApplet.random(4) * HALF_PI;
    }

    public void drawMe(PGraphics pg) { shapes.forEach(shape -> shape.drawMe(pg)); }

    public void drawMe(PApplet pApplet) { drawMe(pApplet.g); }
}
