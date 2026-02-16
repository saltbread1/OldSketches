int _frameRate = 30;
PImage _img;

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
    int seed = 38429;//(int)random(65536); // 34325, 38429
    println(seed);
    _img = noiseField(width, height, 90, seed);
}

void draw()
{
    clearScene();
    image(_img, 0, 0);
    println("drawed");
}

PImage noiseField(int w, int h, int hueOffset, int seed)
{
    PImage img = createImage(w, h, RGB);
    push();
    colorMode(HSB, 360, 100, 100);
    noiseSeed(seed);
    img.loadPixels();
    for (int i = 0; i < img.width; i++)
    {
        for (int j = 0; j < img.height; j++)
        {
            int[] offset = {i, i+j, j, i-j+width};
            float nValS = noise(i*.01, j*.01);
            int index = (int)(nValS*offset.length*4)%offset.length;
            int a = offset[index];
            float nValB = 0;
            for (int k = 1; k <= 32; k++)
            {
                float c = sqrt(k);
                nValS = noise(floor(a/c)*.1, noise(nValS*c)*c*4);
                nValB += nValS;
            }
            nValB /= 32;
            int nSat = (int)constrain((nValS*2-.2)*80, 0, 100);
            int nBri = (int)constrain(map(sq(nValB), 0, 1, -50, 350), 0, 80);
            int nHue = ((int)(hueOffset + (nValS-nValB)*500))%360;
            nHue = nHue < 0 ? nHue+360 : nHue;
            color c = color(nHue, nSat, nBri);
            img.pixels[i+j*img.width] = color(red(c), green(c), blue(c));
        }
    }
    img.updatePixels();
    pop();
    return img;
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