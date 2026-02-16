int _maxiterations = 2000;
int _num = 5;
float[][][][] _point_array = new float[_num][_maxiterations][2][2];
long _seed = 4; // 5, 8, 12, 13

void setup()
{
  size(1600, 900);
  background(0);
  smooth();
  noLoop();
  colorMode(HSB, 255);
}

void draw()
{
  background(0);
  
  pushMatrix();
  translate(width/2, height/2);
  scale(0.7);
  /*for (int i = 0; i < 10; i++)
  {
    noiseSeed((long)random(10000));
    drawRects(random(-width/2, width/2), random(-height/2, height/2), -PI/2, 10, _num, _maxiterations, 0, 0);
    drawLines(10, 100);
    
    fill(0, 50);
    noStroke();
    rect(-width/2, -height/2, width/2, height/2);
  }*/
  noiseSeed(_seed);
  drawRects(0, 0, -PI/2, 10, _num, _maxiterations, 0, 0);
  drawLines(10, 100);
  popMatrix();
  
  println(_seed);
}

void drawRects(float x, float y, float theta, float a, int num, int maxiterations, int iterations, int seed)
{
  fill(255);
  stroke(map(iterations, 0, maxiterations, 100, 255), 255, 255);
  //stroke(map(sin(map(iterations, 0, maxiterations, 0, PI)), 0, 1, 100, 255), 255, 255);
  strokeWeight(3);
  
  if (iterations == 0)
  {
    float r = dist(0, 0, a, a)/2.0 * (float)num/2.5;
    
    // x and y are the center of the polygon
    polygon(x, y, theta, r, num);
    
    for (int i = 0; i < num; i++)
    {
      float rad = theta + TWO_PI/(float)num*(float)i;
      drawRects(x+r*cos(rad), y+r*sin(rad), rad, a, num, maxiterations, 1, i);
    }
  }
  else if (iterations <= maxiterations)
  {
    float b = a + map(noise(iterations*0.1, 0), 0, 1, -a, a);
    float c = a + map(noise(iterations*0.1, 10), 0, 1, -a, a);
    float r = dist(0, 0, b, c)/2.0;
    float rad0 = theta + map(noise(iterations*0.05), 0, 1, -PI/2.0, 0);
    float rad1 = rad0 + atan2(c, b);
    
    // x and y are the upper left of the rect
    rect2(x, y, rad0, b, c);
    
    _point_array[seed][iterations-1][0] = new float[]{x+b*cos(rad0), y+b*sin(rad0)};
    _point_array[seed][iterations-1][1] = new float[]{x+c*cos(rad0+PI/2.0), y+c*sin(rad0+PI/2.0)};
    
    drawRects(x+2.0*r*cos(rad1), y+2.0*r*sin(rad1), rad1, a, num, maxiterations, iterations+1, seed);
  }
}

void drawLines(float min_dis, float max_dis)
{
  strokeWeight(1);
  
  // draw lines between the two shortest distance points
  for (int i = 0; i < _num; i++)
  {
    for (int j = 0; j < _maxiterations; j++)
    {
      // search the two minmum distance points
      for (int l = 0; l < _num; l++)
      {
        for (int m = 0; m < _maxiterations; m++)
        {
          float dis = max_dis;
          int[] index = {0, 0, 0, 0};
          for (int k = 0; k < 2; k++)
          {
            for (int n = 0; n < 2; n++)
            {
              float dis0 = dist(_point_array[i][j][k][0], _point_array[i][j][k][1], 
                _point_array[l][m][n][0], _point_array[l][m][n][1]);
              
              if (dis0 < dis)
              {
                dis = dis0;
                index[0] = k; index[1] = l; index[2] = m; index[3] = n;
              }
            }
          }
          
          // draw a line
          if (min_dis < dis && dis < max_dis)
          {
            float x0 = _point_array[i][j][index[0]][0];
            float y0 = _point_array[i][j][index[0]][1];
            float x1 = _point_array[index[1]][index[2]][index[3]][0];
            float y1 = _point_array[index[1]][index[2]][index[3]][1];
            
            stroke(map((j+index[2])/2, 0, _maxiterations-1, 100, 255), 255, 255, 50);
            //stroke(map(sin(map((j+index[2])/2, 0, _maxiterations, 0, PI)), 0, 1, 100, 255), 255, 255, 50);
            noFill();
            line(x0, y0, x1, y1);
          }
        }
      }
    }
  }
}

void rect2(float x, float y, float rad, float a, float b)
{
  pushMatrix();
  translate(x, y);
  rotate(rad);
  rect(0, 0, a, b);
  popMatrix();
}

void rect3(float cen_x, float cen_y, float rad, float r)
{
  float l = r*sqrt(2.0);
  pushMatrix();
  translate(cen_x, cen_y);
  rotate(rad+PI/4.0);
  rect(-l/2.0, -l/2.0, l, l);
  popMatrix();
}

void polygon(float cen_x, float cen_y, float theta, float r, int num)
{
  beginShape();
  for (int i = 0; i < num; i++)
  {
    vertex(cen_x+r*cos(theta), cen_y+r*sin(theta));
    theta += TWO_PI/(float)num;
  }
  endShape(CLOSE);
}

void drawLine(float x0, float y0, float x1, float y1, int num)
{
  float dx = (x1-x0)/(float)num;
  float dy = (y1-y0)/(float)num;
  float r = dist(x0, y0, x1, y1)/(2.0*(float)num);
  float rad = atan2(y1-y0, x1-x0);
  
  for (int k = 0; k < num; k++)
  {
    rect3(x0+dx*((float)k+0.5), y0+dy*((float)k+0.5), rad, r);
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image"+str(_seed)+".png");
  }
  else if (keyCode == SHIFT)
  {
    redraw();
    _seed++;
  }
}
