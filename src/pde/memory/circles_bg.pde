class Circles_Bg
{
  int num;
  
  Circles_Bg(int num)
  {
    this.num = num;
  }
  
  void drawMe(float radius)
  {
    if (radius < 11)
    { 
      float r = radius;
      while (r > 0)
      {
        noStroke();
        fill(color(map(r/radius, 0, 1, 0, 255), 150, 150));
        ellipse(0, 0, r*2.0, r*2.0);
        r--;
      }
    }
    else
    {
      float a = radius*cos(PI/this.num)/(1.0+sin(PI/this.num));
      float trans = a/cos(PI/this.num);
      
      drawMe(a*(1.0/cos(PI/this.num)-tan(PI/this.num)));
      for (int i = 0; i < this.num; i++)
      {
        pushMatrix();
        rotate(2.0*PI/this.num*i);
        translate(trans, 0);
        drawMe(a*tan(PI/this.num));
        popMatrix();
      }
    }
  }
}
