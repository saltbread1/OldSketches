PImage _bg;

void setup()
{
    size(1600, 900);
    smooth();
    noLoop();
    _bg = createBackground(width, height, -45, 46033); // seed: 7560, 41928, 46033, 50910, 54125
}

void draw()
{
    clearScene();
    image(_bg, 0, 0);
    glitchEffect(200);
}

PImage createBackground(int w, int h, int hueOffset, long seed)
{
    PImage img = createImage(w, h, HSB);
    push();
    colorMode(HSB, 360, 100, 100);
    noiseSeed(seed);
    img.loadPixels();
    for (int i = 0; i < img.width; i++)
    {
        for (int j = 0; j < img.height; j++)
        {
            int x = round(noise(i*.01, j*.005)*10000);
            int y = round(noise(j*.005, i*.01)*10000);
            float d = sqrt(sq(i-width/2) + sq(j-height/2));
            float nValB = noise((x&y|x+y)*.01) + d*.001;
            float nValS = noise(((x|y)&x+y)*.005) + d*.0002;
            int nHue = ((int)(hueOffset + (nValS-nValB)*500))%360;
            nHue = nHue < 0 ? nHue+360 : nHue;
            int nSat = (int)constrain((nValS*2-.2)*80, 0, 100);
            int nBri = (int)constrain(map(sq(nValB), 0, 1, -20, 200), 0, 100);
            color c = color(nHue, nSat, nBri);
            img.pixels[i+j*img.width] = color(red(c), green(c), blue(c));
        }
    }
    img.updatePixels();
    pop();
    return img;
}

void glitchEffect(int maxiterations)
{
    for (int i = 0; i < maxiterations; i++)
    {
        int x = (int)random(width);
        int y = (int)random(height);
        int w = (int)constrain(50 + randomGaussian()*50, 10, 100);
        int h = (int)constrain(50 + randomGaussian()*50, 10, 100);
        imageShift(x, y, w, h, (int)random(4, 12), (int)random(4, 8));
    }
}

void imageShift(int x, int y, int w, int h, int shiftTimes, int shiftOffset)
{
    PImage img = createImage(width, height, RGB);
    loadPixels();
    img.pixels = pixels;
    img.updatePixels();
    img = img.get(x, y, w, h);
    PVector dir = PVector.fromAngle(QUARTER_PI*(int)random(8));
    for (int i = 1; i <= shiftTimes; i++)
    {
        PVector v = PVector.mult(dir, i*shiftOffset);
        image(img, x+(int)(v.x), y+(int)(v.y), img.width, img.height);
    }
}

void keyPressed()
{
    if (keyCode == 'S') { saveImage(); }
    else if (keyCode == 'R') { redraw(); }
}

String timestamp()
{
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) 
        + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    return timestamp;
}

void clearScene() { background(#222244); }

void saveImage() { saveFrame(timestamp() + ".png"); }