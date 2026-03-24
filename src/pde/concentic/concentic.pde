import com.hamoid.*;
import com.scrtwpns.Mixbox;

VideoExport _videoExport;
boolean _isExport = false;
int _exportingMs = 20000;
int _frameRate = 30;
ConcenticCircles _cc;
int _randomSeed, _noiseSeed;

void setup()
{
    size(800, 450);
    smooth();
    frameRate(_frameRate);
    initialize();
    if (_isExport) { exportStart(); }
}

void initialize()
{
    clearScene();
    _randomSeed = 54330;//(int)random(65536); // 54426, 54330, 19061
    _noiseSeed = 37823;//(int)random(65536); // 17866, 37823, 51640
    randomSeed(_randomSeed);
    noiseSeed(_noiseSeed);
    println("randomSeed: "+_randomSeed);
    println("noiseSeed: "+_noiseSeed);
    _cc = new ConcenticCircles(new PVector(width/2, height/2), width*.8, 20);
}

void draw()
{
    clearScene();
    _cc.drawCircles();
    if (_isExport) { exportFrame(_exportingMs); }
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

void exportStart()
{
    _videoExport = new VideoExport(this, timestamp() + ".mp4");
    _videoExport.startMovie();
}

void exportFrame(int ms)
{
    _videoExport.saveFrame();
    int maxFrames = _frameRate * ms / 1000;
    if (frameCount > maxFrames) { exportFinish(); }
}

void exportFinish()
{
    _videoExport.endMovie();
    exit();
}

class Circle
{
    final float radius;
    final int colourIndex;
    final color defaultColour;
    final color[] palette = {#9e9e9e, #7b7b7b, #bdbdbd, #8d6e63, #616161, #4e342e};//{#153660, #365462, #040510, #435465, #293e32, #726566};
    final int seed = (int)random(65536);
    
    PVector center;
    Circle parent = null, child = null;
    color mixedColour;
    int t = 0;

    Circle(float radius, float maxdradius)
    {
        this.radius = radius;
        colourIndex = (int)random(palette.length);
        defaultColour = palette[colourIndex];
        center = new PVector();
        if (radius > maxdradius) { child = new Circle(this, maxdradius); }
    }

    Circle(Circle parent, float maxdradius)
    {
        this.radius = parent.radius-maxdradius*sq(random(.45, 1));
        colourIndex = (int)random(parent.colourIndex+1, parent.colourIndex+palette.length)%palette.length;
        defaultColour = palette[colourIndex];
        center = new PVector();
        this.parent = parent;
        if (radius > maxdradius) { child = new Circle(this, maxdradius); }
    }

    void updateMe()
    {
        float nVal = constrain((noise(t*.02, seed)*2-1)*1.6, -1, 1);
        float r = parent != null ? nVal*(parent.radius-radius) : nVal*(radius-child.radius);
        float rad = t++*.12 + TAU*seed/65536;
        if (seed%2 == 0) { rad *= -1; }
        center = PVector.fromAngle(rad).mult(r);
        if (child == null) { return; }
        if (PVector.dist(center, child.center) > radius-child.radius) // overlap
        {
            PVector dir = PVector.sub(child.center, center);
            dir.mult(1-(radius-child.radius)/dir.mag());
            center.add(dir);
        }
    }

    void drawMe()
    {
        pushStyle();
        float r = constrain((noise(t*.005, seed)*2-.4), 0, 1);
        mixedColour = parent == null ? defaultColour : color(Mixbox.lerp(defaultColour, parent.mixedColour, r));
        stroke(#000000);
        fill(mixedColour);
        circle(center.x, center.y, radius*2);
        popStyle();
    }
}

class ConcenticCircles
{
    final PVector center;
    Circle circle;

    ConcenticCircles(PVector center, float radius, float maxdradius)
    {
        this.center = center;
        circle = new Circle(radius, maxdradius);
        while (circle.child != null) { circle = circle.child; }
    }

    void drawCircles()
    {
        while (circle.parent != null)
        {
            circle.updateMe();
            circle = circle.parent;
        }
        circle.updateMe();
        pushMatrix();
        translate(center.x, center.y);
        while (circle.child != null)
        {
            circle.drawMe();
            int maxiterations = (int)max(circle.radius*.03, 1);
            drawRevolutionalCircles(maxiterations);
            circle = circle.child;
        }
        circle.drawMe();
        popMatrix();
    }

    void drawRevolutionalCircles(int maxiterations)
    {
        float rad = circle.t/sqrt(circle.radius)*.5 + TAU*(1-circle.seed/65536.);
        rad += sq(sin(rad*2 + TAU*circle.seed/65536))*.4;
        if (circle.seed%2 != 0) { rad *= -1; }
        for (int i = 0; i < maxiterations; i++)
        {
            drawRevolutionalCircle(rad);
            rad += TAU/maxiterations;
        }
    }

    void drawRevolutionalCircle(float rad)
    {
        pushStyle();
        PVector sub = PVector.sub(circle.child.center, circle.center);
        PVector dir = PVector.fromAngle(rad);
        float a = -PVector.dot(sub, dir);
        float b = sqrt(sq(a)-sub.magSq()+sq(circle.radius));
        float k = a+b > 0 ? a+b : a-b;
        float newr = (k-circle.child.radius)/2;
        PVector newc = dir.mult(circle.child.radius+newr).add(sub).add(circle.center);
        stroke(#cdcdcd);
        fill(#000000);
        circle(newc.x, newc.y, newr*2);
        popStyle();
    }
}