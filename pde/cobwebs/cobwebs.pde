int _num = 25;
int[] _rand = new int[_num];
float _radius = 1;

void setup()
{
  size(1600, 900);
  background(0);
  smooth();
  //noLoop();
  
  initialize_rand();
}

void draw()
{
  stroke(255, 20);
  strokeWeight(1);
  noFill();
  drawNoiseCircles(width/2, height/2, _radius, _num);
  _radius += 0.2;
}

void drawNoiseCircles(float cen_x, float cen_y, float r, int num)
{
  float[][] point_array = new float[num][2];
  float theta = map(_rand[0], 0, _rand.length, 0, TWO_PI);
  float dtheta = TWO_PI/(float)num;
  float a = 0.1, b = 0.5;
  
  for (int i = 0; i < num; i++)
  {
    float rad = theta + map(_rand[i], 0, 100, -dtheta*a, dtheta*a);
    float x = cen_x+r*cos(rad);
    float y = cen_y+r*sin(rad);
    float radius = 5.0/(float)num*(r+map(noise(i), 0, 1, -r*b, r*b));
    theta += dtheta;
    point_array[i] = noiseCircle(x, y, radius, i);
  }
  
  for (int i = 0; i < num; i++)
  {
    int j = (i+1)%num;
    line(point_array[i][0], point_array[i][1], point_array[j][0], point_array[j][1]);
  }
}

float[] noiseCircle(float cen_x, float cen_y, float r, int seed)
{
  float a = 0.9;
  float timeScale = map(_rand[seed], 0, _rand.length, 0.0002, 0.001);
  float theta = TWO_PI*frameCount*timeScale;
  float rad = theta + map(_rand[seed], 0, _rand.length, 0, TWO_PI);
  float radius = r + map(cycleNoise(rad, 2.0, seed), 0, 1, -r*a, r*a);
  float[] point = {cen_x+radius*cos(rad), cen_y+radius*sin(rad)};
  
  return point;
}

float cycleNoise(float theta, float noiseScale, int seed)
{
  return noise((cos(theta)+1.0)*noiseScale, (sin(theta)+2.0)*noiseScale, seed);
}

void initialize_rand()
{
  for (int i = 0; i < _rand.length; i++)
  {
    _rand[i] = (int)random(_rand.length);
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.png");
  }
  else if (keyCode == SHIFT)
  {
    background(0);
    initialize_rand();
    _radius = 1;
  }
}
