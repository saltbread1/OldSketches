package sketches.sketch20230826a;

import support.shapes.*;
import support.shapes.attribute.*;

import processing.core.*;

public class ConvergenceCircle extends Circle
{
    public ConvergenceCircle(PVector center, float radius, Attribute attr)
    {
        super(center, radius, attr);
    }

    public ConvergenceCircle(PVector center, float radius)
    {
        super(center, radius);
    }

    @Override
    public void drawShape(PGraphics pg) {}
}
