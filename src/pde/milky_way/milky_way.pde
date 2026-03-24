void setup()
{
  size(1600, 900);
  smooth();
  noLoop();
  background(255);
}

void draw()
{
  background(255, 0, 0);
  noiseSeed((long)random(1000));
  TriangleFunction2 _tf2 = new TriangleFunction2(
    0., height/2, 0., 50., 0.001, 100., 5., width, 
    0.8, 5., 0.75, 6, color(0), color(255)
  );
  _tf2.setInitRad();
  _tf2.drawMe();
}

class TriangleFunction2
{
  private TriangleFunction tfStroke, tfFill;
  private color cStroke, cFill;
  
  private TriangleFunction2(
    float x0, float y0, float rot, float dx, float dt, 
    float amp0, float dia0, float maxLength, float rAmp, 
    float rPer, float rDia, int n, color cStroke, color cFill)
  {
    tfStroke = new TriangleFunction(
      x0, y0, rot, dx, dt, amp0, dia0*2., 
      maxLength, rAmp, rPer, rDia, n
    );
    tfFill = new TriangleFunction(
      x0, y0, rot, dx, dt, amp0, dia0, 
      maxLength, rAmp, rPer, rDia, n
    );
    this.cStroke = cStroke;
    this.cFill = cFill;
  }
  
  public void setInitRad()
  {
    float phi = random(TWO_PI);
    tfStroke.setInitRad(phi);
    tfFill.setInitRad(phi);
  }
  
  public void setInitRad(float phi)
  {
    tfStroke.setInitRad(phi);
    tfFill.setInitRad(phi);
  }
  
  public void drawMe()
  {
    push();
    noStroke();
    fill(cStroke);
    tfStroke.drawMe();
    fill(cFill);
    tfFill.drawMe();
    pop();
  }
}

class TriangleFunction
{
  private final PVector initPos;
  private final float rot;
  private final float dx, dt;
  private final float amp0, dia0;
  private final float maxLength;
  private final float rAmp, rPer, rDia;
  private final int n;
  private PVector[] curPos, prePos;
  private float cashX, x, t, phi;
  
  private TriangleFunction(
    float x0, float y0, float rot, float dx, float dt, 
    float amp0, float dia0, float maxLength, 
    float rAmp, float rPer, float rDia, int n)
  {
    this.initPos = new PVector(x0, y0);
    this.rot = rot;
    this.dx = dx;
    this.dt = dt;
    this.amp0 = amp0;
    this.dia0 = dia0;
    this.maxLength = maxLength;
    this.rAmp = rAmp;
    this.rPer = rPer;
    this.rDia = rDia;
    this.n = n;
    reset();
  }
  
  public void reset()
  {
    curPos = new PVector[n];
    prePos = new PVector[n];
    for (int i = 0; i < n; i++)
    {
      curPos[i] = new PVector(0., 0.);
      prePos[i] = new PVector(100., 100.);
    }
    cashX = x = t = 0.;
  }
  
  public void setInitRad(float phi)
  {
    this.phi = phi;
  }
  
  public void drawMe(float updateLength)
  {
    if (cashX >= maxLength) { return; }
    pushMatrix();
    translate(initPos.x, initPos.y);
    rotate(rot);
    while (abs(cashX-curPos[0].x) < min(maxLength, updateLength))
    {
      float amp = amp0;
      float dia = dia0;
      float t2 = t+phi;
      float theta = 0.;
      float noiseValue = map(sq(noise(t2)), 0., 1., 0.5, 3.);
      amp *= noiseValue;
      dia *= noiseValue;
      for (int j = 0; j < n; j++)
      {
        float y = amp*sin(t2);
        float dy = amp*pow(rPer, j)*cos(t2);
        // update position
        curPos[j].x = j == 0 ? x : curPos[j-1].x + y*sin(theta);
        curPos[j].y = j == 0 ? y : curPos[j-1].y + y*cos(theta);
        // sum of rotated radian
        theta -= atan2(dy, dx);
        // draw rect at regular distance
        if (dist(curPos[j].x, curPos[j].y, prePos[j].x, prePos[j].y) >= dia*0.3)
        {
          circle(curPos[j].x, curPos[j].y, dia);
          prePos[j].x = curPos[j].x;
          prePos[j].y = curPos[j].y;
        }
        amp *= rAmp;
        t2 *= rPer;
        dia *= rDia;
      }
      x += dx*dt;
      t += dt;
    }
    popMatrix();
    cashX = curPos[0].x;
  }
  
  public void drawMe() { drawMe(maxLength); }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    saveFrame("####.png");
  }
  else if (keyCode == SHIFT)
  {
    redraw();
  }
}
