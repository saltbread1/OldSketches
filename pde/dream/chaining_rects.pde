void createChainCircles(float x, float y, float r, int iterations)
{
  if (iterations > 0)
  {
    // create circle
    Circle new_circle = new Circle(x, y, r);
    circles.add(new_circle);
    
    // next circle
    float next_x, next_y, next_r, next_rad;
    // initialize
    next_x = next_y = 0;
    next_r = 0;
    next_rad = 0;
    // calculate new circle info
    int cnt = 1000;
    for (int i = 1; i < cnt; i++)
    {
      next_rad = random(TWO_PI);
      next_r = random(min_r, max_r);//constrain(pow(random(1), 2)*max_r, min_r, max_r);
      next_x = x+(r+next_r)*cos(next_rad);
      next_y = y+(r+next_r)*sin(next_rad);
      // circle overlap check
      if (overlapCheck(next_x, next_y, next_r) && edgeCheck(next_x, next_y, next_r))
      {
        break;
      }
      if (i >= cnt-1)
      {
        return;
      }
    }
    createChainCircles(next_x, next_y, next_r, iterations-1);
  }
}

boolean overlapCheck(float x, float y, float r)
{
  for (int i = 0; i < circles.size(); i++)
  {
    Circle circ = circles.get(i);
    float dis = dist(x, y, circ.x, circ.y);
    if (dis <= r+circ.r)
    {
      return false;
    }
  }
  return true;
}

boolean edgeCheck(float x, float y, float r)
{
  if (x-r > 0 && x+r < width && y-r > 0 && y+r < height)
  {
    return true;
  }
  return false;
}

class Circle
{
  float x, y, r;
  Circle(float x, float y, float r)
  {
    this.x = x; this.y = y;
    this.r = r;
  }
  
  void drawSquare()
  {
    noStroke();
    fill(0);
    rect(x-r, y-r, 2.0*r, 2.0*r);
  }
}
