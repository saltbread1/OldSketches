class Line
{
  int num;
  float leng;
  float maxstrokeW, minstrokeW;
  color c1, c2;
  float[][] rad_arry;
  
  Line(int num, float sum_leng, float maxstrokeW, float minstrokeW, color c1, color c2, int seed)
  {
    this.num = num;
    this.leng = sum_leng/(float)num;
    this.maxstrokeW = maxstrokeW;
    this.minstrokeW = minstrokeW;
    this.c1 = c1;
    this.c2 = c2;
    
    // set theta_arry
    this.rad_arry = new float[this.num][2];
    int noise = seed;
    for (int i = 0; i < this.num; i++)
    {
      float rad = HALF_PI;
      rad_arry[i][0] = map(noise(noise), 0, 1, -rad, rad);
      rad_arry[i][1] = map(noise(noise+100), 0, 1, -rad, rad);
      noise += 1;
    }
    
    // align the y-coordinates of the start ans end drawing points
    for (int j = 0; j < 2; j++)
    {
      float xlength = 0, ylength = 0;
      for (int i = 0; i < this.num; i++)
      {
        xlength += this.leng*cos(rad_arry[i][j]);
        ylength += this.leng*sin(rad_arry[i][j]);
      }
      float gradient = atan2(ylength, xlength);
      for (int i = 0; i < this.num; i++)
      {
        rad_arry[i][j] -= gradient;
      }
    }
  }
  
  float drawMe(int seed)
  {
    float sum_xleng = 0;
    pushMatrix();
    for (int i = 0; i < this.num; i++)
    {
      float rad_x = map(noise((float)i*0.05, seed), 0, 1, 0, TWO_PI);
      
      rotateZ(-rad_arry[i][0]);
      rotateY(-rad_arry[i][1]);
      translate(leng/2.0, 0, 0);
      //rotateX(rad_x);
      
      fill(c1);
      stroke(c2);
      strokeWeight(2);
      box(leng);
      
      //rotateX(-rad_x);
      translate(-leng/2, 0, 0);
      translate(leng, 0, 0);
      rotateY(rad_arry[i][1]);
      rotateZ(rad_arry[i][0]);
      
      sum_xleng += leng*cos(rad_arry[i][0])*cos(rad_arry[i][1]);
    }
    popMatrix();
    
    return sum_xleng;
  }
}
