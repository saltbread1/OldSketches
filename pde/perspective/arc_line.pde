class ArcLine
{
  float init_x, init_y, min_r, max_r;
  int maxiterations;
  color circleC;
  ArrayList<Circle> circles = new ArrayList<Circle>();
  
  ArcLine(float init_x, float init_y, float min_r, float max_r, int maxiterations, Circle field_limit, color circleC)
  {
    this.init_x = init_x;
    this.init_y = init_y;
    this.min_r = min_r;
    this.max_r = max_r;
    this.maxiterations = maxiterations;
    this.circleC = circleC;
    circles.add(field_limit);
    
    // create circle objects
    createCircles(init_x, init_y, random(min_r, max_r), random(TWO_PI), random(-1, 1), maxiterations);
    circles.remove(0);
  }
  
  void drawArcsAndCircles(color c, float w)
  {
    for (int i = 0; i < circles.size(); i++)
    {
      Circle get_circle = circles.get(i);
      float rand = random(100);
      if (rand < 80) // draw arc
      {
        get_circle.drawArc(c, w);
      }
      else // draw circle
      {
        get_circle.drawCircle(c, color(brightness(c), 170), color(brightness(c)*1.1), circleC, w);
      }
    }
  }
  
  void drawArcs(color c, float w)
  {
    for (int i = 1; i < circles.size(); i++)
    {
      Circle get_circle = circles.get(i);
      // draw arc
      get_circle.drawArc(c, w);
    }
  }
  
  void createCircles(float x, float y, float r, float rad, float rot_dir, int iterations)
  {
    if (iterations > 0)
    {
      float next_x, next_y, next_r, next_rad, rad1, rad2, next_rot_dir;
      // initialize
      next_x = next_y = 0;
      next_r = 0;
      next_rad = 0; rad1 = rad; rad2 = 0;
      next_rot_dir = 0;
      
      // calculate new circle info
      for (int i = 1; i < 1000; i++)
      {
        next_rad = random(TWO_PI);
        next_r = random(min_r, max_r);
        next_x = x+(r+next_r)*cos(next_rad);
        next_y = y+(r+next_r)*sin(next_rad);
        // circle overlap check
        if (check(next_x, next_y, next_r))
        {
          break;
        }
        if (i >= 999)
        {
          return;
        }
      }
      
      // determine radians
      rad2 = next_rad;
      if (rot_dir >= 0) // left rotation
      {
        if (rad1 > rad2)
        {
          rad2 += TWO_PI;
        }
        next_rot_dir = -1;
      }
      else // right rotation
      {
        float cash = rad2;
        rad2 = rad1;
        rad1 = cash;
        if (rad1 > rad2)
        {
          rad2 += TWO_PI;
        }
        next_rot_dir = 1;
      }
      // create circle
      Circle new_circle = new Circle(x, y, r, rad1, rad2);
      circles.add(new_circle);
      
      // continue
      if (next_rad <= PI)
      {
        next_rad = next_rad+PI;
      }
      else
      {
        next_rad = next_rad-PI;
      }
      createCircles(next_x, next_y, next_r, next_rad, next_rot_dir, iterations-1);
    }
  }
  
  boolean check(float x, float y, float r)
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
}
