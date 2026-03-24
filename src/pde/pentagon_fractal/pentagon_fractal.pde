import com.hamoid.*;
import gifAnimation.*;

VideoExport _videoExport;
GifMaker _gifExport;
boolean _isExport = false;
int _periodMs = 10000; // 5000
int _frameRate = 30;
FirstPentagon _generator;
boolean _inverse;

void setup()
{
    size(1200, 1200);
    // size(700, 700);
    smooth();
    frameRate(_frameRate);
    colorMode(HSB, 360, 100, 100);
    clearScene();
    initialize();
    if (_isExport) { exportStart(); }
}

void initialize()
{
    _generator = new FirstPentagon(max(width, height) * .125);
    _inverse = false;
}

void draw()
{
    clearScene();
    //float edgeLen = map(mouseX, 0., width, -10., 160.);
    movingFractalSettings(_periodMs / 2);
    push();
    //stroke(#ffffff);
    fill(#000000);
    fractal(_generator, 8, 0);
    pop();
    if (_isExport) { exportFrame(_periodMs); }
}

void movingFractalSettings(int halfPeriodMs)
{
    int periodFrame = _frameRate * halfPeriodMs / 1000;
    int halfPeriodFrame = periodFrame / 2;
    if (frameCount % halfPeriodFrame <= 0)
    {
        _inverse = !_inverse;
        _generator.setRotationRadians(_generator.rotRad);
    }
    float theta = TAU / periodFrame * frameCount;
    float x = (float)(frameCount % periodFrame) / (float)(halfPeriodFrame);
    float edgeScaleRatio = easing(x < 1. ? x : 2.-x);
    _generator.setEdgeLength(_generator.totalLen * edgeScaleRatio);
}

float easing(float x)
{
    return x < .5 ? 2.*sq(x) : 1.-sq(2.-2.*x)/2.;
}

void fractal(Pentagon penta, int maxiterations, int iteration)
{
    stroke(map(iteration, 0, maxiterations, 120, 240), 80, 70);
    penta.drawMe();
    if (iteration >= maxiterations) { return; }
    for (Pentagon child : penta.createChildren())
    {
        fractal(child, maxiterations, iteration+1);
    }
}

void keyPressed()
{
    if (keyCode == 'S') { saveImage(); }
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
    _gifExport = new GifMaker(this, timestamp() + ".gif");
    _gifExport.setRepeat(0);
    _gifExport.setDelay(1000/_frameRate);
}

void exportFrame(int ms)
{
    _gifExport.addFrame();
    int maxFrames = _frameRate * ms / 1000;
    if (frameCount > maxFrames) { exportFinish(); }
}

void exportFinish()
{
    _gifExport.finish();
    exit();
}