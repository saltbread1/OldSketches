class MassBlockes
{
    final Quad _initQuad;
    ArrayList<Block> _blocklist;

    MassBlockes(Quad initQuad)
    {
        _initQuad = initQuad;
    }

    void createCeilingBlockes()
    {
        QuadDivision quadDiv = new QuadDivision(_initQuad);
        quadDiv.division();
        ArrayList<Quad> quadlist = quadDiv._quadlist;
        _blocklist = new ArrayList<Block>();
        while (quadlist.size() > 0)
        {
            Quad quad = quadlist.get(0);
            PVector vc = PVector.add(quad._v1, quad._v2).add(quad._v3).add(quad._v4).div(4);
            float height = (sq(1 - sqrt(vc.magSq()/(_initQuad._area/2))) + abs(randomGaussian())/16) * sqrt(quad._area) * 20;
            Block block = new CeilingBlock(quad, height);
            block.selectColors();
            _blocklist.add(block);
            quadlist.remove(0);
        }
    }

    void createFloorBlockes()
    {
        QuadDivision quadDiv = new QuadDivision(_initQuad);
        quadDiv.division();
        ArrayList<Quad> quadlist = quadDiv._quadlist;
        _blocklist = new ArrayList<Block>();
        while (quadlist.size() > 0)
        {
            Quad quad = quadlist.get(0);
            Block block = new FloorBlock(quad, sqrt(quad._area));
            block.selectColors();
            _blocklist.add(block);
            quadlist.remove(0);
        }
    }

    void drawBlockes()
    {
        for (Block block : _blocklist) { block.drawMe(); }
    }
}

class QuadDivision
{
    final Quad _initQuad;
    ArrayList<Quad> _quadlist;

    QuadDivision(Quad initQuad)
    {
        _initQuad = initQuad;
    }

    void division()
    {
        _quadlist = new ArrayList<Quad>();
        _initQuad.division(_quadlist);
    }
}

class Quad
{
    final PVector _v1, _v2, _v3, _v4;
    final float _area, _minArea, _limitArea;

    Quad(PVector v1, PVector v2, PVector v3, PVector v4, float minArea)
    {
        _v1 = v1; _v2 = v2; _v3 = v3; _v4 = v4;
        _area = calcArea();
        _minArea = minArea;
        _limitArea = (1 + sq(random(sqrt(random(1))))*5) * minArea;
    }

    float calcArea()
    {
        // calc area; Bretschneider's formula
        PVector e1 = PVector.sub(_v2, _v1);
        PVector e2 = PVector.sub(_v2, _v3);
        PVector e3 = PVector.sub(_v4, _v3);
        PVector e4 = PVector.sub(_v4, _v1);
        float el1 = e1.mag(), el2 = e2.mag(), el3 = e3.mag(), el4 = e4.mag();
        float s = (el1 + el2 + el3 + el4)/2;
        float theta = PVector.angleBetween(e1, e4) + PVector.angleBetween(e2, e3);
        return sqrt((s-el1)*(s-el2)*(s-el3)*(s-el4)-el1*el2*el3*el4*sq(cos(theta/2)));
    }

    void division(ArrayList<Quad> quadlist)
    {
        if (_area <= _limitArea)
        {
            quadlist.add(this);
            return;
        }

        // float s = random(.2, .8);
        // float t = 1-s;//random(.35, .65);
        float s = random(.4, .5);
        float t = random(.4, .5);
        Quad newQuad1, newQuad2;
        if (  PVector.sub(_v2, _v1).mag() + PVector.sub(_v4, _v3).mag()
            > PVector.sub(_v2, _v3).mag() + PVector.sub(_v4, _v1).mag())
        {
            PVector vd1 = PVector.mult(_v1, s).add(PVector.mult(_v2, 1-s));
            PVector vd2 = PVector.mult(_v3, t).add(PVector.mult(_v4, 1-t));
            newQuad1 = new Quad(_v1, vd1, vd2, _v4, _minArea);
            newQuad2 = new Quad(_v2, _v3, vd2, vd1, _minArea);
        }
        else
        {
            PVector vd1 = PVector.mult(_v2, s).add(PVector.mult(_v3, 1-s));
            PVector vd2 = PVector.mult(_v4, t).add(PVector.mult(_v1, 1-t));
            newQuad1 = new Quad(_v1, _v2, vd1, vd2, _minArea);
            newQuad2 = new Quad(vd2, vd1, _v3, _v4, _minArea);
        }
        newQuad1.division(quadlist);
        newQuad2.division(quadlist);
    }
}

abstract class Block
{
    PVector _v1, _v2, _v3, _v4;
    float _height;
    color _cFill, _cStroke;
    float _alpha;

    Block(Quad quad, float height)
    {
        _v1 = quad._v1;
        _v2 = quad._v2;
        _v3 = quad._v3;
        _v4 = quad._v4;
        _height = height;
    }

    void drawMe()
    {
        //PVector normal = PVector.sub(_v2, _v1).cross(PVector.sub(_v1, _v4)).normalize().mult(_height);
        PVector normal = new PVector(0, 0, 1).mult(_height);

        pushStyle();
        fill(_cFill, _alpha);
        stroke(_cStroke);

        // top-bottom via one side
        beginShape(QUAD_STRIP);
        myVertex(_v1); myVertex(_v2); myVertex(_v4); myVertex(_v3);
        myVertex(PVector.add(_v4, normal)); myVertex(PVector.add(_v3, normal));
        myVertex(PVector.add(_v1, normal)); myVertex(PVector.add(_v2, normal));
        endShape();

        // side
        beginShape(QUAD_STRIP);
        myVertex(_v4); myVertex(PVector.add(_v4, normal));
        myVertex(_v1); myVertex(PVector.add(_v1, normal));
        myVertex(_v2); myVertex(PVector.add(_v2, normal));
        myVertex(_v3); myVertex(PVector.add(_v3, normal));
        endShape();

        popStyle();
    }

    abstract void selectColors();
}

class CeilingBlock extends Block
{
    CeilingBlock(Quad quad, float height)
    {
        super(quad, height);
    }

    void selectColors()
    {
        float tmp = random(1);
        _cFill = tmp < .5 ? #212121 : #dcdcdc;
        _cStroke = tmp < .5 ? #660000 : #aa0000;
        _alpha = (int)random(155, 250);
    }
}

class FloorBlock extends Block
{
    FloorBlock(Quad quad, float height)
    {
        super(quad, height);
        PVector vc = PVector.add(_v1, _v2).add(_v3).add(_v4).div(4);
        float z = (-1 + noise(vc.x*.001, vc.y*.001)*2) * 250;
        PVector normal = new PVector(0, 0, 1).mult(z);
        _v1 = PVector.add(_v1, normal);
        _v2 = PVector.add(_v2, normal);
        _v3 = PVector.add(_v3, normal);
        _v4 = PVector.add(_v4, normal);
    }

    void selectColors()
    {
        color[][] palette = {{#212121, #666666}, {#dcdcdc, #800000}, {#bc0000, #000000}};
        int index = (int)random(palette.length);
        _cFill = palette[index][0];
        _cStroke = palette[index][1];
        _alpha = (int)random(120, 215);
    }
}
