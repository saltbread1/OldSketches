import com.hamoid.*;

VideoExport _videoExport;
boolean _isExport = false;
int _exportingMs = 20000;
int _frameRate = 30;

void setup()
{
    size(512, 512);
    noSmooth();
    frameRate(_frameRate);
    if (_isExport) { exportStart(); }
}

void draw()
{
    int t = frameCount*2;
    PImage img = createImage(width/2, height/2, RGB);
    for (int i = 0; i < img.width; i++)
    {
        for (int j = 0; j < img.height; j++)
        {
            int x = i+t, y = j-t;
            int k = (x+y^x-y)*2, l = (x+y^-x+y)*3;
            img.pixels[i+j*img.width] = (k+l^k-l)%15 == 0 ? #ffffff : #0000ff;
        }
    }
    image(img, 0, 0, width, height);
    if (_isExport) { exportFrame(_exportingMs); }
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