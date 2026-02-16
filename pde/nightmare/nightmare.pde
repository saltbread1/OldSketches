void setup()
{
  size(1600, 900);
  smooth();
  colorMode(HSB, 360, 100, 100, 100);
  noLoop();
}

void draw()
{
  background(0);
  
  float r_base = 10;
  float d_base = 60;
  pushMatrix();
  translate(width/2, height/2);
  while (r_base < width/1.5)
  {
    noiseSeed((long)random(1000));
    int num = floor(r_base/5.0);
    float theta = random(TWO_PI);
    int hueOffset = floor(random(360));
    for (int i = 0; i < num; i++)
    {
      pushMatrix();
      rotate(theta);
      float r = r_base * (1.0 + 0.5*my_norm(cnoise(theta, 1, 0), 1));
      translate(r, 0);
      float phi_x = 0.9*HALF_PI * my_norm(cnoise(theta, 2, 10), 1.5);
      float phi_y = 0.9*HALF_PI * my_norm(cnoise(theta, 2, 20), 2);
      shearX(phi_x);
      shearY(phi_y);
      float d = d_base * (1.0 + 0.9*my_norm(cnoise(theta, 5, 30), 1));
      my_circle(d, floor(map(i, 0, num, 0, 360)), hueOffset);
      theta += TWO_PI/num;
      popMatrix();
    }
    r_base += 20;
  }
  popMatrix();
}

void my_circle(float d, int c, int hueOffset)
{
  int fill_c = floor(map(sin(c/360.0*6.0*TWO_PI), -1, 1, 0, 360));
  color stroke_c = color((c+hueOffset)%360, floor(random(50, 80)), floor(random(50, 100)));
  fill(fill_c, 80);
  stroke(stroke_c);
  strokeWeight(1);
  circle(0, 0, d);
  int num = floor(d/2.0);
  for (int i = 0; i < num; i++)
  {
    float theta = TWO_PI/num*(i+0.5*random(-1, 1));
    line(0, 0, d/2.0*cos(theta), d/2.0*sin(theta));
  }
  fill(0);
  circle(0, 0, d/2.0);
}

float my_norm(float normValue, float degree)
{
  return map(pow(2.0*normValue, degree), 0, pow(2.0, degree), -1, 1);
}

float cnoise(float theta, float noiseScale, float seed)
{
  return noise(noiseScale*(pow(cos(theta), 3)+1.0), noiseScale*(pow(sin(theta), 3)+2.0), seed+frameCount*0.03);
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
