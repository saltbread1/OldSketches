import processing.opengl.*;

void setup()
{
  size(1600, 900, OPENGL);
  background(255);
  smooth();
  noLoop();
}

void draw()
{
  background(255);
  drawBoxes();
  save("image.png");
}

void drawBoxes()
{
  float r = 300;
  float[][] circ_in = getPoints(width/2, height/2, r, 0);
  float[][] circ_out = getPoints(width/2, height/2, dist(0, 0, width/2, height/2), r);
  strokeWeight(1);
  
  pushMatrix();
  translate(0, 0, -600);
  // in
  for (int i = 0; i < circ_in.length; i++)
  {
    float x = (sqrt(2)+random(-0.2, 0.2))*circ_in[i][2];
    float y = sqrt(4.0*circ_in[i][2]*circ_in[i][2]-x*x);
    float h1 = map(pow(dist(width/2, height/2, circ_in[i][0], circ_in[i][1]), 0.5), 0, sqrt(300), height*1.5, 100);
    float h2 = (abs(randomGaussian())+1.0)*50;
    
    if (random(100) < 50)
    {
      stroke(0);
      fill(255);
    }
    else
    {
      stroke(255);
      fill(0);
    }
    // up
    pushMatrix();
    translate(circ_in[i][0], h1/2, circ_in[i][1]);
    rotateY(QUARTER_PI);
    box(x, h1, y);
    popMatrix();
    
    // down
    pushMatrix();
    translate(circ_in[i][0], height-h2/2, circ_in[i][1]);
    rotateY(QUARTER_PI);
    box(x, h2, y);
    popMatrix();
  }
  
  // out
  for (int j = 0; j < 2; j++)
  {
    for (int i = 0; i < circ_out.length; i++)
    {
      float x = (sqrt(2)+random(-0.2, 0.2))*circ_out[i][2];
      float y = sqrt(4.0*circ_out[i][2]*circ_out[i][2]-x*x);
      float h = (abs(randomGaussian())+1.0)*100;
      
      if (random(100) < 50)
      {
        stroke(0);
        fill(255);
      }
      else
      {
        stroke(255);
        fill(0);
      }
      pushMatrix();
      translate(circ_out[i][0], h/2+(height-h)*j, circ_out[i][1]);
      rotateY(QUARTER_PI);
      box(x, h, y);
      popMatrix();
    }
  }
  popMatrix();
}

float[][] getPoints(float cen_x, float cen_y, float range, float inside)
{
  // draw circle in the outer circle
  float[][] circ = new float[round(range)][3];
  float radius = 20;
  int index = 0;
  
  float r0 = random(inside+radius, range-radius);
  float theta0 = random(TWO_PI);
  
  // the first circles
  circ[index] = new float[]{cen_x+r0*cos(theta0), cen_y+r0*sin(theta0), radius};
  index++;
  
  // draw more circles
  for (int i = 0; i < circ.length-1; i++)
  {
    float r = inside, theta = random(TWO_PI);
    float[] possible_x = {};
    float[] possible_y = {};
    int decided_index;
    
    // examine all of the center whose circles do not overlap already drawn circles
    // check coordinates according to the locus of the spiral
    while (r < range-radius) // scan r
    {
      int num = round(r*0.1);
      for (int j = 0; j < num; j++) // scan theta
      {
        float x = cen_x+r*cos(theta);
        float y = cen_y+r*sin(theta);
        
        // check if the circle of center=(x, y), r=radius overlap
        for (int k = 0; k < index; k++)
        {
          float dis = dist(x, y, circ[k][0], circ[k][1]);
          if (dis < radius+circ[k][2]) // overlap
          {
            break;
          }
          else if (k >= index-1)
          {
            possible_x = append(possible_x, x);
            possible_y = append(possible_y, y);
            break;
          }
        }
        theta += TWO_PI/(float)num;
      }
      r += range/50.0;
    }
    
    // choose one point in all of the center whose circles do not overlap
    if (possible_x.length > 0)
    {
      decided_index = (int)random(possible_x.length-1);
      circ[index] = new float[]{possible_x[decided_index], possible_y[decided_index], radius};
      index++;
    }
    else
    {
      break;
    }
  }
  return circ;
}

void keyPressed()
{
  if (keyCode == ENTER) save("image.png");
}
