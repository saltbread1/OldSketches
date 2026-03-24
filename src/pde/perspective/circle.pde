class Circle
{
  float x, y, r, rad1, rad2;
  Circle(float x, float y, float r, float rad1, float rad2)
  {
    this.x = x; this.y = y;
    this.r = r;
    this.rad1 = rad1; this.rad2 = rad2;
  }
  
  void drawCircle(color c1, color c2, color c3, color c4, float w)
  {
    pushMatrix();
    translate(x, y);
    
    // draw large circle
    //stroke(c1);
    //strokeWeight(w);
    noStroke();
    fill(c2);
    ellipse(0, 0, 2.0*r, 2.0*r);
    
    // draw decorations
    stroke(c3);
    strokeWeight(w);
    noFill();
    for (int i = 0; i < 3; i++)
    {
      float rr = map(i, 0, 3, r*0.8, r*0.3);
      float drad = random(HALF_PI, TWO_PI-QUARTER_PI);
      rotate(random(TWO_PI));
      arc(0, 0, 2.0*rr, 2.0*rr, 0, drad, OPEN);
    }
    
    // draw minor circle
    noStroke();
    fill(c4);
    ellipse(0, 0, r*0.6, r*0.6);
    
    popMatrix();
  }
  
  void drawArc(color c, float w)
  {
    stroke(c);
    strokeWeight(w);
    noFill();
    arc(x, y, 2.0*r, 2.0*r, rad1, rad2, OPEN);
  }
}
