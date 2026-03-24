import Complex.*;

void setup()
{
  size(2000, 2000);
  background(0);
  smooth();
  noLoop();
}

void draw()
{
  Julia_Sin juliasin = new Julia_Sin(-0.477522097, -0.904778709, 0, 0, width, height);
  juliasin.drawFractal();
  println("drawing has completed");
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
}
