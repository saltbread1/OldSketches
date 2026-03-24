package sketches.sketch20230830a;

import support.shapes.*;
import support.shapes.attribute.*;

import processing.core.*;

import java.util.ArrayList;

import static processing.core.PApplet.*;

public class BezierCircle extends Circle
{
    private final PApplet pApplet;
    private ArrayList<BinaryBezier> beziers;
    private static final float GOLD_RADIANS = TAU / (1+(1+sqrt(5))/2);
    private final int[] palette1 = {0xffff4500, 0xffff6347, 0xffffa500, 0xffff8c00, 0xffffd700, 0xffffb6c1, 0xffff69b4, 0xffff1493};
    private final int[] palette2 = {0xff00bfff, 0xff87ceeb, 0xffadd8e6, 0xff00ced1, 0xff4682b4, 0xff1e90ff, 0xff6495ed, 0xff87cefa};

    public BezierCircle(PApplet pApplet, PVector center, float radius)
    {
        super(center, radius);
        this.pApplet = pApplet;
    }

    public void preProcessing(int n1, int n2)
    {
        beziers = new ArrayList<>();
        float rad = pApplet.random(TAU);
        for (int i = 0; i < n2; i++)
        {
            BinaryBezier bezier = createBezier2(rad);
            bezier.preProcessing(pApplet.random(.5F, .7F), 16);
            beziers.add(bezier);
            rad += GOLD_RADIANS;
        }
        for (int i = 0; i < n1; i++)
        {
            BinaryBezier bezier = createBezier1(rad);
            bezier.preProcessing(pApplet.random(.4F, .7F), 16);
            beziers.add(bezier);
            rad += GOLD_RADIANS;
        }
        //Collections.shuffle(beziers);
    }

    private BinaryBezier createBezier1(float rad)
    {
        PVector start = center.copy();
        PVector goal = PVector.fromAngle(rad).mult(radius * sq(pApplet.random(1))).add(center);
        int col = pApplet.random(1) < .5 ? palette1[(int)pApplet.random(palette1.length)] : palette2[(int)pApplet.random(palette2.length)];
        Attribute attr = new Attribute(col, max(.1F, (1-sqrt(pApplet.random(1)))*1.6F), DrawStyle.STROKEONLY);
        attr.setStrokeAlpha((int)(sqrt(attr.getWeight()) * 140));
        return new BinaryBezier(pApplet, start, goal, attr);
    }

    private BinaryBezier createBezier2(float rad)
    {
        PVector start = center.copy();
        PVector goal = PVector.fromAngle(rad).mult(radius * sqrt(pApplet.random(1)) * 1.3F).add(center);
        Attribute attr1 = new Attribute(palette2[(int)pApplet.random(palette2.length)], DrawStyle.FILLONLY);
        Attribute attr2 = new Attribute(palette1[(int)pApplet.random(palette1.length)], DrawStyle.FILLONLY);
        return new BinaryBezier2(pApplet, start, goal, attr1, attr2);
    }

    @Override
    public void drawMe(PGraphics pg)
    {
        beziers.forEach(bezier -> bezier.drawMe(pg));
    }
}
