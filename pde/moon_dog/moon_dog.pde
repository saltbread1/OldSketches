Mosaic mosaic;

void setup()
{
  size(1600, 900);
  background(0);
  smooth();
  noiseSeed(31);
  
  for (int i = 0; i < width; i+=5)
  {
    for (int j = 0; j < height; j+=5)
    {
      Curve curve = new Curve(i, j, color(120, 10, 0));
      curve.drawMe();
    }
  }
  
  mosaic = new Mosaic(width*0.5-height*0.3, height*0.5-height*0.3, height*0.6, height*0.6);
}

void draw()
{
  mosaic.drawMosaic();
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
}
