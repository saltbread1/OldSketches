long _seed = 1;

void setup()
{
  size(1600, 900);
  background(0);
  smooth();
  noLoop();
  
  randomSeed(_seed);
}

void draw()
{
  background(0);
  
  walk(width/2, height/2, width-50, height-50, 20, 3, 50);
  //walk(width/2, height/2, width, height, 20, 3, 300);
  
  println(_seed);
}

void walk(float init_x, float init_y, float wid, float hei, float r, int num, int maxiterations)
{
  float[][] pos = new float[maxiterations+1][2];
  float[] rad = new float[maxiterations+1];
  float[] a = new float[maxiterations+1];
  pos[0][0] = init_x; pos[0][1] = init_y;
  
  for (int i = 0; i < maxiterations; i++)
  {
    float rr = r/(float)num;
    a[i] = (int)random(100)%5+2;
    
    if (i%10 <= 4)
    {
      stroke(255);
      strokeWeight(1);
      fill(0);
    }
    else
    {
      noStroke();
      fill(255);
    }
    
    ellipse(pos[i][0], pos[i][1], 2.0*r, 2.0*r);
    
    if (i == 0)
    {
      rad[0] = HALF_PI*((int)random(100)%4);
      
      for (int j = 0; j < 3; j++)
      {
        float dir = rad[0] + HALF_PI*(float)(j+1);
        float b = 0.9;
        pushMatrix();
        translate(pos[i][0], pos[i][1]);
        rotate(dir);
        translate((1.0+b)*r, 0);
        drawCircles(b*r, b, 20, 10*i+j, (int)random(100)%2);
        popMatrix();
      }
    }
    else
    {
      int edge1 = 0, edge2 = 0;
      float xx = pos[i-1][0] + (r+rr)*cos(rad[i-1]);
      float yy = pos[i-1][1] + (r+rr)*sin(rad[i-1]);
      
      for (int j = 0; j < 3; j++)
      {
        float dir = rad[i-1] + HALF_PI*(float)(j-1);
        float x = pos[i][0] + 2.0*r*(a[i]+1.0)*cos(dir);
        float y = pos[i][1] + 2.0*r*(a[i]+1.0)*sin(dir);
        boolean flg = false;
        
        // not to be on shapes or lines which have already drawn
        for (int k = 0; k < i; k++)
        {
          float dx = pos[k+1][0]-pos[k][0];
          float dy = pos[k+1][1]-pos[k][1];
          if (((((dx > r) && (pos[k][0]-r < x && x < pos[k+1][0]+r)) || ((dx < -r) && (pos[k+1][0]-r < x && x < pos[k][0]+r))) && (abs(y-pos[k][1]) < r))
            || ((((dy > r) && (pos[k][1]-r < y && y < pos[k+1][1]+r)) || ((dy < -r) && (pos[k+1][1]-r < y && y < pos[k][1]+r))) && (abs(x-pos[k][0]) < r)))
          {
            flg = true;
            break;
          }
        }
        
        // not to be out of screen
        if (x > init_x-wid/2+r && x < init_x+wid/2-r && y > init_y-hei/2+r && y < init_y+hei/2-r)
        {
          if (!flg) // add condition
          {
            edge1 += (int)pow(10, j);
          }
          edge2 += (int)pow(10, j);
        }
      }
      
      rad[i] = rad[i-1] + decideDirection(edge1, edge2);
      
      for (int j = 0; j < a[i-1]*num; j++)
      {
        ellipse(xx, yy, 2.0*rr, 2.0*rr);
        
        xx += 2.0*rr*cos(rad[i-1]);
        yy += 2.0*rr*sin(rad[i-1]);
      }
      
      for (int j = 0; j < 3; j++)
      {
        float dir = rad[i-1] + HALF_PI*(float)(j-1);
        if (dir != rad[i])
        {
          float b = 0.9;
          pushMatrix();
          translate(pos[i][0], pos[i][1]);
          rotate(dir);
          translate((1.0+b)*r, 0);
          drawCircles(b*r, b, 20, 10*i+j, (int)random(100)%2);
          popMatrix();
        }
      }
    }
    
    pos[i+1][0] = pos[i][0] + 2.0*r*(a[i]+1.0)*cos(rad[i]);
    pos[i+1][1] = pos[i][1] + 2.0*r*(a[i]+1.0)*sin(rad[i]);
  }
}

float decideDirection(int num1, int num2)
{
  int dir_num = 0;
  switch (num1)
  {
    case 0:
      if (num1 != num2)
      {
        println("ignore");
        return decideDirection(num2, num2);
      }
      break;
    case 1:
      dir_num = -1;
      break;
    case 10:
      dir_num = 0;
      break;
    case 11:
      dir_num = (int)random(100)%2-1;
      break;
    case 100:
      dir_num = 1;
      break;
    case 101:
      dir_num = ((int)random(100)%2)*2-1;
      break;
    case 110:
      dir_num = (int)random(100)%2;
      break;
    case 111:
      dir_num = (int)random(100)%3-1;
      break;
  }
  return HALF_PI*(float)dir_num;
}

void drawCircles(float r, float a, int iterations, int seed, int option)
{
  if (iterations > 0)
  {
    float maxrad = HALF_PI/1.5*(float)(1-2*option);
    float rad = map(noise(iterations*0.05, seed, _seed), 0, 1, 0, maxrad);
    ellipse(0, 0, 2.0*r, 2.0*r);
    //drawSquare(0, 0, 2.0*r);
    pushMatrix();
    rotate(rad);
    translate((1.0+a)*r, 0);
    drawCircles(a*r, a, iterations-1, seed, option);
    popMatrix();
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image"+str(_seed)+".jpg");
  }
  else if (keyCode == RIGHT)
  {
    _seed++;
    randomSeed(_seed);
    noiseSeed(_seed);
    redraw();
  }
  else if (keyCode == LEFT && _seed > 0)
  {
    _seed--;
    randomSeed(_seed);
    noiseSeed(_seed);
    redraw();
  }
}
