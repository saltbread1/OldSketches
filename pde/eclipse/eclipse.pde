void setup()
{
  size(1600, 900);
  background(0);
  smooth();
  noLoop();
  colorMode(HSB, 360, 255, 255, 255);
}

void draw()
{
  drawBackground(350, 350, 80, 1.0, 2.5, 0.05);
  
  float r = 100;
  noStroke();
  fill(0);
  ellipse(width/2, height/2, 2.0*r, 2.0*r);
  drawCircTanLines(width/2, height/2, r, width, 1000);
}

void drawBackground(int numx, int numy, float leng, float cycle, float index, float noiseScale)
{
  for (int i = 0; i < numx; i++)
  {
    float dx = (float)width/(float)(numx-1);
    float x = dx*(i);
    for (int j = 0; j < numy; j++)
    {
      float dy = (float)height/(float)(numy-1);
      float y = dy*(j);
      float rad = map(noise(i*noiseScale, j*noiseScale), 0, 1, 0, cycle*TWO_PI);
      float colorVal = map(pow(abs((float)j-(float)numy/2.0), index), 0, pow((float)numy/2.0, index), 0, 170);
      stroke(270, colorVal, colorVal, 200);
      strokeWeight(0.5);
      drawLine(x, y, rad, leng);
      //drawLineDetail(x, y, rad, leng, 2.0, 0.5, color(colorVal, 255), color(colorVal, 100), 10);
    }
  }
}

void drawLine(float x, float y, float theta, float leng)
{
  pushMatrix();
  translate(x, y);
  rotate(-theta);
  line(-leng/2, 0, leng/2, 0);
  popMatrix();
}

void drawLineDetail(float x, float y, float theta, float leng, float centerWeight, float endWeight, color centerCol, color endCol, int precision)
{
  int num = precision;
  float dleng = leng/(float)num;
  pushMatrix();
  translate(x, y);
  rotate(-theta);
  translate(-leng/2.0, 0);
  for (int i = 0; i < num; i++)
  {
    stroke(lerpColor(centerCol, endCol, abs((float)i/((float)num/2.0)-1.0)));
    strokeWeight(map(abs((float)i-(float)num/2.0), 0, (float)num/2.0, centerWeight, endWeight));
    line(dleng*i, 0, dleng*(i+1), 0);
  }
  popMatrix();
}

void drawCircTanLines(float cen_x, float cen_y, float r, float leng, int precision)
{
  int num = precision;
  for (int i = 0; i < num; i++)
  {
    float rad = TWO_PI/(float)num*(float)i;
    float x = r*cos(rad), y = r*sin(rad);
    stroke(degrees(rad), 255, 255, 50);
    strokeWeight(0.5);
    drawLine(cen_x+x, cen_y+y, -(HALF_PI+rad), leng);
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
}
