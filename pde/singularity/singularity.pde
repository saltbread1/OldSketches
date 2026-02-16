import processing.opengl.*;
import quaternion.*;
import com.scrtwpns.Mixbox;

Icosphere _ico;
ArrayList<Icosphere> _subIcoList;
int _randomSeed, _noiseSeed;

void setup()
{
    size(1600, 900, OPENGL);
    smooth();
    initialize();
}

void initialize()
{
    clearScene();
    _randomSeed = 61776; //(int)random(65536);
    _noiseSeed = 62261; // (int)random(65536);
    println("randomSeed: " + _randomSeed);
    println("noiseSeed: " + _noiseSeed);
    randomSeed(_randomSeed);
    noiseSeed(_noiseSeed);

    _ico = new Icosphere(110);
    _ico.icosahedron();
    for (int i = 0; i < 2; i++) { _ico.split(); }
    _ico.prepareTriangularPrisms(200);

    _subIcoList = new ArrayList<Icosphere>();
    for (int i = 0; i < 3000; i++)
    {
        float r = sqrt(random(1))*width/2;
        float theta = random(TAU);
        PVector center = new PVector(r*cos(theta), r*sin(theta), random(-1, 1)*600).add(width/2, height/2);
        Icosphere subIco = new Icosphere(center, 5+pow(random(1), 3)*10);
        subIco.icosahedron();
        int subdivision = (int)(pow(random(1), 3)*2);
        for (int j = 0; j < subdivision; j++) { subIco.split(); }
        _subIcoList.add(subIco);
    }
}

void draw()
{
    clearScene();
    ambientLight(32, 32, 32);
    lightSpecular(255, 255, 255);
    pointLight(255, 255, 255, _ico._center.x, _ico._center.y, _ico._center.z);
    _ico.drawTriangularPrisms();

    for (Icosphere subIco : _subIcoList) { subIco.drawMe(); }
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

void clearScene() { background(#000000); }

void saveImage() { saveFrame(timestamp() + ".png"); }

void myVertex(PVector v)
{
    vertex(v.x, v.y, v.z);
}

void myTranslate(PVector v)
{
    translate(v.x, v.y, v.z);
}