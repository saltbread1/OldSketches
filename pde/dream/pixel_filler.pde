void drawPixelFiller()
{
  while (true)
  {
    fcount++;
    int size = activePixels.size();
    for (int i = 0; i < size; i++)
    {
      ActivePixel activePixel = activePixels.get(0);
      activePixels.remove(0);
      int index = activePixel.index;
      int dir = activePixel.dir;
      int winding = activePixel.winding;
      int life = activePixel.life;
      if (life <= 0)
      {
        continue;
      }
      
      for (int d = 0; d < pixelDirectionOffsets.length; d++)
      {
        int newDir = dir + d * winding;
        newDir %= pixelDirectionOffsets.length;
        if (newDir < 0)
        {
          newDir += pixelDirectionOffsets.length;
        }
        int newIndex = index + pixelDirectionOffsets[newDir];
        if (!occupiedPixels[newIndex])
        {
          ActivePixel newActivePixel = 
            new ActivePixel
            (
              newIndex, newDir, winding,
              dir != newDir ? life-1 : life,
              activePixel.colour
            );
          activePixels.add(newActivePixel);
          newActivePixel.drawMe();
          occupiedPixels[newIndex] = true;
          break;
        }
      }
    }
    
    if (fcount % 300 == 0)
    {
      updateFreePixels();
    }
    
    if (freePixels.size() == 0)
    {
      updatePixels();
      println("drawed");
      break;
    }
    
    if (fcount > 10000 && activePixels.size() < 200)
    {
      drawStartPixel();
    }
  }
}

void initializePixelFiller()
{
  loadPixels();
  
  // initialize variables
  hueOffset = floor(random(360));
  hueStepSize = 100;
  hueStepCount = 4;
  fcount = 0;
  
  // create initial occupied pixels
  occupiedPixels = new boolean[width*height];
  for (int i = 0; i < occupiedPixels.length; i++)
  {
    int x = i%width;
    int y = (i-x)/width;
    occupiedPixels[i] = true;
    for (Circle circle : circles)
    {
      if (abs(x-circle.x) <= circle.r && abs(y-circle.y) <= circle.r)
      {
        occupiedPixels[i] = false;
        break;
      }
    }
  }
  // occupy around pixels
  for (int i = 0; i < width; i++)
  {
    occupiedPixels[i] = true;
    occupiedPixels[i+width*(height-1)] = true;
  }
  for (int j = 0; j < height; j++)
  {
    occupiedPixels[width*j] = true;
    occupiedPixels[width-1+width*j] = true;
  }
  
  // create initial free pixels
  updateFreePixels();
  
  // create initial active pixels
  activePixels = new ArrayList<ActivePixel>();
  for (int i = 0; i < 5; i++)
  {
    drawStartPixel();
  }
}

void drawStartPixel()
{
  // pick a random position from free pixels for refill pixels
  int index = freePixels.get(floor(random(freePixels.size())));
  
  if (!occupiedPixels[index])
  {
    int huu = (floor(random(hueStepCount)) * hueStepSize + hueOffset) % 360;
    int sat = round(random(50, 70));
    int bri = round(constrain(pow(random(1), 2) * 110, 10, 100));
    float rand = random(3);
    color colour = rand < 1 ? color(360) : rand < 2.5 ? color(0) : color(huu, sat, bri);
    ActivePixel newActivePixel = 
      new ActivePixel
      (
        index, floor(random(pixelDirectionOffsets.length)),
        random(1) > 0.5 ? -1 : 1,
        round(random(width/10, width/5)),
        colour
      );
    activePixels.add(newActivePixel);
    newActivePixel.drawMe();
    occupiedPixels[index] = true;
  }
}

void updateFreePixels()
{
  freePixels = new IntList();
  for (int i = 0; i < occupiedPixels.length; i++)
  {
    if (!occupiedPixels[i])
    {
      freePixels.append(i);
    }
  }
}

class ActivePixel
{
  int index, dir, winding, life;
  color colour;
  
  ActivePixel(int index, int dir, int winding, int life, color colour)
  {
    this.index = index;
    this.dir = dir;
    this.colour = colour;
    this.winding = winding;
    this.life = life;
  }
  
  void drawMe()
  {
    pixels[index] = colour;
  }
}
