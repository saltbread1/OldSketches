class Torus
{
  float r_large, r_minor, detail;
  int num_longi, num_meri;
  PVector[][] points, points_cen;
  
  Torus(float r_large, float r_minor, float detail)
  {
    this.r_large = r_large;
    this.r_minor = r_minor;
    this.detail = detail;
    num_longi = round(r_large*detail);
    num_meri = round(r_minor*detail);
    points = new PVector[num_longi][num_meri];
    points_cen = new PVector[num_longi][num_meri];
    
    // get points on the torus
    for (int i = 0; i < num_longi; i++) // longitude
    {
      float theta = map(i, 0, num_longi, 0, TWO_PI);
      for (int j = 0; j < num_meri; j++) // meridian
      {
        float phi = map(j, 0, num_meri, 0, TWO_PI);
        points[i][j] = new PVector(r_large*cos(theta)+r_minor*cos(phi)*cos(theta),
          r_minor*sin(phi), r_large*sin(theta)+r_minor*cos(phi)*sin(theta));
        points_cen[i][j] = new PVector(r_large*cos(theta), 0, r_large*sin(theta));
      }
    }
  }
  
  void drawMe()
  {
    // create plenes and attach texture to them
    for (int i = 0; i < num_longi; i++) // longitude
    {
      for (int j = 0; j < num_meri; j++) // meridian
      {
        float phi = map(j, 0, num_meri, 0, TWO_PI);
        float val_c = map(noise(i*0.05, sin(phi)+1), 0, 1, 0, 255);
        float val_a = random(-0.15, 0.15); //-0.07;map(noise(i*0.05, sin(phi)+1), 0, 1, -0.5, 0.2);
        if (val_a < 0) val_a = -0.07;
        
        drawPyramid(points[(i+1)%num_longi][j], points[i][j], points[i][(j+1)%num_meri], points[(i+1)%num_longi][(j+1)%num_meri],
          points_cen[(i+1)%num_longi][j], points_cen[i][j], points_cen[i][(j+1)%num_meri], points_cen[(i+1)%num_longi][(j+1)%num_meri], val_a, val_c);
      }
    }
  }
  
  void drawPyramid(PVector pos_d0, PVector pos_d1, PVector pos_d2, PVector pos_d3, PVector pos_u0, PVector pos_u1, PVector pos_u2, PVector pos_u3, float a, float val_c)
  {
    PVector pos2_u0 = (((pos_u0.copy()).sub(pos_d0)).mult(a)).add(pos_d0);
    PVector pos2_u1 = (((pos_u1.copy()).sub(pos_d1)).mult(a)).add(pos_d1);
    PVector pos2_u2 = (((pos_u2.copy()).sub(pos_d2)).mult(a)).add(pos_d2);
    PVector pos2_u3 = (((pos_u3.copy()).sub(pos_d3)).mult(a)).add(pos_d3);
    PVector pos_cen = ((pos_d0.copy()).add(pos2_u2)).div(2);
    
    noStroke();
    fill(50, 200, val_c);
    // create planes
    // up
    beginShape();
    vertex(pos2_u0.x, pos2_u0.y, pos2_u0.z);
    vertex(pos2_u1.x, pos2_u1.y, pos2_u1.z);
    vertex(pos2_u2.x, pos2_u2.y, pos2_u2.z);
    vertex(pos2_u3.x, pos2_u3.y, pos2_u3.z);
    endShape(OPEN);
    
    // side0
    beginShape();
    vertex(pos_d0.x, pos_d0.y, pos_d0.z);
    vertex(pos2_u0.x, pos2_u0.y, pos2_u0.z);
    vertex(pos2_u1.x, pos2_u1.y, pos2_u1.z);
    vertex(pos_d1.x, pos_d1.y, pos_d1.z);
    endShape(OPEN);
    
    // side1
    beginShape();
    vertex(pos_d1.x, pos_d1.y, pos_d1.z);
    vertex(pos2_u1.x, pos2_u1.y, pos2_u1.z);
    vertex(pos2_u2.x, pos2_u2.y, pos2_u2.z);
    vertex(pos_d2.x, pos_d2.y, pos_d2.z);
    endShape(OPEN);
    
    // side2
    beginShape();
    vertex(pos_d2.x, pos_d2.y, pos_d2.z);
    vertex(pos2_u2.x, pos2_u2.y, pos2_u2.z);
    vertex(pos2_u3.x, pos2_u3.y, pos2_u3.z);
    vertex(pos_d3.x, pos_d3.y, pos_d3.z);
    endShape(OPEN);
    
    // side3
    beginShape();
    vertex(pos_d3.x, pos_d3.y, pos_d3.z);
    vertex(pos2_u3.x, pos2_u3.y, pos2_u3.z);
    vertex(pos2_u0.x, pos2_u0.y, pos2_u0.z);
    vertex(pos_d0.x, pos_d0.y, pos_d0.z);
    endShape(OPEN);
    
    if (a < 0)
    {
      noStroke();
      fill(0, 200, val_c*0.7);
      pushMatrix();
      translate(pos_cen.x, pos_cen.y, pos_cen.z);
      sphere(4.5);
      popMatrix();
    }
  }
}
