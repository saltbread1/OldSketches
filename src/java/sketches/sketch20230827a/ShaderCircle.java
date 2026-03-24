package sketches.sketch20230827a;

import support.shapes.*;
import support.shapes.attribute.*;

import processing.core.*;
import processing.opengl.PShader;

import static processing.core.PApplet.*;

public class ShaderCircle extends Circle
{
    private final PShader shader;
    private final PGraphics graphics;

    public ShaderCircle(PApplet pApplet, PShader shader, PVector center, float radius, Attribute attr)
    {
        super(center, radius, attr);
        this.shader = shader;
        graphics = pApplet.createGraphics((int)radius*2, (int)radius*2, P2D);
    }

    public ShaderCircle(PApplet pApplet, PShader shader, PVector center, float radius)
    {
        this(pApplet, shader, center, radius, null);
    }

    public void setupGraphics(float time)
    {
        graphics.beginDraw();
        graphics.background(0x00ffffff);
        shader.set("resolution", radius*2, radius*2);
        shader.set("time", time);
        graphics.shader(shader);
        graphics.pushStyle();
        if (attr == null) { graphics.fill(0xffffffff); }
        else { attr.apply(graphics); }
        graphics.noStroke();
        graphics.ellipse(radius, radius, radius*2, radius*2);
        graphics.resetShader();
        if (attr != null)
        {
            attr.apply(graphics);
            graphics.noFill();
            graphics.ellipse(radius, radius, radius*2, radius*2);
        }
        graphics.popStyle();
        graphics.endDraw();
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        pg.pushStyle();
        pg.imageMode(CENTER);
        pg.image(graphics, center.x, center.y);
        pg.popStyle();
    }
}
