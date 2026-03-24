int nx = 30, ny = 20; //48, 27
float[][][] point_arry = new float[nx][ny][2];

void setup()
{
  size(1200, 800);
  background(255);
  smooth();
}

void draw()
{
  background(255);
  setPoints();
  //grid();
  //diagonalGrid();
  oval();
  //rectangle();
}

void setPoints()
{
  float noiseScale = 0.25;
  float timeScale = 0.02;
  float deltaScale = map(mouseX, 0, width, 0, 4);
  for (int i = 0; i < nx; i++)
  {
    float dx = (float)width/(float)(nx-1);
    float x = dx*(i);
    for (int j = 0; j < ny; j++)
    {
      float dy = (float)height/(float)(ny-1);
      float y = dy*(j);
      //float noise_dx = deltaScale*dx*(1.0-2.0*noise(i*noiseScale+cos(frameCount*timeScale)+1.0, j*noiseScale+sin(frameCount*timeScale)+2.0, 0));
      //float noise_dy = deltaScale*dy*(1.0-2.0*noise(i*noiseScale+sin(frameCount*timeScale)+3.0, j*noiseScale+cos(frameCount*timeScale)+4.0, 10));
      float noise_dx = deltaScale*dx*(1.0-2.0*noise(i*noiseScale+frameCount*timeScale, j*noiseScale+frameCount*timeScale+1.0, 0));
      float noise_dy = deltaScale*dy*(1.0-2.0*noise(i*noiseScale+frameCount*timeScale+2.0, j*noiseScale+frameCount*timeScale+3.0, 10));
      point_arry[i][j] = new float[]{x+noise_dx, y+noise_dy};
    }
  }
}

void grid()
{
  for (int i = 0; i < nx; i++)
  {
    for (int j = 0; j < ny; j++)
    {
      stroke(0);
      strokeWeight(1);
      if (i+1<nx) // straight lines
      {
        line(point_arry[i][j][0], point_arry[i][j][1], point_arry[i+1][j][0], point_arry[i+1][j][1]);
      }
      if (j+1<ny)
      {
        line(point_arry[i][j][0], point_arry[i][j][1], point_arry[i][j+1][0], point_arry[i][j+1][1]);
      }
    }
  }
}

void diagonalGrid()
{
  for (int i = 0; i < nx; i++)
  {
    for (int j = 0; j < ny; j++)
    {
      // diagonal grid
      stroke(0);
      strokeWeight(1);
      if (i+1<nx && j+1<ny) // diagonal lines
      {
        line(point_arry[i][j][0], point_arry[i][j][1], point_arry[i+1][j+1][0], point_arry[i+1][j+1][1]);
        line(point_arry[i][j+1][0], point_arry[i][j+1][1], point_arry[i+1][j][0], point_arry[i+1][j][1]);
      }
    }
  }
}

void oval()
{
  for (int i = 0; i < nx; i++)
  {
    for (int j = 0; j < ny; j++)
    {
      float x, y, rx, ry;
      noStroke();
      if (i+1<nx)
      {
        x = (point_arry[i][j][0]+point_arry[i+1][j][0])/2;
        y = (point_arry[i][j][1]+point_arry[i+1][j][1])/2;
        rx = point_arry[i+1][j][0]-point_arry[i][j][0];
        ry = point_arry[i+1][j][1]-point_arry[i][j][1];
        fill(0);
        ellipse(x, y, rx, ry);
        //fill(255);
        //ellipse(x, y, rx*0.4, ry);
      }
      if (j+1<ny)
      {
        x = (point_arry[i][j][0]+point_arry[i][j+1][0])/2;
        y = (point_arry[i][j][1]+point_arry[i][j+1][1])/2;
        rx = point_arry[i][j+1][0]-point_arry[i][j][0];
        ry = point_arry[i][j+1][1]-point_arry[i][j][1];
        fill(0);
        ellipse(x, y, rx, ry);
        //fill(255);
        //ellipse(x, y, rx*0.4, ry);
      }
    }
  }
}

void rectangle()
{
  for (int i = 0; i < nx; i++)
  {
    for (int j = 0; j < ny; j++)
    {
      // rectangle
      fill(0);
      noStroke();
      if (i+1<nx)
      {
        rect(point_arry[i][j][0], point_arry[i][j][1], point_arry[i+1][j][0]-point_arry[i][j][0], point_arry[i+1][j][1]-point_arry[i][j][1]);
      }
      if (j+1<ny)
      {
        rect(point_arry[i][j][0], point_arry[i][j][1], point_arry[i][j+1][0]-point_arry[i][j][0], point_arry[i][j+1][1]-point_arry[i][j][1]);
      }
    }
  }
}

void mousePressed()
{
  saveFrame("image-####.jpg");
}
