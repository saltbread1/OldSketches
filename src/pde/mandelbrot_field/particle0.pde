class Particle0 extends Particle
{
  Particle0()
  {
    super();
  }

  Complex function(Complex z, Complex c)
  {
    return z.sq().add(c);
  }
}