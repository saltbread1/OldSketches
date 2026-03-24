package sketches.sketch20230902a;

import support.pattern.PatternUnit;
import processing.core.*;

import static processing.core.PApplet.*;

import support.util.*;
import support.shapes.*;
import support.shapes.attribute.Attribute;

import static support.shapes.attribute.DrawStyle.*;

public class PatternUnit0 extends PatternUnit
{
    private static final float STROKE_WEIGHT = 3;
    private static final float LINE_WEIGHT = 5;
    private final int cStroke = 0xffffffff, cFill = 0xff000000;
    private final int[] palette = {0xff2191fb, 0xfffffb46, 0xffed4d6e, 0xff274c77, 0xffc05746, 0xffff7700, 0xff2a9134, 0xfffffb46};

    public PatternUnit0(PApplet pApplet, float width, float height) { super(pApplet, width, height); }

    @Override
    public void createPattern()
    {
        float offX = width*.24F;
        float offY = height*.24F;

        // line
        PVector[] lineVertices = {new PVector(width*.46F, height*.8F), new PVector(width*.46F, height*.6F),
                new PVector(width-offX, height*.6F), new PVector(width-offX, height)};
        addOutlinedLines(new VerticesShape(lineVertices, false));
        addOutlinedLine(new Line(new PVector(width-offX, offY), new PVector(width, offY)));
        addOutlinedLine(new Line(new PVector(width-offX, offY), new PVector(width-offX, 0)));

        // circles
        addOutlinedCircle(new Circle(width*.21F, height*.21F, min(width, height)*.021F));
        addOutlinedCircle(new Circle(width*.84F, height*.49F, min(width, height)*.054F));
        addOutlinedCircle(new Circle(width*.90F, height*.96F, min(width, height)*.038F));
        addVertexCircle(new Circle(width, height-offY, min(width, height)*.066F));
        addVertexCircle(new Circle(width-offX, offY, min(width, height)*.066F));
        addVertexCircle(new Circle(lineVertices[0].copy(), min(width, height)*.066F));

        // arc
        addOutlinedArc(new Arc(0, height, min(offX, offY), PI*1.5F, TAU, 0,
                new Attribute(0xff000000, STROKEONLY)));

        // bezier
        PVector start = new PVector(0, offY);
        PVector control1 = new PVector(width*.24F, offY);
        PVector control2 = new PVector(width*.3F, height*.66F);
        PVector goal = new PVector(width*.6F, height*.4F);
        addOutlinedBezier(new Bezier(start, control1, control2, goal));

        // square
        PVector[] cr = {new PVector(.09F, .12F), new PVector(.94F, .37F), new PVector(.42F, .22F),
                new PVector(.15F, .51F), new PVector(.25F, .70F), new PVector(.65F, .72F)};
        float[] rr = {.056F, .032F, .13F, .095F, .062F, .044F};
        for (int i = 0; i < cr.length; i++)
        {
            PVector c = new PVector(width*cr[i].x, height*cr[i].y);
            PVector v1 = PVector.fromAngle(pApplet.random(TAU)).mult(min(width, height)*rr[i]).add(c);
            PVector v2 = PMath.rotate(v1.copy(), HALF_PI, c);
            PVector v3 = PMath.rotate(v2.copy(), HALF_PI, c);
            PVector v4 = PMath.rotate(v3.copy(), HALF_PI, c);
            addOutlinedQuad(new Quad(v1, v2, v3, v4));
        }
    }

    private void addOutlinedShape(SimpleShape shapeIn, SimpleShape shapeOut)
    {
        shapeIn.setId(1);
        shapeOut.setId(0);
        addShape(shapeIn);
        addShape(shapeOut);
    }

    private void addOutlinedLine(Line lineIn)
    {
        Line lineOut = lineIn.copy();
        lineIn.setAttribute(new Attribute(cFill, LINE_WEIGHT, STROKEONLY));
        lineOut.setAttribute(new Attribute(cStroke, LINE_WEIGHT + STROKE_WEIGHT*2, STROKEONLY));
        addOutlinedShape(lineIn, lineOut);
    }

