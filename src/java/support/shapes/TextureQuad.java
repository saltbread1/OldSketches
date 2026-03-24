package support.shapes;

import support.util.*;
import support.shapes.attribute.*;
import static support.shapes.attribute.DrawStyle.*;
import processing.core.*;

public class TextureQuad extends Quad
{
    private PImage img;

    public TextureQuad(PVector v1, PVector v2, PVector v3, PVector v4, PImage img, Attribute attr, int id)
    {
        super(v1, v2, v3, v4, attr, id);
        this.img = img;
    }

    public TextureQuad(PVector v1, PVector v2, PVector v3, PVector v4, PImage img, Attribute attr)
    {
        this(v1, v2, v3, v4, img, attr, 0);
    }

    public TextureQuad(PVector v1, PVector v2, PVector v3, PVector v4, PImage img, int id)
    {
        this(v1, v2, v3, v4, img, new Attribute(0xffffffff, FILLONLY), id);
    }

    public TextureQuad(PVector v1, PVector v2, PVector v3, PVector v4, PImage img)
    {
        this(v1, v2, v3, v4, img, 0);
    }

    public void setImage(PImage img) { this.img = img; }

    public PImage getImage() { return img; }

    @Override
    public TextureQuad copy()
    {
        return new TextureQuad(v1.copy(), v2.copy(), v3.copy(), v4.copy(), img.copy(), attr.copy());
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        if (img == null)
        {
            super.drawShape(pg);
            return;
        }
        pg.beginShape(pg.QUADS);
        pg.texture(img);
        Util.vertex(pg, v1, 0, 0);  // v1 ---- v4
        Util.vertex(pg, v2, 0, 1);  // |       |
        Util.vertex(pg, v3, 1, 1);  // |       |
        Util.vertex(pg, v4, 1, 0);  // v2 ---- v3
        pg.endShape();
    }

    @Override
    public void drawMe(PGraphics pg)
    {
        pg.textureMode(pg.NORMAL);
        pg.pushStyle();
        pg.tint(attr.getFill());
        drawShape(pg);
        pg.popStyle();
        pg.textureMode(pg.IMAGE);
    }
}
