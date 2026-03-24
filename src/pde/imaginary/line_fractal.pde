class LineFractal
{
  int maxiterations;
  float initleng;
  float lengratio;
  float rad;
  float reduratio;
  int num;
  int seed;
  
  LineFractal(int maxiterations, float leng, float reduratio, float lengratio, float angle, int num, int seed)
  {
    this.maxiterations = maxiterations;
    this.initleng = leng;
    this.reduratio = reduratio;
    this.lengratio = lengratio;
    this.rad = radians(angle);
    this.num = num;
    this.seed = seed;
  }
  
  void drawMe()
  {
    drawFractal(initleng, maxiterations, seed);
  }
  
  void drawFractal(float leng, int iterations, int seed)
  {
    if (iterations > 0)
    {
      Line line = new Line(num, leng, iterations+1, iterations, color(67, 140, 140), color(250, map(iterations, 1, maxiterations, 30, 80), map(iterations, 1, maxiterations, 80, 30)), seed);
      float tra = line.drawMe(seed*200);
      
      pushMatrix();
      translate(tra, 0, 0);
      for (int i = 0; i < 2; i++)
      {
        rotateZ(rad/2.0);
        drawFractal(leng*reduratio, iterations-1, seed*2);
        rotateZ(-rad);
        drawFractal((leng*lengratio)*reduratio, iterations-1, seed*2+1);
        rotateZ(rad/2.0);
        rotateX(HALF_PI);
      }
      popMatrix();
    }
  }
}
