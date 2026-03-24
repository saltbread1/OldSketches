import processing.opengl.*;

void setup()
{
  size(1600, 900, OPENGL);
  background(255);
  smooth();
  noLoop();
  colorMode(HSB, 360, 255, 255);
}

void draw()
{
  background(255);
  lights();
  
  // torus
  Torus torus = new Torus(700, 150, 0.5);
  pushMatrix();
  translate(300, height/2, 100);
  rotateY(PI);
  torus.drawMe();
  popMatrix();
  
  save("image.png");
}
