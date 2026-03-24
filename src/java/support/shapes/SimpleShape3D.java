package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.PVector;

public abstract class SimpleShape3D extends SimpleShape
{
    public SimpleShape3D(Attribute attr) { super(attr); }

    public SimpleShape3D() { super(); }

    public abstract void createFaces();

    public abstract void addFace(PVector... v);
}
