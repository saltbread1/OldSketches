int _frameRate = 30;
ArcGenerator0 _rg0;
ArrayList<ArcGenerator1> _rg1list;

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
    Arc initArc = new Arc(new PVector(width/2, height/2), 300);
    _rg0 = new ArcGenerator0(initArc);
    _rg1list = new ArrayList<ArcGenerator1>();
    for (int i = 0; i < 100; i++) { _rg1list.add(new ArcGenerator1(initArc)); }
    while (_rg0.addArc());
    for (ArcGenerator1 rg1 : _rg1list) { while (rg1.addArc()); }
}

void draw()
{
    clearScene();
    _rg0.drawArcs();
    for (ArcGenerator1 rg1 : _rg1list) { rg1.drawArcs(); }
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