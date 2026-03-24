package support.shapes;

import processing.core.PVector;

public interface Rotatable3D
{
    void rotate3D(PVector axis, float rad, PVector init);
}
