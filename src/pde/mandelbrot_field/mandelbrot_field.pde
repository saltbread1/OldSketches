import com.hamoid.*;
import complexnumbers.Complex;

ArrayList<Particle> _particles;
int _particlesNum;
VideoExport _videoExport;

void setup()
{
  size(512, 512);
  smooth();

  _particles = new ArrayList<Particle>();
  _particlesNum = 8;
  for (int i = 0; i < _particlesNum; i++) { _particles.add(new Particle0()); }

  //_videoExport = new VideoExport(this, "mandelbrot_field.mp4");
  //_videoExport.startMovie();
}

void draw()
{
  background(0, 0, 255);

  Complex z1, z2;
  push();
  stroke(255);
  z1 = _particles.get(0).getPosition();
  for (int i = 1; i <= _particles.size(); i++)
  {
    Particle p = _particles.get(i%_particles.size());
    p.drawMe(64, 5.);
    z2 = p.getPosition();
    line((float)z1.re, (float)z1.im, (float)z2.re, (float)z2.im);
    z1 = z2.copy();
  }
  pop();

  // _videoExport.saveFrame();
  // if (frameCount > 40*30)
  // {
  //   _videoExport.endMovie();
  //   exit();
  // }
}

void keyPressed()
{
  if (keyCode == 'S') { saveImage(); }
  else if (keyCode == SHIFT) { redraw(); }
}

void saveImage()
{
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  saveFrame(timestamp + ".png");
}
