import gifAnimation.*;
GifMaker gifExport;

int frameRate = 30;
int cycletime = 8;
Spiral spiral;

void setup()
{
  size(1600, 900);
  background(0);
  frameRate(frameRate);
  noiseSeed(123); //123 4856
  spiral = new Spiral(350, 50, 10, color(255, 0, 0), color(40, 0, 0));
  
  /*gifExport = new GifMaker(this, "export.gif");
  gifExport.setRepeat(0);
  gifExport.setQuality(10);
  gifExport.setDelay(1000/frameRate);*/
}

void draw()
{
  background(0);
  
  pushMatrix();
  translate(width*0.5, height*0.5);
  float val = frameCount/(float)(cycletime*frameRate)*TWO_PI;
  scale(1.5*noise(0.5*(cos(val)+1.0), 0.5*(sin(val)+1.0)));
  spiral.drawMe();
  popMatrix();
  
  // save gif
  /*if(frameCount < frameRate*cycletime)
  {
    gifExport.addFrame();
  }
  else
  {
    gifExport.finish();
    println("saved this work");
  }*/
}
