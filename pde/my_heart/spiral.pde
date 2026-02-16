class Spiral
{
  float rad = 0;
  int cycle_num = 11;
  int num = 300;
  float max_r;
  float maxstrokeW, minstrokeW;
  color col1, col2;
  
  Spiral(float max_r, float maxstrokeW, float minstrokeW, color col1, color col2)
  {
    this.max_r = max_r;
    this.maxstrokeW = maxstrokeW;
    this.minstrokeW = minstrokeW;
    this.col1 = col1;
    this.col2 = col2;
  }
  
  void drawMe()
  {
    float[] radius = new float[num];
    float[] rad = new float[num];
    float dr = max_r/(float)(num);
    float drad = TWO_PI*(float)cycle_num/(float)num;
    for (int i = 0; i < num; i++)
    {
      float val = frameCount/(float)(cycletime*frameRate)*TWO_PI;
      rad[i] = drad*(i+1);
      radius[i] = dr*i*(1.0 + 4*(0.5-noise(rad[i], 1.5*(cos(val)+1.0), 1.5*(sin(val)+1.0))));
      stroke(lerpColor(col1, col2, (float)i/(float)(num-1)));
      strokeWeight(map(num-1-i, 0, num-1, minstrokeW, maxstrokeW));
      line(radius[i]*cos(rad[i]), radius[i]*sin(rad[i]), 0, 0);
    }
    
    for (int i = 0; i < num-1; i++)
    {
      stroke(lerpColor(col1, col2, (float)i/(float)(num-2)));
      strokeWeight(map(num-2-i, 0, num-2, minstrokeW, maxstrokeW));
      line(radius[i]*cos(rad[i]), radius[i]*sin(rad[i]), radius[i+1]*cos(rad[i+1]), radius[i+1]*sin(rad[i+1]));
    }
  }
}
