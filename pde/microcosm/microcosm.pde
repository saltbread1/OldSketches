void setup()
{
  size(1600, 900);
  background(0);
  smooth();
  noLoop();
}

void draw()
{
  int num = 6;
  for (int i = 0; i < num; i++)
  {
    float rot = TWO_PI/5.0*(float)i;
    triangles(width/2, height/2, rot, 30+20*i, 60, 3, 9);
  }
}

void triangles(float x, float y, float rot, float r, float angle, int init_num, int maxiterations)
{
  pushMatrix();
  translate(x, y);
  rotate(rot);
  float num = init_num;
  for (int j = 0; j < maxiterations; j++)
  {
    float dis = 0;
    for (int i = 0; i < num; i++)
    {
      float rad1 = TWO_PI/(float)num*(float)i;
      float rad2 = TWO_PI/(float)num*(float)(i+1);
      float edge = dist(r*cos(rad2), r*sin(rad2), r*cos(rad1), r*sin(rad1));
      stroke(255);
      strokeWeight(1);
      noFill();
      float[] pos = isoscelesTriangle(r*cos(rad2), r*sin(rad2), r*cos(rad1), r*sin(rad1), angle);
      dis = dist(0, 0, pos[0], pos[1]);
      line(r*cos(rad1), r*sin(rad1), dis*cos(rad1), dis*sin(rad1));
      noStroke();
      fill(255);
      ellipse(r*cos(rad1), r*sin(rad1), 0.3*edge, 0.3*edge);
      fill(0);
      ellipse(r*cos(rad1), r*sin(rad1), 0.2*edge, 0.2*edge);
      fill(255);
      ellipse(r*cos(rad1), r*sin(rad1), 0.1*edge, 0.1*edge);
    }
    num *= 2;
    r = dis;
  }
  popMatrix();
}

float[] isoscelesTriangle(float x1, float y1, float x2, float y2, float b_angle)
{
  float rad = radians(b_angle);
  float a = 1.0/(2.0*cos(rad));
  float x3 = x1+a*(cos(rad)*(x2-x1)-sin(rad)*(y2-y1));
  float y3 = y1+a*(sin(rad)*(x2-x1)+cos(rad)*(y2-y1));
  triangle(x1, y1, x2, y2, x3, y3);
  float[] pos3 = {x3, y3};
  return pos3;
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
}
