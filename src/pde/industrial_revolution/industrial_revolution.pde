void setup()
{
  size(2000, 1000);
  background(255);
  smooth();
  noLoop();
  colorMode(HSB, 255);
}

void draw()
{
  float r = 10.0;
  background(0);
  
  for (int i = 0; i < 800; i++)
  {
    float a = width/1.3;
    float x = random(-width/2, width/2);
    float dy = a-sqrt(a*a-x*x);
    int num = 10*(15+round(randomGaussian()*8));
    pushMatrix();
    translate(width/2, height/2);
    pushMatrix();
    translate(x, height/2+r+dy);
    if (i%2 == 0) drawLine(0, 0, r, num*5, 0.005, 0.1, random(1000));
    else drawLine(0, 0, r, num, 0.05, 0.5, random(1000));
    popMatrix();
    pushMatrix();
    rotate(PI);
    translate(x, height/2+r+dy);
    if (i%2 == 0) drawLine(0, 0, r, num*5, 0.005, 0.1, random(1000));
    else drawLine(0, 0, r, num, 0.05, 0.5, random(1000));
    popMatrix();
    popMatrix();
    
    if (i%20 == 0)
    {
      color c_stroke, c_fill;
      if ((i/20)%2 == 0)
      {
        c_stroke = color(0);
        c_fill = color(255);
      }
      else
      {
        c_stroke = color(255);
        c_fill = color(0);
      }
      drawLine2(random(width), random(height), 50, 500, 10, c_stroke, c_fill);
    }
  }
}

void drawLine(float init_x, float init_y, float init_r, int num, float noiseScale, float sizeScale, float seed)
{
  noStroke();
  fill(0);
  for (int j = 0; j < 2; j++)
  {
    float x = init_x, y = init_y;
    for (int i = 0; i < num; i++)
    {
      //if (j == 1) fill(map(i, 0, num, 100, 255), 200, 150);
      if (j == 1) fill(map(i, 0, num, 210, 40), 200, 150);
      float r = map(i, 0, num, init_r, 1);
      float rad = map(noise(i*noiseScale, seed), 0, 1, PI-HALF_PI, TWO_PI+HALF_PI);
      ellipse(x, y, 2.0*(r-2*j), 2.0*(r-2*j));
      x += sizeScale*r*cos(rad);
      y += sizeScale*r*sin(rad);
    }
  }
}

void drawLine2(float init_x, float init_y, float max_r, float max_l, int num, color c_stroke, color c_fill)
{
  float strokeW = 15+randomGaussian()*8;
  float init_rad = random(TWO_PI);
  float[][] rad = new float[num+1][2];
  float[] a = new float[num+1];
  for (int i = 0; i <= num; i++)
  {
    rad[i][0] = HALF_PI*(1-2*((int)random(100)%2));
    rad[i][1] = random(-rad[i][0], 0);//-rad0*((int)random(100)%2);
    a[i] = random(0.3, 1);
  }
  for (int j = 0; j < 2; j++)
  {
    if (j == 0)
    {
      stroke(c_stroke);
      strokeWeight(max(strokeW, 5));
    }
    else
    {
      stroke(c_fill);
      strokeWeight(max(strokeW/2, 2.5));
    }
    pushMatrix();
    translate(init_x, init_y);
    rotate(init_rad);
    for (int i = 0; i <= num; i++)
    {
      float r = max_r*a[i];
      float l = max_l*a[i];
      if (i != 0)
      {
        line(0, 0, l, 0);
        fill(c_stroke);
        ellipse(l/2.0, 0, 2.5*strokeW, 2.5*strokeW);
        translate(l, 0);
      }
      noFill();
      arc(0, -r*sin(rad[i][0]), 2.0*r, 2.0*r, min(rad[i][0], rad[i][1]), max(rad[i][0], rad[i][1]), OPEN);
      translate(r*cos(rad[i][1]), -r*sin(rad[i][0])+r*sin(rad[i][1]));
      rotate(rad[i][1]-rad[i][0]);
    }
    popMatrix();
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.png");
  }
  else if (keyCode == SHIFT)
  {
    redraw();
  }
}
