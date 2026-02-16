float _ratio = 2.4;

void setup()
{
  size(3840, 2160);
  background(255);
  smooth();
  noLoop();
  colorMode(HSB, 255);
}

void draw()
{
  Circle circle1, circle2;
  ArcLine line;
  circle1 = new Circle(0, 0, 0, 0, 0);
  circle2 = new Circle(width/2, -height*0.3, height*0.8, 0, PI);
  background(0);
  
  for (int i = 0; i < 2000; i++)
  {
    float x, y, min_r;
    x = random(width); y = random(height);
    min_r = max(randomGaussian()*5.0*_ratio, 2.0*_ratio);
    line = new ArcLine(x, y, min_r, 5.0*min_r, (int)(random(10, 30)*_ratio), circle1, color(255));
    line.drawArcsAndCircles(color(random(255), 200, 125), max(min_r/5.0, 1.0*_ratio));
  }
  
  for (int i = 0; i < 2000; i++)
  {
    float x, y, min_r, rand;
    x = random(width); y = random(height);
    if (y < circle2.y+sqrt(pow(circle2.r,2.0)-pow(x-circle2.x,2.0)))
    {
      continue;
    }
    rand = random(100);
    if (rand > 8.0 || i < 1500)
    {
      min_r = max(randomGaussian()*5.0*_ratio, 2.0*_ratio);
      line = new ArcLine(x, y, min_r, 5.0*min_r, (int)(random(10, 30)*_ratio), circle2, color(0));
      line.drawArcsAndCircles(color(random(255), 250, 200), max(min_r/5.0, 1.0*_ratio));
    }
    else
    {
      color col1, col2;
      min_r = max(abs(randomGaussian())*20.0*_ratio, 5.0*_ratio);
      if (rand < 4.0)
      {
        col1 = color(255);
        col2 = color(0);
      }
      else
      {
        col1 = color(0);
        col2 = color(255);
      }
      line = new ArcLine(x, y, min_r, 5.0*min_r, (int)(random(10, 30)*_ratio), circle2, color(0));
      line.drawArcs(col1, min_r);
      line.drawArcs(col2, min_r/2.0);
    }
  }
  
  // save images
  /*if (frameCount <= 100)
  {
    saveFrame("image2/####.png");
  }
  else
  {
    exit();
  }*/
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.png");
  }
}
