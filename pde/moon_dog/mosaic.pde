class Mosaic
{
  float x_min, y_min;
  float wid, hei;
  
  Mosaic(float x_min, float y_min, float wid, float hei)
  {
    this.x_min = x_min;
    this.y_min = y_min;
    this.wid = wid;
    this.hei = hei;
  }
  
  void drawMosaic()
  {
    float noiseScale = 800;
    
    loadPixels();
    for (int i = 0; i < wid; i++)
    {
      for (int j = 0; j < hei; j++)
      {
        float x = i-wid/2;
        float y = j-hei/2;
        if (x*x/(wid/2*wid/2)+y*y/(hei/2*hei/2) <= 1)
        {
          if (i+x_min > 0 && i+x_min < width && j+y_min > 0 && j+y_min < height)
          {
            float rad = TWO_PI*noise((i-5*frameCount)/noiseScale, j/noiseScale, 5*frameCount/noiseScale)*noiseScale;
            float val1 = (1+cos(rad))*0.5;
            float val2 = (1+sin(rad))*0.5;
            pixels[(i+(int)x_min)+(j+(int)y_min)*width] = color(80, 255*val1, 255*val2);
          }
        }
      }
    }
    updatePixels();
  }
}
