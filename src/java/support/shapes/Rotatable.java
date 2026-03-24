package support.shapes;

import processing.core.PVector;

public interface Rotatable
{
    void rotate(float rad, PVector init);

    void rotate(float rad);
}
