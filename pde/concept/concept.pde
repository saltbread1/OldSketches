CurpetsGG _gg;

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
    PVector center = new PVector(random(width), random(height));// new PVector(width/2, height/2);
    CurpetsGenerator initGen = new CurpetsGenerator(center, 80, (int)random(3, 10));
    _gg = new CurpetsGG(initGen);
    while (_gg.addCircle());
    _gg.prepareDrawing();
}

void draw()
{
    clearScene();
    _gg.drawMe();
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
