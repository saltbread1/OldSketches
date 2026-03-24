ArrayList<Walker> walkers;
boolean[] occupiedPixels;
IntList freePixels;

int[] dirOffset;

int init_walkers = 2;
int max_walkers = 10;
int init_life_min = 250;
int init_life_max = 500;

int hueOffset = 35;
int hueStepSize = 280;
int hueStepCount = 2;

int count = 0;

void setup()
{
  size(800, 450);
  smooth();
  noLoop();
  colorMode(HSB, 360, 100, 100);
  
  dirOffset = new int[]
  {
    1, // right
    -width+1, // upper right
    -width, // up
    -width-1, // upper left
    -1, // left
    width-1, // down left
    width, // down
    width+1 // down right
  };
}

void draw()
{
  background(0);
  resetScene();
  
  while(true)
  {
    count++;
    int size = walkers.size();
    for (int i = 0; i < size; i++)
    {
      Walker walker = walkers.get(0);
      walkers.remove(0);
      if (walker.life <= 0)
      {
        continue;
      }
      int dir, pos;
      dir = walker.dir + (random(1) < 0.9 ? 0 : random(1) < 0.5 ? 1 : dirOffset.length-1);
      dir = dir % dirOffset.length;
      pos = walker.pos + dirOffset[dir];
      for (int j = 0; j < dirOffset.length; j++)
      {
        if (!occupiedPixels[pos])
        {
          Walker newWalker = new Walker(pos, walker.life-1, dir, walker.colour);
          newWalker.drawMe();
          walkers.add(newWalker);
          occupiedPixels[pos] = true;
          break;
        }
        dir = (dir + 1) % dirOffset.length;
        pos = walker.pos + dirOffset[dir];
      }
    }
    
    if (freePixels.size() <= 0)
    {
      break;
    }
    
    if (walkers.size() < max_walkers)
    {
      createStartWalker();
    }
    
    if (count % 100 == 0)
    {
      updateFreePixels();
    }
  }
  updatePixels();
  println("DRAWED");
}

void resetScene()
{
  //background(0);
  loadPixels();
  
  hueOffset = floor(random(360));
  hueStepSize = floor(random(180));
  hueStepCount = 4;
  
  count = 0;
  
  occupiedPixels = new boolean[width*height];
  for (int i = 0; i < occupiedPixels.length; i++)
  {
    occupiedPixels[i] = false;
  }
  for (int i = 0; i < width; i++)
  {
    occupiedPixels[i] = true;
    occupiedPixels[i+width*(height-1)] = true;
  }
  for (int i = 0; i < height; i++)
  {
    occupiedPixels[i*width] = true;
    occupiedPixels[(i+1)*width-1] = true;
  }
  updateFreePixels();
  walkers = new ArrayList<Walker>();
  for (int i = 0; i < init_walkers; i++)
  {
    createStartWalker();
  }
}

void createStartWalker()
{
  int pos = freePixels.get(floor(random(freePixels.size())));
  
  if (!occupiedPixels[pos])
  {
    int huu = (floor(random(hueStepCount)) * hueStepSize + hueOffset) % 360;
    int sat = round(random(50, 100));
    int bri = round(constrain(pow(random(1), 2) * 110, 10, 100));
    Walker newWalker = new Walker(pos, round(random(init_life_min, init_life_max)), floor(random(dirOffset.length)), color(huu, sat, bri));
    walkers.add(newWalker);
    newWalker.drawMe();
    occupiedPixels[pos] = true;
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

class Walker
{
  int pos, life, dir;
  color colour;
  Walker(int pos, int life, int dir, color colour)
  {
    this.pos = pos;
    this.life = life;
    this.dir = dir;
    this.colour = colour;
  }
  
  void drawMe()
  {
    pixels[pos] = colour;
  }
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
