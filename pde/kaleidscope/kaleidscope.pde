void setup()
{
  size(1600, 900);
  background(255);
  smooth();
  noLoop();
}

void draw()
{
  pushMatrix();
  translate(width/2, height/2);
  kaleidscope(50, 8, 12);
  popMatrix();
}

void kaleidscope(float r, int num, int iterations)
{
  pushMatrix();
  for (int i = 0; i < num; i++)
  {
    object(r, 20);
    rotate(TWO_PI/(float)num);
  }
  popMatrix();
}

void object(float init_r, int num)
{
  float r = init_r;
  noFill();
  stroke(0);
  strokeWeight(1);
  pushMatrix();
  translate(2.0*r, 0);
  for (int i = 0; i < num; i++)
  {
    ellipse(0, 0, 2.0*r, 2.0*r);
    translate(r, 0);
    r += 10;
    translate(r, 0);
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
