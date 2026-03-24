package sketches.sketch20230828a;

import support.shapes.attribute.*;

import processing.core.*;

import java.util.ArrayList;

import static processing.core.PApplet.*;

public class BezierManager
{
    private ArrayList<FractalBezier> beziers;
    private final int[] palette1 = {0xffff4500, 0xffff6347, 0xffffa500, 0xffff8c00, 0xffffd700, 0xffffb6c1, 0xffff69b4, 0xffff1493};
    private final int[] palette2 = {0xff00bfff, 0xff87ceeb, 0xffadd8e6, 0xff00ced1, 0xff4682b4, 0xff1e90ff, 0xff6495ed, 0xff87cefa};

    public BezierManager()
    {
    }

    public void preProcessing(PApplet pApplet, float centerRadius, int n)
    {
        beziers = new ArrayList<>();
        for (int i = 0; i < n; i++)
        {
            PVector center = new PVector(pApplet.width/2F, pApplet.height/2F);
            float rad = pApplet.random(TAU);
            float rad0 = atan2(pApplet.height, pApplet.width);
            float m = 0;
            if (rad < rad0 || (rad > PI-rad0 && rad < PI+rad0) || rad > TAU-rad0) { m = (pApplet.width/2F)/abs(cos(rad)); }
            else { m = (pApplet.height/2F)/abs(sin(rad)); }
            PVector dir = PVector.fromAngle(rad);
            PVector start = PVector.mult(dir, m).add(center);
            float randVal = 1 - pApplet.random(pApplet.random(pApplet.random(1)));
            PVector goal = PVector.mult(dir, centerRadius * randVal).add(center);
            int col1 = palette1[(int)pApplet.random(palette1.length)];
            int col2 = palette2[(int)pApplet.random(palette2.length)];
            Attribute attr1 = new Attribute(col1, 1.4F, DrawStyle.STROKEONLY);
            Attribute attr2 = new Attribute(col2, 1.4F, DrawStyle.STROKEONLY);
            FractalBezier bezier = new FractalBezier(pApplet, start, goal, attr1, attr2);
            bezier.preProcessing(pApplet, 3, pApplet.random(8, 32));
            beziers.add(bezier);
        }
    }

    public void drawBeziers(PApplet pApplet)
    {
        beziers.forEach(bezier -> bezier.drawMe(pApplet));
    }
}
