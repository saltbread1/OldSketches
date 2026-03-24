class Curve
{
  float x;
  float y;
  float size;
  float speed = 0.4;
  float noiseScale = 500;
  color col;
  
  Curve(float x, float y, color c)
  {
    this.x = x;
    this.y = y;
    this.col = c;
  }
  
  void drawMe()
  {
    noStroke();
    fill(col, 60);
    beginShape();
    for (int i = 0; i < 100; i++)
    {
      float rad = TWO_PI*noise(x/noiseScale, y/noiseScale)*noiseScale;
      x += speed*cos(rad);
      y += speed*sin(rad);
      vertex(x,y);
    }
    endShape();
  }
}
