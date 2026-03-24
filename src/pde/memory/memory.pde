void setup()
{
  size(1600, 900);
  background(0);
  smooth();
  noLoop();
  colorMode(HSB, 255);
  noiseSeed(72245);
  randomSeed(1526);
}

void draw()
{
  pushMatrix();
  translate(width/2, height/2);
  Circles_Bg circ_bg = new Circles_Bg(16);
  circ_bg.drawMe(960);
  Circles circ = new Circles(5, 160, 400);
  circ.drawMe(1.0, 2, 0);
  popMatrix();
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
}
