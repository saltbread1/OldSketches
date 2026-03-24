package sketches.sketch20230908a;

import processing.core.*;

import static processing.core.PApplet.*;

import support.util.*;
import support.shapes.attribute.Attribute;

import java.util.ArrayList;
import java.util.List;

import static support.shapes.attribute.DrawStyle.*;

public class FlowerManager
{
    private final PApplet pApplet;
    private final List<Flower> flowers;
    private final int[] palette = {0xf0880000, 0xf0884264, 0xf0885500, 0xf0888800, 0xf0600060, 0xf0000088, 0xf0008000, 0xf0888888};

    public FlowerManager(PApplet pApplet)
    {
        this.pApplet = pApplet;
        flowers = new ArrayList<>();
    }

    public void preProcessing(int n)
    {
        flowers.clear();
        for (int i = 0; i < n; i++)
        {
            PVector c = Util.randomScreen(pApplet);
            float r = 0;
            while (r < 4) { r = sq(pApplet.random(1)) * min(pApplet.width, pApplet.height) * .1F; }
            int pn = (int)pApplet.random(6, 12);
            Attribute attr = new Attribute(Util.chooseInt(pApplet, palette), FILLONLY);
            Flower flower = new Flower(pApplet, c, r, pn, attr);
            flowers.add(flower);
        }
        flowers.sort((flower1, flower2) ->
        {
            float size1 = flower1.getSize();
            float size2 = flower2.getSize();
            if (size1 == size2) { return -1; }
            return (int) PMath.sign(size2 - size1);
        });
    }

    public void display()
    {
        flowers.forEach(Flower::drawMe);
    }
}
