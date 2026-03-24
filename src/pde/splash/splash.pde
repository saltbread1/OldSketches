import peasy.*;
import quaternion.*;

PGraphics _pg;
Torus _initTorus;
ArrayList<TorusCurve> _curveList;
int _randomSeed;

void setup()
{
    size(1920, 1080, P2D);
    _pg = createGraphics(width, height, P3D);
    initialize();
}

void initialize()
{
    seedSettings();
    
    _initTorus = new Torus(new PVector(width/2, height/2), 240, 28);
    _curveList = new ArrayList<TorusCurve>();
    for (int i = 0; i < 32; i++)
    {
        TorusCurve curve = new TorusCurve(_initTorus, random(40, 90));
        curve.createTorusList((int)random(6, 24));
        _curveList.add(curve);
    }
    _initTorus.createFaces(0, TAU);
    _initTorus.fluctuateFaces();
}

void seedSettings()
{
    _randomSeed = (int)random(65536);
    //_randomSeed = 58071;
    println("randomSeed: " + _randomSeed);
    randomSeed(_randomSeed);
}

void draw()
{
    clearScene();
    _pg.beginDraw();
    _pg.background(#ffffff);
    _pg.ambientLight(128, 128, 128);
    _pg.directionalLight(220, 220, 220, 0, 0, -1);
    _pg.pushStyle();
    _pg.noStroke();
    _pg.fill(#3c9fe4);
    _initTorus.drawMe(_pg);
    _pg.popStyle();
    for (TorusCurve curve : _curveList) { curve.drawToruses(_pg); }
    _pg.endDraw();
    image(_pg, 0, 0);
}

void keyPressed()
{
    if (key == 's' || key == 'S') { saveImage(); }
    else if (key == 'r' || key == 'R') { initialize(); }
}

String timestamp()
{
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) 
        + "_"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    return timestamp;
}

void clearScene() { background(#000000); }

void saveImage() { saveFrame(timestamp() + "_" + _randomSeed + "_####.png"); }

void myVertex(PVector v)
{
    vertex(v.x, v.y, v.z);
}

void myVertex(PVector v, PGraphics pg)
{
    pg.vertex(v.x, v.y, v.z);
}

PVector rotate3D(PVector target, PVector dir, float rad, PVector init)
{
    Quaternion q = new Quaternion(dir, rad);
    Quaternion qi = q.inverse(null);
    Quaternion qr = q.multr(PVector.sub(target, init)).multreq(qi);
    return new PVector(qr.x, qr.y, qr.z).add(init);
}