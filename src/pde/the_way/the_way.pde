import processing.opengl.*;

void setup()
{
  size(1600, 900, OPENGL);
  background(0);
  smooth();
  noLoop();
  colorMode(HSB, 255);
}

void draw()
{
  int num = 10;
  background(0);
  
  spiral(width/2, 0, height, 0, 200, height*1.2, 4, 30, 60, 10);
  for (int i = 0; i < 3; i++)
  {
    spiral(width/2, 0, height, TWO_PI/3.0*i, 500, height*1.2, 0.8, 60, 230, 150);
  }
  
  for (int i = -num; i <= num; i++)
  {
    chained_box(width/2, height*(0.5+1.0/num*i), 0, 50, 10);
  }
  
  save("image.png");
}

void spiral(float cen_x, float cen_z, float init_y, float init_rad, float r, float h, float cycle, int dnum, float hue0, float hue1)
{
  int num = round(dnum*cycle);
  float drad = TWO_PI/dnum;
  float dh = h/num;
  pushMatrix();
  translate(cen_x, init_y, cen_z);
  for (int i = 0; i < num; i++)
  {
    pushMatrix();
    translate(0, -dh*i, 0);
    rotateY(drad*i + init_rad);
    translate(r, 0, 0);
    
    stroke(255);
    strokeWeight(1);
    stroke(map(i, 0, num, hue0, hue1), 255, 255);
    fill(0);
    
    box(80, 5, 30);
    popMatrix();
  }
  popMatrix();
}

void chained_box(float init_x, float init_y, float init_z, float edge, int num)
{
  float diagonal = edge*sqrt(3.0);
  pushMatrix();
  translate(init_x, init_y, init_z);
  rotateX(random(TWO_PI));
  rotateY(random(TWO_PI));
  rotateZ(random(TWO_PI));
  for (int i = 0; i < num; i++)
  {
    int rot = (int)random(100)%7;
    stroke(255);
    strokeWeight(1);
    noFill();
    box2(edge);
    switch (rot)
    {
      case 0:
        rotateY(0);
        break;
      case 1:
        rotateY(2.0*atan2(1.0, sqrt(2.0)));
        break;
      case 2:
        rotateY(-2.0*atan2(sqrt(2.0), 1.0));
        break;
      case 3: 
        rotateY(-atan2(sqrt(2.0), 1.0));
        rotateZ(-atan2(sqrt(2.0), 1.0));
        break;
      case 4:
        rotateY(-atan2(sqrt(2.0), 1.0));
        rotateZ(-atan2(sqrt(2.0), 1.0));
        rotateZ(-2.0*atan2(1.0, sqrt(2.0)));
        break;
      case 5:
        rotateY(-atan2(sqrt(2.0), 1.0));
        rotateZ(atan2(sqrt(2.0), 1.0));
        break;
      case 6:
        rotateY(-atan2(sqrt(2.0), 1.0));
        rotateZ(atan2(sqrt(2.0), 1.0));
        rotateZ(2.0*atan2(1.0, sqrt(2.0)));
        break;
    }
    if (i != num-1)
    {
      line(diagonal*0.5, 0, diagonal*3.5, 0);
      stroke(random(255), 255, 255);
      line2(diagonal*1.5, 0, diagonal*2.5, 0, 10, 6);
      translate(diagonal*2.0, 0, 0);
      translate(diagonal*2.0, 0, 0);
      rotateX(random(TWO_PI));
    }
  }
  popMatrix();
}

void box2(float edge)
{
  pushMatrix();
  rotateY(atan2(1.0, sqrt(2.0)));
  rotateZ(PI/4.0);
  box(edge);
  popMatrix();
}

void line2(float x0, float y0, float x1, float y1, float r, int num)
{
  float d = dist(x0, y0, x1, y1)/(float)num;
  pushMatrix();
  translate(x0, y0, 0);
  rotateZ(atan2(y1-y0, x1-x0));
  rotateY(HALF_PI);
  translate(0, 0, d/2);
  for (int i = 0; i < num; i++)
  {
    ellipse(0, 0, 2.0*r, 2.0*r);
    translate(0, 0, d);
  }
  popMatrix();
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
