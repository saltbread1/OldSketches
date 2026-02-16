import processing.opengl.*;
import peasy.*;
import com.hamoid.*;
import gifAnimation.*;

PeasyCam _cam;
CameraState _camstate;
// VideoExport _videoExport;
GifMaker _gifExport;
boolean _isExport = false;
int _frameRate = 30;
Sphere _sphere;

void setup()
{
    size(600, 600, OPENGL);
    smooth();
    frameRate(_frameRate);
    //peasySettings();
    initialize();
    clearScene();
    if (_isExport) { exportStart(); }
}

void initialize()
{
    //_cam.setState(_camstate, 1000);
    _sphere = new Sphere(150., 40);
    clearScene();
}

void draw()
{
    clearScene();
    pushMatrix();
    translate(width/2, height/2, 80);
    rotateX(-PI * .1);
    rotateY(-PI * .25);
    _sphere.drawMe(.05, 2);
    popMatrix();
    if (_isExport) { exportFrame(); }
}

void keyPressed()
{
    if (keyCode == 'S') { saveImage(); }
    else if (keyCode == 'R') { initialize(); }
}

String timestamp()
{
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) 
        + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    return timestamp;
}

void clearScene() { background(#222244); }

void saveImage() { saveFrame(timestamp() + ".png"); }

void peasySettings()
{
    _cam = new PeasyCam(this, 400);
    _camstate = _cam.getState();
    _cam.setMinimumDistance(50);
    _cam.setMaximumDistance(1000);
}

void exportStart()
{
    _gifExport = new GifMaker(this, timestamp() + ".gif");
    _gifExport.setRepeat(0);
    _gifExport.setDelay(1000/_frameRate);
}

void exportFrame()
{
    _gifExport.addFrame();
    if (_sphere.inverse && _sphere.isSphere(_sphere.root)) { exportFinish(); }
}

void exportFinish()
{
    _gifExport.finish();
    exit();
}