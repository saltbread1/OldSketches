long i = 0;

void setup()
{
  size(1600, 900);
  background(0);
  smooth();
  noLoop();
  noiseSeed(55); //41 55 72
  randomSeed(21);
}

void draw()
{
  background(0);
  int hei = (int)(height*0.5);
  createBackground(width, hei);
  drawTube(10, 1, 500, random(height-hei)-100);
}

void drawTube(int num0, int num1, int num2, float y)
{
  for (int k = 0; k < num0; k++)
  {
    float x = random(width/num0)+width/num0*k;
    for (int i = 0; i < num1; i++)
    {
      pushMatrix();
      translate(x,y);
      for (int j = 0; j < num2; j++)
      {
        float r = 100*(1.0 - 0.3*noise(i, j*0.05, k));
        float drad = PI*0.05*(1.0-2.0*noise(i, j*0.05, k));
        float dpos = r*0.05;
        
        stroke(255, map(j, 0, num2-1, 0, 255));
        strokeWeight((float)j/(float)num2*0.5);
        noFill();
        ellipse(0, 0, r, r);
        
        rotate(drad);
        translate(dpos, 0);
      }
      popMatrix();
    }
  }
}

PImage createNoise(int w, int h)
{
  PImage img_bg = createImage(w, h, RGB);
  img_bg.loadPixels();
  for (int i = 0; i < img_bg.width; i++)
  {
    for (int j = 0; j < img_bg.height; j++)
    {
      noiseDetail(5, map(img_bg.height-1-j, 0, img_bg.height-1, 0.3, 0.7));
      float noise = noise(0.005*i, 0.005*j, 0.005*frameCount);
      float val = map(noise(map(noise, 0, 1, 0, 255), 0.05*frameCount), 0, 1, 0, 255);
      img_bg.pixels[i+j*img_bg.width] = color(val);
    }
  }
  img_bg.updatePixels();
  
  return img_bg;
}

void createBackground(int w, int h)
{
  PImage bg_noise = createNoise(w, h);
  image(bg_noise, 0, height-h);
  for (int i = 0; i < height/3; i+=5)
  {
    noStroke();
    fill(0, max(35-(float)i*0.1, 0));
    rect(0, 0, width, height-h+i);
  }
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    save("image.jpg");
  }
  else if (keyCode == SHIFT)
  {
    noiseSeed(i);
    redraw();
    println(i);
    i++;
  }
}
