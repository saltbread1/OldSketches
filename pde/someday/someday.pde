void setup()
{
  size(1200, 800);
  background(255);
  noLoop();
}

void draw()
{
  background(0);
  drawFractal(width/2, height/2, height/5, 5, -HALF_PI, 0.99, 0, 6);
}

void drawFractal(float x, float y, float r, int num, float rad, float a, int iterations, int maxiterations)
{
  if (iterations < maxiterations)
  {
    drawCircle(x, y, r, color(map(iterations, 0, maxiterations, 50, 255), 30, map(iterations, 0, maxiterations, 0, 200)));
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

void drawCircle(float fcen_x, float fcen_y, float fr, color c)
{
  int x = (int)round(fcen_x-fr);
  int y = (int)round(fcen_y-fr);
  int r = (int)round(fr);
  loadPixels();
  for (int i = x; i < x+2*r; i++)
  {
    for (int j = y; j < y+2*r; j++)
    {
      if (dist(i,j,x+r,y+r) < r)
      {
        if (i >= 0 && i < width && j >= 0 && j < height)
        {
          if (pixels[i+width*j] == color(0))
          {
            pixels[i+width*j] = color(c);
          }
          else
          {
            pixels[i+width*j] = color((red(pixels[i+width*j])+red(c))%255, green(c), (blue(pixels[i+width*j])+blue(c))%255);
          }
        }
      }
    }
  }
  updatePixels();
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
}
