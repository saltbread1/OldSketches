import processing.opengl.*;

void setup()
{
  size(1600, 900, OPENGL);
  background(0);
  smooth();
  //noLoop();
}

void draw()
{
  int num = 5;
  float rad_x = map(mouseY, 0, height, 0, TWO_PI);
  float rad_y = map(mouseX, 0, width, 0, TWO_PI);
  
  background(135, 160, 165);
  ambientLight(100, 100, 100);
  directionalLight(50, 50, 50, 1, 1, -1);
  //lightFalloff(1, 0.01, 0);
  //pointLight(200, 200, 200, width/2, height/2, 0);
  
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(rad_x); rotateY(rad_y); rotateZ(-PI/2);
  for (int i = 0; i < num; i++)
  {
    LineFractal line = new LineFractal(5, 300, 0.8, 1, 90, 10, i*10);
    line.drawMe();
    rotateZ(TWO_PI/(float)num);
  }
  /*rotateY(PI/2);
  for (int i = 0; i < 2; i++)
  {
    LineFractal line = new LineFractal(5, 300, 0.8, 1, 90, 10, (num+i)*10);
    line.drawMe();
    rotateY(PI);
  }*/
  popMatrix();
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    saveFrame("image-####.jpg");
  }
}
