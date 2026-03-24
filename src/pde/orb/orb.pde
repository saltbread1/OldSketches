void setup()
{
  size(1200, 1200);
  background(0);
  smooth();
  noLoop();
  colorMode(HSB, 255);
}

void draw()
{
  rose2(width/2, height/2, 1000, 1000.0/90.0, 20, 101, 50000);
  rose(width/2, height/2, 250, 250.0/30.0, 20, 101, 50000);
}

void rose(float x, float y, float a, float r, int n, int d, int num)
{
  pushMatrix();
  translate(x, y);
  noStroke();
  fill(255);
  ellipse(0, 0, 2.0*a, 2.0*a);
  for (int i = 0; i < num; i++)
  {
    float theta = (float)d*TWO_PI*(float)i/(float)num;
    float dis = a*sin(theta*((float)n/(float)d));
    fill(color(map(theta, 0, (float)d*TWO_PI, 0, 255), 255, 255, map(i, 0, num-1, 130, 5)));
    ellipse(dis*cos(theta), dis*sin(theta), r, r);
  }
  popMatrix();
}

void rose2(float x, float y, float a, float r, int n, int d, int num)
{
  pushMatrix();
  translate(x, y);
  noStroke();
  for (int i = 0; i < num; i++)
  {
    float theta = (float)d*TWO_PI*(float)i/(float)num;
    float dis = a*sin(theta*((float)n/(float)d));
    fill(color(map(theta, 0, (float)d*TWO_PI, 0, 255), 255, 200, 80));
    ellipse(dis*cos(theta), dis*sin(theta), r, r);
  }
  popMatrix();
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
}
