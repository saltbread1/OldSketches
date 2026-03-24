QuadDivision _divQuad;
int _seed;

void setup()
{
    size(3200, 3200);
    smooth();
    noLoop();
    initialize();
}

void initialize()
{
    clearScene();
    _seed = (int)random(65536); // 38952
    println(_seed);
    randomSeed(_seed);
    PVector v1 = new PVector(0, 0);
    PVector v2 = new PVector(0, height);
    PVector v3 = new PVector(width, height);
    PVector v4 = new PVector(width, 0);
    _divQuad = new QuadDivision(new Quad(v1, v2, v3, v4));
    _divQuad.divideQuad();
}

void draw()
{
    clearScene();
    _divQuad.drawQuads();
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

void clearScene() { background(#ffffff); }

void saveImage() { saveFrame("images/" + timestamp() + "-" + _seed + ".png"); }

color createColor()
{
    float r = random(1);
    if (r < .05) { return #121212; }
    else if (r < .1) { return #e0e0e0; }
    int hueOffset = 133, hueStepSize = 87, hueStepCount = 4;
    int hue = hueOffset + hueStepSize * (int)random(hueStepCount);
    int sat = (int)constrain((sq(random(1))*120), 0, 100);
    int bri =(int)(sq(random(1))*100);
    return color(hue, sat, bri);
}

class QuadDivision
{
    final Quad _initQuad;
    ArrayList<Quad> _quadlist;

    QuadDivision(Quad initQuad)
    {
        _initQuad = initQuad;
    }

    void divideQuad()
    {
        _quadlist = new ArrayList<Quad>();
        _initQuad.division(_quadlist);
    }

    void drawQuads()
    {
        for (Quad quad : _quadlist)
        {
            QuadDrawing qd = new QuadDrawing(quad);
            qd.drawMe();
        }
    }
}

class Quad
{
    final PVector _v1, _v2, _v3, _v4;
    final float _area;
    final float _minArea = map(sq(random(sqrt(random(1)))), 0, 1, 2800, 56000);

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
}

class QuadDrawing
{
    final PVector _v1, _v2, _v3, _v4;
    final float _area;

    QuadDrawing(Quad quad)
    {
        _v1 = quad._v1;
        _v2 = quad._v2;
        _v3 = quad._v3;
        _v4 = quad._v4;
        _area = quad._area;
    }

    void drawMe()
    {
        if (random(1) < .5) { drawQuadStyle(); }
        else { drawTriangleStyle(); }
    }

    void drawQuadStyle()
    {
        push();
        colorMode(HSB, 360, 100, 100, 100);
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
        float size = max(sqrt(_area)*.3, 1);
        stroke(#121212);
        for (int i = 0; i < size; i+=4)
        {
            PVector newv1 = PVector.add(_v1, PVector.mult(d1, i/size));
            PVector newv2 = PVector.add(_v2, PVector.mult(d2, i/size));
            PVector newv3 = PVector.add(_v3, PVector.mult(d3, i/size));
            PVector newv4 = PVector.add(_v4, PVector.mult(d4, i/size));
            fill(createColor());
            quad(newv1.x, newv1.y, newv2.x, newv2.y, newv3.x, newv3.y, newv4.x, newv4.y);
            noStroke();
        }
        pop();
    }

    void drawTriangleStyle()
    {
        drawTriangle(_v1, _v2, _v3);
        drawTriangle(_v3, _v4, _v1);
    }

    void drawTriangle(PVector v1, PVector v2, PVector v3)
    {
        push();
        colorMode(HSB, 360, 100, 100, 100);
        stroke(#121212);
        fill(createColor());
        triangle(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);

        float a = PVector.dist(v2, v3);
        float b = PVector.dist(v3, v1);
        float c = PVector.dist(v1, v2);
        // Heron's formula
        float s = (a+b+c)/2;
        float area = sqrt(s*(s-a)*(s-b)*(s-c));
        if (area > 2800 && area < 8400) { pop(); return; }

        float r = area*2/(a+b+c);
        PVector inn = PVector.mult(v1, a).add(PVector.mult(v2, b)).add(PVector.mult(v3, c)).div(a+b+c); // inner center
        Circle circle = area < 2800 ? new Circle1(inn, r) : new Circle2(inn, r);
        circle.drawMe();
        pop();
    }
}

abstract class Circle
{
    final PVector _center;
    final float _radius;

    Circle(PVector center, float radius)
    {
        _center = center;
        _radius = radius;
    }

    abstract void drawMe();
}

class Circle1 extends Circle
{
    Circle1(PVector center, float radius) { super(center, radius); }

    @Override
    void drawMe()
    {
        push();
        color c = random(1) < .5 ? #121212 : #e0e0e0;
        noStroke();
        fill(c);
        circle(_center.x, _center.y, _radius*2);
        pop();
    }
}

class Circle2 extends Circle
{
    Circle2(PVector center, float radius) { super(center, radius); }

    @Override
    void drawMe()
    {
        push();
        colorMode(HSB, 360, 100, 100);
        noStroke();
        for (float r = _radius; r > 0; r-= 6)
        {
            fill(createColor());
            circle(_center.x, _center.y, r*2);
        }
        pop();
    }
}