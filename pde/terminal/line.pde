class Line
{
  float num;
  float leng;
  float maxstrokeW;
  color c1;
  color c2;
  
  Line(int num, float leng, float maxstrokeW, color c1, color c2)
  {
    this.num = num;
    this.leng = leng;
    this.maxstrokeW = maxstrokeW;
    this.c1 = c1;
    this.c2 = c2;
  }
  
  void drawMe()
  {
    float noise = random(10);
    pushMatrix();
    for (int i = 0; i < num; i++)
    {
      color c = lerpColor(c1, c2, ((float)i)/((float)num));
      float theta = PI/2*(1.0-2.0*noise(noise));
      //float theta = PI/2*(1.0-2.0*random(1));
      rotate(-theta);
      stroke(c);
      strokeWeight(max(maxstrokeW/num*(num-i),0.5));
      line(0,0,leng/num, 0);
      translate(leng/num, 0);
      rotate(theta);
      noise += 0.2;
    }
    popMatrix();
  }
}