    private void addOutlinedLines(VerticesShape linesIn)
    {
        VerticesShape linesOut = linesIn.copy();
        linesIn.setAttribute(new Attribute(cFill, LINE_WEIGHT, ROUND, ROUND, STROKEONLY));
        linesOut.setAttribute(new Attribute(cStroke, LINE_WEIGHT + STROKE_WEIGHT*2, ROUND,  ROUND, STROKEONLY));
        addOutlinedShape(linesIn, linesOut);
    }

    private void addOutlinedBezier(Bezier bezierIn)
    {
        Bezier bezierOut = bezierIn.copy();
        bezierIn.setAttribute(new Attribute(cFill, LINE_WEIGHT, STROKEONLY));
        bezierOut.setAttribute(new Attribute(cStroke, LINE_WEIGHT + STROKE_WEIGHT*2, STROKEONLY));
        addOutlinedShape(bezierIn, bezierOut);
    }

    private void addOutlinedCircle(Circle circleIn)
    {
        Circle circleOut = circleIn.copy();
        circleOut.radius = circleIn.radius + STROKE_WEIGHT;
        circleIn.setAttribute(new Attribute(Util.chooseInt(pApplet, palette), FILLONLY));
        circleOut.setAttribute(new Attribute(cStroke, FILLONLY));
        addOutlinedShape(circleIn, circleOut);
    }

    private void addVertexCircle(Circle circleIn)
    {
        Circle circleOut = circleIn.copy();
        circleOut.radius = circleIn.radius + STROKE_WEIGHT;
        circleIn.setAttribute(new Attribute(cFill, FILLONLY));
        circleOut.setAttribute(new Attribute(cStroke, FILLONLY));
        addOutlinedShape(circleIn, circleOut);

        Circle inside = circleIn.copy();
        inside.radius = circleIn.radius - LINE_WEIGHT;
        inside.setAttribute(new Attribute(Util.chooseInt(pApplet, palette), FILLONLY));
        inside.setId(2);
        addShape(inside);
    }

    private void addOutlinedArc(Arc arcIn)
    {
        Arc arcOut = arcIn.copy();
        arcIn.setAttribute(new Attribute(cFill, LINE_WEIGHT, STROKEONLY));
        arcOut.setAttribute(new Attribute(cStroke, LINE_WEIGHT + STROKE_WEIGHT*2, STROKEONLY));
        addOutlinedShape(arcIn, arcOut);
    }

    private void addOutlinedQuad(Quad quadIn)
    {
        Quad quadOut = quadIn.copy();
        quadScaleChange(quadOut, - STROKE_WEIGHT * sqrt(2));
        quadIn.setAttribute(new Attribute(Util.chooseInt(pApplet, palette), FILLONLY));
        quadOut.setAttribute(new Attribute(cStroke, FILLONLY));
        addOutlinedShape(quadIn, quadOut);

        Quad inside = quadIn.copy();
        quadScaleChange(inside, LINE_WEIGHT * sqrt(2));
        if (inside.getArea() < 36) { return; }
        inside.setAttribute(new Attribute(cFill, FILLONLY));
        inside.setId(2);
        addShape(inside);
    }

    private void quadScaleChange(Quad quad, float diff)
    {
        PVector c = quad.getCenter();
        quad.v1 = PVector.sub(c, quad.v1).normalize().mult(diff).add(quad.v1);
        quad.v2 = PVector.sub(c, quad.v2).normalize().mult(diff).add(quad.v2);
        quad.v3 = PVector.sub(c, quad.v3).normalize().mult(diff).add(quad.v3);
        quad.v4 = PVector.sub(c, quad.v4).normalize().mult(diff).add(quad.v4);
    }
}
