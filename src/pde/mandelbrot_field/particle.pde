abstract class Particle
{
  final int[] realRange;
  final float[] virtualRange;
  float theta;
  final float dtheta;
  Complex position;
  final float noiseScale;
  final int seed;

  Particle()
  {
    realRange = new int[]{0, 0, width, height};
    virtualRange = new float[]{-1.5, -1.5, 1.5, 1.5};
    theta = 0.;
    dtheta = 0.01;
    position = new Complex();
    noiseScale = 0.3;
    seed = (int)random(999999);
  }

  abstract Complex function(Complex z, Complex c);

  final Complex getPosition() { return position; }

  void drawMe(int cyclenum, float diameter)
  {
    move();
    drawCycle(real2virtual(position), cyclenum, diameter);
  }

  void move()
  {
    float x = map(noise(theta*noiseScale, seed%1217), 0., 1., realRange[0], realRange[2]);
    float y = map(noise(theta*noiseScale, seed%1223), 0., 1., realRange[1], realRange[3]);
    position = new Complex(x, y);
    theta += dtheta;
  }

  void drawCycle(Complex z, int cyclenum, float diameter)
  {
    Complex c = z.rotate(theta);
    Complex z1 = c.copy(), z2;
    push();
    float ix = (float)virtual2real(z1.rotate(-theta)).re;
    float iy = (float)virtual2real(z1.rotate(-theta)).im;
    noStroke(); fill(255); circle(ix, iy, diameter*2.);
    for (int i = 0; i < cyclenum; i++)
    {
      z2 = function(z1, c);
      float px = (float)virtual2real(z1.rotate(-theta)).re;
      float py = (float)virtual2real(z1.rotate(-theta)).im;
      float x = (float)virtual2real(z2.rotate(-theta)).re;
      float y = (float)virtual2real(z2.rotate(-theta)).im;
      //if (dist(px, py, x, y) < 200.)
      {
        push(); stroke(255, 128); line(px, py, x, y); pop();
        circle(x, y, diameter);
      }
      z1 = z2.copy();
    }
    pop();
  }

  Complex real2virtual(Complex c)
  {
    float vmx = (virtualRange[0]+virtualRange[2])/2.;
    float vmy = (virtualRange[1]+virtualRange[3])/2.;
    float rmx = (realRange[0]+realRange[2])/2.;
    float rmy = (realRange[1]+realRange[3])/2.;
    float sx = (virtualRange[2]-virtualRange[0])/(realRange[2]-realRange[0]);
    float sy = (virtualRange[3]-virtualRange[1])/(realRange[3]-realRange[1]);
    return new Complex((c.re-rmx)*sx+vmx, (c.im-rmy)*sy+vmy);
  }

  Complex virtual2real(Complex c)
  {
    float vmx = (virtualRange[0]+virtualRange[2])/2.;
    float vmy = (virtualRange[1]+virtualRange[3])/2.;
    float rmx = (realRange[0]+realRange[2])/2.;
    float rmy = (realRange[1]+realRange[3])/2.;
    float sx = (realRange[2]-realRange[0])/(virtualRange[2]-virtualRange[0]);
    float sy = (realRange[3]-realRange[1])/(virtualRange[3]-virtualRange[1]);
    return new Complex((c.re-vmx)*sx+rmx, (c.im-vmy)*sy+rmy);
  }
}