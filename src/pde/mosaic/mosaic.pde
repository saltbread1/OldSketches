import com.hamoid.*;

VideoExport _videoExport;
boolean _isExport = false;
int _exportingMs = 10000;
int _frameRate = 30;
PGraphics _pg;
PShader _shader;

void setup()
{
    size(800, 450, P2D);
    smooth();
    frameRate(_frameRate);
    initialize();
    if (_isExport) { exportStart(); }
}

void initialize()
{
    clearScene();
    _pg = createGraphics(width, height, P2D);
    _shader = loadShader("triangles.glsl");
}

void draw()
{
    _shader.set("time", millis()*.001);
    _pg.beginDraw();
    _pg.shader(_shader);
    _pg.rect(0, 0, _pg.width, _pg.height);
    _pg.resetShader();
    _pg.endDraw();
    clearScene();
    image(_pg, 0, 0);
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