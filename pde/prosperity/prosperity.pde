void setup()
{
  size(1600, 1600);
  background(0);
  noLoop();
  smooth();
  blendMode(DIFFERENCE);
}

void draw()
{
  background(0);
  noStroke();
  fill(255);
  drawFractal(width/2, height/2, width/6, 5, -HALF_PI, 0.5, 0, 7);
}

void drawFractal(float x, float y, float r, int num, float rad, float a, int iterations, int maxiterations)
{
  if (iterations < maxiterations)
  {
    //drawCircle(x, y, r);
    ellipse(x, y, 2.0*r, 2.0*r);
    if (iterations == 0)
    {
      for (int i = 0; i < num; i++)
      {
        float theta = rad+TWO_PI/num*i;
        drawFractal(x+(1.0+a)*r*cos(theta), y+(1.0+a)*r*sin(theta), a*r, num, theta, a, iterations+1, maxiterations);
      }
    }
    else
    {
      for (int i = 1; i < num; i++)
      {
        float theta = rad+PI+TWO_PI/num*i;
        drawFractal(x+(1.0+a)*r*cos(theta), y+(1.0+a)*r*sin(theta), a*r, num, theta, a, iterations+1, maxiterations);
      }
    }
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.png");
  }
}
