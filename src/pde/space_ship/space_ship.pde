import processing.opengl.*;

MassBlockes _massBlockes;
MassBlockes _ground;
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
    _randomSeed = (int)random(65536);
    _noiseSeed = (int)random(65536);
    println("randomSeed: " + _randomSeed);
    println("noiseSeed: " + _noiseSeed);
    randomSeed(58995);
    noiseSeed(51788);
    /***********************
        randomSeed: 3081
        noiseSeed: 60888

        randomSeed: 36411
        noiseSeed: 25971

        randomSeed: 58995
        noiseSeed: 51788
    ************************/

    _massBlockes = new MassBlockes(createInitQuad(5500, 5500, 2000));
    _massBlockes.createCeilingBlockes();
    _ground = new MassBlockes(createInitQuad(12000, 5000, 5000));
    _ground.createFloorBlockes();

    camera(width/2, (height/2) / tan(PI*30 / 180), height/2, width/2, 0, height*.4, 0, 0, 1);
}

Quad createInitQuad(float eLenX, float eLenY, float minArea)
{
    PVector v1 = new PVector(0, 0);
    PVector v2 = new PVector(0, eLenY);
    PVector v3 = new PVector(eLenX, eLenY);
    PVector v4 = new PVector(eLenX, 0);
    PVector offset = new PVector(eLenX/2, eLenY/2);
    v1.sub(offset); v2.sub(offset); v3.sub(offset); v4.sub(offset);
    return new Quad(v1, v2, v3, v4, minArea);
}

void draw()
{
    clearScene();

    ambientLight(32, 32, 32);
    lightSpecular(255, 255, 255);
    directionalLight(255, 255, 255, 0, -2, 1);
    specular(#c4dfff);
    shininess(8);

    pushMatrix();
    translate(width/2, height/2);
    translate(0, -3000, -700);
    rotateZ(QUARTER_PI);
    _massBlockes.drawBlockes();
    popMatrix();

    pushMatrix();
    translate(width/2, -height);
    translate(0, 0, height*1.1);
    _ground.drawBlockes();
    popMatrix();
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
