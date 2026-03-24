import processing.opengl.*;

CircleGenerator _cg;
int _randomSeed, _noiseSeed;

void setup()
{
    size(1920, 1080, OPENGL);
    smooth();
    initialize();
}

void initialize()
{
    seedSettings();
    _cg = new CircleGenerator(200);
    _cg.createCircleList();
}

void draw()
{
    clearScene();
    _cg.drawMe();
}

void keyPressed()
{
    if (key == 's' || key == 'S') { saveImage(); }
    else if (key == 'r' || key == 'R') { initialize(); redraw(); }
}

String timestamp()
{
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) 
        + "_"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    return timestamp;
}

void clearScene() { background(#000000); }

void saveImage() { saveFrame(timestamp() + "_" + _randomSeed + "_" + _noiseSeed + "_####.png"); }

void seedSettings()
{
    _randomSeed = (int)random(65536);
    _noiseSeed = (int)random(65536);
    println("randomSeed: " + _randomSeed);
    println("noiseSeed: " + _noiseSeed);
    randomSeed(_randomSeed);
    noiseSeed(_noiseSeed);
}

void myVertex(PVector v)
{
    vertex(v.x, v.y);
}
