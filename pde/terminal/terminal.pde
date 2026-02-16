void setup()
{
  size(1200, 800);
  background(140, 130, 125);
  smooth();
  noLoop();
}

void draw()
{
  pushMatrix();
  translate(width/2, height/2);
  drawLines1();
  drawLines4();
  drawLines2();
  drawCircle();
  popMatrix();
  
  pushMatrix();
  translate(0, height/2);
  rotate(-PI/2);
  drawLines3(height, 70);
  popMatrix();
  
  pushMatrix();
  translate(width, height/2);
  rotate(PI/2);
  drawLines3(height, 70);
  popMatrix();
}

void drawLines1()
{
  int n = 600;
  pushMatrix();
  for (int i = 0; i < n; i++)
  {
    color c = color(random(255), random(255), random(255));
    Line line = new Line(200, width, 1, c, c);
    line.drawMe();
    rotate(2*PI/n);
  }
  popMatrix();
}

void drawLines4()
{
  int n = 50;
  color c2 = color(90, 100, 250);
  color c1 = color(230, 230, 0);
  pushMatrix();
  for (int i = 0; i < n; i++)
  {
    Line line = new Line(50, width/1.5, 30, c1, c2);
    line.drawMe();
    rotate(2*PI/n);
  }
  popMatrix();
}

void drawLines2()
{
  int n = 100;
  color c = color(0);
  pushMatrix();
  for (int i = 0; i < n; i++)
  {
    Line line = new Line(50, width/3, 20, c, c);
    line.drawMe();
    rotate(2*PI/n);
  }
  popMatrix();
}

void drawLines3(float edge, float angle)
{
  int n = 50;
  float alpha = radians(40);
  float theta = radians(angle);
  float phi = (PI-theta)/2-alpha/2;
  float r = edge/(2*sin(theta/2));
  float a = edge/(2*tan(theta/2));
  color c1 = color(50, 30, 30, 100);
  color c2 = color(255, 0, 0, 100);
  pushMatrix();
  translate(0, a);
  for (int i = 0; i < n; i++)
  {
    pushMatrix();
    rotate(-phi);
    translate(r, 0);
    rotate(PI);
    Line line = new Line(50, edge/2, 30, c1, c2);
    line.drawMe();
    popMatrix();
    phi += (theta+alpha)/n;
  }
  popMatrix();
}

void drawCircle()
{
  float maxradius = 70;
  float radius = maxradius;
  float dradius = 1;
  color c1 = color(0);
  color c2 = color(255);
  noStroke();
  while (radius > 0)
  {
    color c = lerpColor(c2, c1, 2*radius/maxradius-1.0);
    fill(c);
    ellipse(0, 0, radius*2.0, radius*2.0);
    radius -= dradius;
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
}
