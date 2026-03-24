ArrayList<Rhombus> rhombuses;
float square_density = 30.0/(512.0*512.0);
int square_num;

void setup()
{
  size(512, 512);
  smooth();
  noLoop();
  colorMode(HSB, 360, 100, 100, 100);
  rectMode(CENTER);
  square_num = round(square_density*width*height);
  resetScene();
}

void draw()
{
  background(0);
  
  loadPixels();
  for (int i = 0; i < width; i++)
  {
    for (int j = 0; j < height; j++)
    {
      boolean skip = false;
      float a = 0;
      for (Rhombus rhombus : rhombuses)
      {
        float r = dist(i, j, rhombus.x0, rhombus.y0);
        float edge = rhombus.edge(atan2(j-rhombus.y0, i-rhombus.x0));
        if (r <= edge)
        {
          skip = true;
          break;
        }
        a += pow(30.0/(15.0+(r-edge)), 2.0);
      }
      if (skip)
      {
        //pixels[i+width*j] = color(0);
        continue;
      }
      int hueOffset = floor(360.0*noise(20.0*noise(i*0.01, j*0.01, a*0.4)));
      int hue = floor(200+hueOffset + 360.0/sqrt(a))%360;
      int sat = floor(constrain(130.0*(sqrt(a)-sqrt(0.8)), 0, 100));
      pixels[i+width*j] = color(hue, sat, 100);
    }
  }
  updatePixels();
  
  for (Rhombus rhombus : rhombuses)
  {
    rhombus.drawMe();
  }
  
  /*if (frameCount < 100)
  {
    saveFrame("images/####.png");
    resetScene();
    //redraw();
  }
  else
  {
    exit();
  }*/
}

void resetScene()
{
  noiseSeed((long)random(10000));
  rhombuses = new ArrayList<Rhombus>();
  for (int i = 0; i < square_num; i++)
  {
    rhombuses.add(new Rhombus(random(width), random(height), map(pow(random(2), 0.5), 0, sqrt(2), 5, 50), random(1.0, 2.0), 0));
  }
}

class Rhombus
{
  float x0, y0, size, distortion, phi;
  Rhombus(float x0, float y0, float size, float distortion, float phi)
  {
    this.x0 = x0;
    this.y0 = y0;
    this.size = size;
    this.distortion = distortion;
    this.phi = phi;
  }
  
  void drawMe()
  {
    stroke(360);
    strokeWeight(2);
    fill(0);
    rhombus(x0, y0, size, distortion, phi);
  }
  
  float edge(float theta)
  {
    return size / (sqrt(2) * (abs(cos(theta-phi)) + distortion*abs(sin(theta-phi))));
  }
}

void rhombus(float x0, float y0, float size, float distortion, float rad)
{
  beginShape();
  for (int i = 0; i < 4; i++)
  {
    float k = i%2 == 0 ? 1.0 : 1.0/distortion;
    float x = x0 + sqrt(0.5)*size*cos(rad)*k;
    float y = y0 + sqrt(0.5)*size*sin(rad)*k;
    vertex(x, y);
    rad += HALF_PI;
  }
  endShape(CLOSE);
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    saveFrame("####.png");
  }
  else if (keyCode == SHIFT)
  {
    resetScene();
    redraw();
  }
}
