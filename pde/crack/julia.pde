// base class of Julia set
abstract class JuliaBase
{
  int maxiterations = 100; // max times of calculating the sequence
  Complex z0; // constant
  double x_min, x_max, y_min, y_max; // calculate range
  int w_min, h_min, w, h; // drawing range
  
  abstract Complex calc_nextterm(Complex z);
  
  double find_elements(Complex z, int iterations)
  {
    if (iterations < this.maxiterations)
    {
      double lim = 50;
      if (abs((float)z.real) < lim && abs((float)z.img) < lim)
      {
        return find_elements(calc_nextterm(z), iterations+1);
      }
      else
      {
        double diffToLast = dist((float)z.real, (float)z.img, (float)z0.real, (float)z0.img);
        double diffToMax = dist((float)lim, (float)lim, (float)z0.real, (float)z0.img);
        double divergeNum = iterations;
        divergeNum += diffToMax/diffToLast*10;
        return divergeNum; // diverge
      }
    }
    else
    {
      return -1; // converge
    }
  }
  
  void drawFractal()
  {
    loadPixels();
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        if (i+w_min >= 0 && i+w_min <= width && j+h_min >= 0 && j+h_min <= height)
        {
          double x = i - w/2;
          double y = j - h/2;
          double radius = sqrt((float)x*(float)x+(float)y*(float)y);
          double rad = atan2((float)y, (float)x);
          double arc = radius*rad;
          double init_x = 0;
          if (radius != 0)
          {
            init_x = map((float)arc, 0, TWO_PI*(float)radius, (float)x_min, (float)x_max);
          }
          double init_y = map((float)radius, 0, w, (float)y_min, (float)y_max);
          Complex init_z = new Complex(init_x, -init_y); // initial term
          double type = find_elements(init_z, 0);
          
          if (type < 0)
          {
            pixels[i+w_min+(j+h_min)*width] = color(0);
          }
          else
          {
            float norm = map((float)type, 0, this.maxiterations, 0, 1);
            pixels[i+w_min+(j+h_min)*width] = color(map(sqrt(norm), 0, 1, 0, 255));
          }
        }
      }
    }
    updatePixels();
  }
}

// f(z) = z0*sin(z)
class Julia_Sin extends JuliaBase
{
  Julia_Sin(double x, double y, int w_min, int h_min, int w, int h)
  {
    this.x_min = 0;
    this.x_max = 8*PI;
    this.y_min = 0;
    this.y_max = 3*PI;
    
    this.w_min = w_min;
    this.h_min = h_min;
    this.w = w;
    this.h = h;
    
    z0 = new Complex(x, y);
  }
  
  Complex calc_nextterm(Complex z)
  {
    // calculate next term
    Complex ex_z = z0.Cmult(z.Csin());
    return ex_z;
  }
}
