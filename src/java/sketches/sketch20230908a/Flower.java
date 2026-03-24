package sketches.sketch20230908a;

import processing.core.*;

import static processing.core.PApplet.*;

import support.util.*;
import support.shapes.*;
import support.shapes.attribute.Attribute;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Flower
{
    private final PApplet pApplet;
    private final PVector center;
    private final float petalSize;
    private final List<Quad> petals;

    public Flower(PApplet pApplet, PVector center, float petalSize, int petalNum, Attribute attr)
    {
        this.pApplet = pApplet;
        this.center = center;
        this.petalSize = petalSize;

        float dRad = TAU/petalNum;
        float initRad = pApplet.random(dRad);
        petals = IntStream.range(0, petalNum).mapToObj(i ->
        {
            float x = pApplet.random(.6F, .8F) * petalSize;
            float y = Easing.easeMiddleQuad(pApplet.random(.1F, .9F)) * x * tan(dRad*.5F);
            PVector v1 = new PVector();
            PVector v2 = new PVector(x, y);
            PVector v3 = new PVector(petalSize, 0);
            PVector v4 = new PVector(x, -y);
            Quad petal = new Quad(v1, v2, v3, v4, attr);
            petal.rotate(initRad + dRad*i, v1);
            petal.translate(center);
            return petal;
        }).collect(Collectors.toList());
    }

    public PVector getCenter() { return center; }

    public float getSize() { return petalSize; }

    public void drawMe()
    {
        petals.forEach(petal -> petal.drawMe(pApplet));
    }
}
