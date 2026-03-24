PImage draw_color_glitch(PImage img, float shift_size)
{
  background(0, 0, 255);

  color left_color = color(255, 0, 0);
  color right_color = color(0, 255, 255);

  push();
  blendMode(ADD);

  tint(left_color);
  image(img, -shift_size, 0);

  tint(right_color);
  image(img, shift_size, 0);
  pop();
    
  PImage img_glitch = get();
  clear();

  return img_glitch;
}

PImage draw_shift_glitch(PImage img, float shift_size)
{
  background(0, 0, 255);
  image(img, 0, 0);
  
  for (int i = 0; i < 500; i++)
  {
    int sx = (int)random(img.width*0.5);
    int sy = (int)random(img.height*0.01);
    int x = (int)random(img.width - sx);
    int y = (int)random(img.height - sy);
    int ix = (int)(x + random(-1, 1)*shift_size);
    int iy = y;//(int)(y + random(-1, 1)*shift_size);
    
    PImage cut_img = img.get(x, y, sx, sy);
    image(cut_img, ix, iy, sx, sy);
  }
  
  PImage img_glitch = get();
  clear();
  
  return img_glitch;
}

void draw_scanline()
{
  push();
  stroke(0, 50);
  strokeWeight(1);
  for(int i = 0; i < height; i += height/200)
  {
    line(0, i, width, i);
  }
  pop();
}
