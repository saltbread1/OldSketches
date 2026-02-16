QuadDivision _quadDivision;
int _seed;

void setup()
{
    size(1600, 900);
    smooth();
    noLoop();
    initialize();
}

void initialize()
{
    clearScene();
    _seed = (int)random(65536);
    println(_seed);
    randomSeed(55212); // 55212, 16092, 22704
    PVector v1 = new PVector(0, 0);
    PVector v2 = new PVector(0, height);
    PVector v3 = new PVector(width, height);
    PVector v4 = new PVector(width, 0);
    _quadDivision = new QuadDivision(new Quad(v1, v2, v3, v4));
    _quadDivision.divideQuad();
}

void draw()
{
    clearScene();
    _quadDivision.drawQuads();
}

void keyPressed()
{
    if (keyCode == 'S') { saveImage(); }
    else if (keyCode == 'R') { initialize(); redraw(); }
}

String timestamp()
{
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) 
        + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    return timestamp;
}

void clearScene() { background(#222244); }

void saveImage() { saveFrame(timestamp() + ".png"); }

class QuadDivision
{
    final Quad _initQuad;
    final ArrayList<Quad> _quadlist = new ArrayList<Quad>();

    QuadDivision(Quad initQuad)
    {
        _initQuad = initQuad;
    }

    void divideQuad()
    {
        _initQuad.division(_quadlist);
    }

    void drawQuads()
    {
        for (Quad quad : _quadlist) { quad.drawMe(); }
    }
}

class Quad
{
    final PVector _v1, _v2, _v3, _v4;
    final float _area;
    final float _minArea = map(sq(random(sqrt(random(1)))), 0, 1, 100, 7000);
    final int _hueOffset = 35, _hueStepSize = 87, _hueStepCount = 4;

    Quad(PVector v1, PVector v2, PVector v3, PVector v4)
    {
        _v1 = v1;
        _v2 = v2;
        _v3 = v3;
        _v4 = v4;
        _area = calcArea();
    }

    float calcArea()
    {
        // Bretschneider's formula
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
        if (_area <= _minArea)
        {
            quadlist.add(this);
            return;
        }

        float s = random(.25, .75);
        float t = random(.25, .75);
        Quad newQuad1, newQuad2;
        if (  PVector.sub(_v2, _v1).mag() + PVector.sub(_v4, _v3).mag()
            > PVector.sub(_v2, _v3).mag() + PVector.sub(_v4, _v1).mag())
        {
            PVector vd1 = PVector.mult(_v1, s).add(PVector.mult(_v2, 1-s));
            PVector vd2 = PVector.mult(_v3, t).add(PVector.mult(_v4, 1-t));
            newQuad1 = new Quad(_v1, vd1, vd2, _v4);
            newQuad2 = new Quad(_v2, _v3, vd2, vd1);
        }
        else
        {
            PVector vd1 = PVector.mult(_v2, s).add(PVector.mult(_v3, 1-s));
            PVector vd2 = PVector.mult(_v4, t).add(PVector.mult(_v1, 1-t));
            newQuad1 = new Quad(_v1, _v2, vd1, vd2);
            newQuad2 = new Quad(vd2, vd1, _v3, _v4);
        }
        newQuad1.division(quadlist);
        newQuad2.division(quadlist);
    }

    void drawMe()
    {
        push();
        colorMode(HSB, 360, 100, 100, 100);
        noStroke();
        // calculate the intersection of diagonals
        PVector p = PVector.sub(_v3, _v1);
        PVector q = PVector.sub(_v4, _v2);
        PVector r = PVector.sub(_v2, _v1);
        float k = (r.x * (-q.y) - (-q.x) * r.y) / (p.x * (-q.y) - (-q.x) * p.y);
        PVector is = PVector.add(_v1, PVector.mult(p, k));

        PVector d1 = PVector.sub(is, _v1);
        PVector d2 = PVector.sub(is, _v2);
        PVector d3 = PVector.sub(is, _v3);
        PVector d4 = PVector.sub(is, _v4);
        float size = max(sqrt(_area)*.3, 2);
        for (int i = 0; i < size; i++)
        {
            PVector newv1 = PVector.add(_v1, PVector.mult(d1, i/size));
            PVector newv2 = PVector.add(_v2, PVector.mult(d2, i/size));
            PVector newv3 = PVector.add(_v3, PVector.mult(d3, i/size));
            PVector newv4 = PVector.add(_v4, PVector.mult(d4, i/size));
            int hue = _hueOffset + _hueStepSize * (int)random(_hueStepCount);
            int sat = (int)constrain((sq(random(1))*120), 0, 100);
            int bri =(int)(sq(random(1))*100);
            fill(color(hue, sat, bri));
            quad(newv1.x, newv1.y, newv2.x, newv2.y, newv3.x, newv3.y, newv4.x, newv4.y);
        }
        pop();
    }
}