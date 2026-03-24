void setup()
{
  size(1600, 900);
  smooth();
  noLoop();
  background(0);
  rectMode(CENTER);
}

void draw()
{
  background(0, 0, 255);
  
  PImage img = draw_image();
  img = draw_color_glitch(img, 2);
  img = draw_shift_glitch(img, 10);
  image(img, 0, 0);
  
  draw_scanline();
}

PImage draw_image()
{
  background(0, 0, 255);
  noiseSeed((long)random(1000));
  push();
  for (int i = 0; i < 10; i++)
  {
    color c = random(1) < 0.5 ? color(255) : color(255);
    noStroke();
    fill(c);
    drawCurveCircle();
  }
  pop();
  
  PImage img = get();
  clear();
  
  return img;
}

void drawCurveCircle()
{
  int n = (int)random(3, 8);
  float r = random(5, 20);
  int m = (int)map(sq(random(1)), 0, 1, 5, 10);
  pushMatrix();
  translate(random(width), random(height));
  rotate(random(TWO_PI));
  for (int i = 0; i < n; i++)
  {
    rotate(TWO_PI/n);
    noiseSeed((long)random(1000));
    drawCurve(r, 0, r*5, r*5, m, 2, 5000, 0.005);
  }
  popMatrix();
}

void drawCurve(float init_x, float init_y, float init_amp, float stride, float init_rect_size, int n, int iterations, float dt)
{
  float amp_ratio = 0.7;
  float period_ratio = 5;
  float rect_ratio = 0.8;
  float t = 0;
  //float dt = 0.0005;
  float phi = 0;//random(TWO_PI);
  PVector[] cur_pos, pre_pos;
  // reset array
  cur_pos = new PVector[n];
  pre_pos = new PVector[n];
  for (int i = 0; i < pre_pos.length; i++)
  {
    cur_pos[i] = new PVector(0, 0);
    pre_pos[i] = new PVector(100, 100);
  }
  
  for (int i = 0; i < iterations; i++)
  {
    float amp = init_amp;
    float t2 = t+phi;
    float x = stride*t, dx = stride;
    float y, dy = 0;
    float theta = 0;
    float rect_size = init_rect_size;
    amp *= map(sq(noise(t2)), 0, 1, 0.5, 3);
    rect_size *= map(sq(noise(t2)), 0, 1, 0.5, 3);
    pushMatrix();
    translate(init_x, init_y);
    translate(x, 0);
    
    for (int j = 0; j < n; j++)
    {
      y = amp*sin(t2);
      dy = amp*pow(period_ratio, j)*cos(t2);
      // update position
      cur_pos[j].x = j == 0 ? x : cur_pos[j-1].x + y*sin(-theta);
      cur_pos[j].y = j == 0 ? y : cur_pos[j-1].y + y*cos(-theta);
      // sum of rotated radian
      theta += atan2(dy, dx);
      translate(0, y);
      rotate(atan2(dy, dx));
      // draw rect at regular distance
      if (dist(cur_pos[j].x, cur_pos[j].y, pre_pos[j].x, pre_pos[j].y) > rect_size*1.25)
      {
        rect(0, 0, rect_size, rect_size);
        pre_pos[j].x = cur_pos[j].x;
        pre_pos[j].y = cur_pos[j].y;
      }
      amp *= amp_ratio;
      t2 *= period_ratio;
      rect_size *= rect_ratio;
    }
    t += dt;
    popMatrix();
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    saveFrame("####.png");
  }
  else if (keyCode == SHIFT)
  {
    redraw();
  }
}
