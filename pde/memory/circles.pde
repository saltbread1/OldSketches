class Circles
{
  int num;
  int maxcnum;
  float leng;
  float ratio = 0.5;
  
  Circles(int num, int maxcnum, float leng)
  {
    this.num = num;
    this.maxcnum = maxcnum;
    this.leng = leng;
  }
  
  void drawMe(float ratio, int iterations, int seed)
  {
    if (iterations > 0)
    {
      int cnum = (int)(maxcnum*ratio);
      float maxradius = 20.0*ratio;
      float minradius = 10.0*ratio;
      
      for (int i = 0; i < num; i++)
      {
        float leng = this.leng*ratio;
        float dleng = leng/cnum;
        PVector pos = new PVector(0, 0);
        pushMatrix();
        //translate(width/2, height/2);
        rotate(TWO_PI/num*i);
        for (int j = 0; j < cnum; j++)
        {
          float rad = map(noise(j*0.04, i*0.08, seed), 0, 1, -HALF_PI, HALF_PI);
          pos = new PVector(dleng*j*cos(rad), dleng*j*sin(rad));
          // *(1.0 + 0.5*(1.0 - 2.0*noise(rad*rad)))
          float radius = 0.5*maxradius*(pow(-cos(TWO_PI*cos(TWO_PI/cnum*j)), 3)+1.0)+minradius;
          stroke(255);
          strokeWeight(2);
          fill(map(j, 0, cnum-1, 0, 255), 255, 200);
          ellipse(pos.x, pos.y, 2*radius, 2*radius);
        }
        translate(pos.x, pos.y);
        rotate(random(TWO_PI));
        drawMe(ratio*this.ratio, iterations-1, (int)random(2147483647));
        popMatrix();
      }
    }
  }
}
