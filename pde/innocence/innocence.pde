CurveManager _cm;

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
    _cm = new CurveManager(160, 40, 2.5);
    _cm.createCurves();
}

void draw()
{
    clearScene();
    _cm.rendering();
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

void saveImage() { saveFrame(timestamp() + ".png"); }