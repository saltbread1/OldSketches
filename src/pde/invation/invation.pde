import processing.opengl.*;

void setup()
{
  size(1600, 900, OPENGL);
  background(0);
  noLoop();
}

void draw()
{
  background(0);
  noStroke();
  ambientLight(50, 50, 50);
  directionalLight(255, 255, 255, 1, 1, -1);
  
  for (int i = 0; i < 400; i++)
  {
    drawFractal(random(-width/2, 3*width/2), random(-height/2, 3*height/2), random(-500, 300), random(TWO_PI), random(TWO_PI), random(TWO_PI), 20, 0.9, 30);
  }
  
  println("drawed");
  
  save("image.jpg");
}

void drawFractal(float x, float y, float z, float rad_x, float rad_y, float rad_z, float r, float a, int maxiterations)
{
  pushMatrix();
  translate(x, y, z);
  rotateX(rad_x);
  rotateY(rad_y);
  rotateZ(rad_z);
  drawSpheres(r, a, 0, maxiterations, 0, (int)random(1000)%2);
  popMatrix();
}

void drawSpheres(float r, float a, int iterations, int maxiterations, int seed, int hue)
{
  if (iterations < maxiterations)
  {
    float rad = HALF_PI/2.0;
    float rad_x, rad_y, rad_z;
    float noiseScale = 1;
    
    switch (hue)
    {
      case 0:
        fill(255);
        stroke(0);
        break;
      case 1:
        fill(0);
        stroke(230, 0, 0);
        break;
    }
    strokeWeight(0.5);
    //noStroke();
    sphereDetail(max((int)(60.0/100.0*r), 10));
    
    if (iterations == 0)
    {
      sphere(r);
      
      pushMatrix();
      for (int i = 0; i < 4; i++)
      {
        int s = i*10;
        rad_x = map(noise((float)iterations*noiseScale, s), 0, 1, -rad, rad);
        rad_y = map(noise((float)iterations*noiseScale, s+10), 0, 1, -rad, rad);
        rad_z = map(noise((float)iterations*noiseScale, s+20), 0, 1, -rad, rad);
        
        rotateZ(HALF_PI);
        translate(2.0*r, 0, 0);
        rotateX(rad_x); rotateY(rad_y); rotateZ(rad_z);
        drawSpheres(r, a, iterations+1, maxiterations, s, hue);
        translate(-(2.0*r), 0, 0);
      }
      popMatrix();
      
      pushMatrix();
      rotateY(HALF_PI);
      for (int i = 0; i < 2; i++)
      {
        int s = i*10+100;
        rad_x = map(noise((float)iterations*noiseScale, s), 0, 1, -rad, rad);
        rad_y = map(noise((float)iterations*noiseScale, s+10), 0, 1, -rad, rad);
        rad_z = map(noise((float)iterations*noiseScale, s+20), 0, 1, -rad, rad);
        
        rotateY(PI);
        translate(2.0*r, 0, 0);
        rotateX(rad_x); rotateY(rad_y); rotateZ(rad_z);
        drawSpheres(r, a, iterations+1, maxiterations, s, hue);
        translate(-(2.0*r), 0, 0);
      }
      popMatrix();
      
      for (int i = -1; i <= 1; i+=2)
      {
        for (int j = 0; j < 4; j++)
        {
          int s = i*10+200;
          rad_x = map(noise((float)iterations*noiseScale, s), 0, 1, -rad, rad);
          rad_y = map(noise((float)iterations*noiseScale, s+10), 0, 1, -rad, rad);
          rad_z = map(noise((float)iterations*noiseScale, s+20), 0, 1, -rad, rad);
          
          pushMatrix();
          rotateZ(HALF_PI*(0.5+(float)j));
          rotateY(HALF_PI/2.0*(float)i);
          translate(2.0*r, 0, 0);
          rotateX(rad_x); rotateY(rad_y); rotateZ(rad_z);
          drawSpheres(r, a, iterations+1, maxiterations, s, hue);
          popMatrix();
        }
      }
    }
    else
    {
      rad_x = map(noise((float)iterations*noiseScale, seed), 0, 1, -rad, rad);
      rad_y = map(noise((float)iterations*noiseScale, seed+10), 0, 1, -rad, rad);
      rad_z = map(noise((float)iterations*noiseScale, seed+20), 0, 1, -rad, rad);
    
      sphere(r);
      
      pushMatrix();
      translate((1.0+a)*r, 0, 0);
      rotateX(rad_x); rotateY(rad_y); rotateZ(rad_z);
      drawSpheres(a*r, a, iterations+1, maxiterations, seed, hue);
      popMatrix();
    }
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
}
