class Icosphere
{
    float radius;
    int subdivision;
    ArrayList<Triangle> triangles;
    final float maxDist;

    Icosphere(float radius, int subdivision)
    {
        this.radius = radius;
        this.subdivision = subdivision;
        this.maxDist = radius*10.;
        initialize();
    }

    void initialize()
    {
        icosahedron();
        for (int i = 0; i < subdivision; i++) { split(); }
    }

    void icosahedron()
    {
        PVector[] vertices = new PVector[12];
        vertices[0] = new PVector(0., 0., radius);
        float hrad = 0.;
        float vrad = atan2(1., 2.);
        for (int i = 1; i <= 5; i++)
        {
            float z = radius * sin(vrad);
            float rxy = radius * cos(vrad);
            vertices[i] = new PVector(rxy*cos(hrad-PI/5.), rxy*sin(hrad-PI/5.), z);
            vertices[i+5] = new PVector(rxy*cos(hrad), rxy*sin(hrad), -z);
            hrad += TAU/5.;
        }
        vertices[11] = new PVector(0., 0., -radius);

        triangles = new ArrayList<Triangle>();
        for (int i = 1; i <= 5; i++)
        {
            triangles.add(new Triangle(vertices[0], vertices[i], vertices[i%5+1]));
            triangles.add(new Triangle(vertices[i], vertices[i%5+1], vertices[i+5]));
            triangles.add(new Triangle(vertices[i+5], vertices[i%5+1+5], vertices[i%5+1]));
            triangles.add(new Triangle(vertices[11], vertices[i+5], vertices[i%5+1+5]));
        }
    }

    void split()
    {
        int len = triangles.size();
        for (int i = 0; i < len; i++)
        {
            Triangle t = triangles.get(0);
            triangles.remove(0);
            PVector newv1 = PVector.add(t.v1, t.v2).div(2.);
            PVector newv2 = PVector.add(t.v2, t.v3).div(2.);
            PVector newv3 = PVector.add(t.v3, t.v1).div(2.);
            newv1.mult(radius / newv1.mag());
            newv2.mult(radius / newv2.mag());
            newv3.mult(radius / newv3.mag());
            triangles.add(new Triangle(t.v1 , newv1, newv3));
            triangles.add(new Triangle(newv1, t.v2 , newv2));
            triangles.add(new Triangle(newv3, newv2, t.v3 ));
            //triangles.add(new Triangle(newv1, newv2, newv3));
        }
    }

    void drawProjection()
    {
        pushMatrix();
        translate(width/2, height/2);
        for (Triangle t : triangles)
        {
            PVector v1 = projectionMapping(t.v1);
            PVector v2 = projectionMapping(t.v2);
            PVector v3 = projectionMapping(t.v3);
            if (PVector.dist(v1, v2) < maxDist && PVector.dist(v2, v3) < maxDist && PVector.dist(v3, v1) < maxDist)
            {
                new Triangle(v1, v2, v3).drawMe();
            }
        }
        popMatrix();
    }

    PVector projectionMapping(PVector v)
    {
        PVector v0 = new PVector(0., 0., -radius);
        float k = v0.z/(v0.z-v.z);
        return new PVector(v0.x+k*(v.x-v0.x), v0.y+k*(v.y-v0.y), 0.);
    }

    void rotate(PVector dir, float theta)
    {
        Quaternion q = new Quaternion(dir, theta);
        Quaternion qi = q.inverse(null);
        for (Triangle t : triangles)
        {
            Quaternion p1 = q.multr(t.v1).multreq(qi);
            Quaternion p2 = q.multr(t.v2).multreq(qi);
            Quaternion p3 = q.multr(t.v3).multreq(qi);
            PVector v1 = new PVector(p1.x, p1.y, p1.z);
            PVector v2 = new PVector(p2.x, p2.y, p2.z);
            PVector v3 = new PVector(p3.x, p3.y, p3.z);
            t.setVertices(v1, v2, v3);
        }
    }
}