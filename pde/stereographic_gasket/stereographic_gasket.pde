import com.hamoid.*;
import gifAnimation.*;
import quaternion.*;

VideoExport _videoExport;
GifMaker _gifExport;
boolean _isExport = false;
int _periodMs = 20000; // 15000
int _frameRate = 30;
Icosphere _ico;
PVector _dir;
float _dtheta;

void setup()
{
    size(1600, 900);
    // size(800, 450);
    smooth();
    frameRate(_frameRate);
    clearScene();
    initialize();
    if (_isExport) { exportStart(); }
}

void initialize()
{
    _ico = new Icosphere(width *.125, 5);
    _dir = new PVector(0., 2, 1.);
    _dtheta = TAU / (_frameRate * _periodMs) * 1000;
}

void draw()
{
    clearScene();
    _ico.rotate(_dir, _dtheta);
    _ico.drawProjection();
    if (_isExport) { exportFrame(_periodMs); }
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