package support.shapes;

import processing.data.FloatList;

public interface Curve
{
    float calcLength(int detail);

    float calcLength();

    FloatList calcRegularIntervalParams(float dl);
}
