package support.pattern;

import processing.core.*;

import support.shapes.*;

import java.util.ArrayList;

public abstract class PatternUnit
{
    protected final PApplet pApplet;
    protected final float width, height;
    private final ArrayList<SimpleShape> shapes;

    public PatternUnit(PApplet pApplet, float width, float height)
    {
        this.pApplet = pApplet;
        this.width = width;
        this.height = height;
        this.shapes = new ArrayList<>();
    }

    protected final void addShape(SimpleShape shape) { shapes.add(shape); }

    protected final ArrayList<SimpleShape> getShapes(PVector topLeft, float rotateRad)
    {
        shapes.clear();
        createPattern();
        shapes.forEach(shape ->
        {
            if (shape instanceof Rotatable) { ((Rotatable) shape).rotate(rotateRad, new PVector(width/2, height/2)); }
            if (shape instanceof Translatable) { ((Translatable) shape).translate(topLeft); }
        });
        return shapes;
    }

    /**
     * Create SimpleShape instances and add to the list using "addShape" method.
     * Shapes should be placed in the range of (0, 0) - (width, height).
     */
    public abstract void createPattern();

    /**
     * for debug
     * @param pg drawn target
     * @param topLeft upper left position
     */
    public void drawMe(PGraphics pg, PVector topLeft)
    {
        pg.pushMatrix();
        pg.translate(topLeft.x, topLeft.y);
        shapes.forEach(shape -> shape.drawMe(pg));
        pg.popMatrix();
    }

    /**
     * for debug
     * @param pApplet drawn target
     * @param topLeft upper left position
     */
    public void drawMe(PApplet pApplet, PVector topLeft)
    {
        drawMe(pApplet.g, topLeft);
    }
}
