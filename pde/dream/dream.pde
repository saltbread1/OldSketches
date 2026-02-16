// chaining rects variable
ArrayList<Circle> circles;
float min_r = 5;
float max_r = 100;

// pixel filler variables
boolean occupiedPixels[];
IntList freePixels;
ArrayList<ActivePixel> activePixels;
int fcount;
int hueOffset, hueStepSize, hueStepCount;
int[]  pixelDirectionOffsets;

void setup()
{
  size(1600, 900);
  background(255);
  noSmooth();
  noLoop();
  colorMode(HSB, 360, 100, 100);
  
  pixelDirectionOffsets = new int[]
    {
      -width, // up
      -width+1, // up right
      1, // right
      width+1, // down right
      width, // down
      width-1, // down left
      -1, // left
      -width-1 // up left
    };
}

void draw()
{
  background(360);
  
  // rects : create chaining circle and use their center and radius for rects' parameters
  int cnt1 = 50;
  int cnt2 = 1000;
  circles = new ArrayList<Circle>();
  while (--cnt2 > 0)
  {
    float x = random(max_r, width-max_r);
    float y = random(max_r, height-max_r);
    if (!overlapCheck(x, y, min_r))
    {
      continue;
    }
    createChainCircles(x, y, min_r, (int)random(1, 20));
    if (--cnt1 <= 0)
    {
      break;
    }
  }
  
  // pixel filler
  initializePixelFiller();
  drawPixelFiller();
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
