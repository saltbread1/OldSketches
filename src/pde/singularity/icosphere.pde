class Icosphere
{
    final PVector _center;
    final float _radius;
    ArrayList<Triangle> _triangles;
    final color _cFill = Mixbox.lerp(#0357dd, #ff13b8, random(1));

    Icosphere(PVector center, float radius)
    {
        _center = center;
        _radius = radius;
    }

    Icosphere(float radius)
    {
        this(new PVector(width/2, height/2, 0), radius);
    }

    void icosahedron()
    {
        PVector[] vertices = new PVector[12];
        vertices[0] = new PVector(0., 0., _radius);
        float hrad = 0.;
        float vrad = atan2(1., 2.);
        for (int i = 1; i <= 5; i++)
        {
            float z = _radius * sin(vrad);
            float rxy = _radius * cos(vrad);
            vertices[i] = new PVector(rxy*cos(hrad-PI/5.), rxy*sin(hrad-PI/5.), z);
            vertices[i+5] = new PVector(rxy*cos(hrad), rxy*sin(hrad), -z);
            hrad += TAU/5.;
        }
        vertices[11] = new PVector(0., 0., -_radius);

        _triangles = new ArrayList<Triangle>();
        for (int i = 1; i <= 5; i++)
        {
            _triangles.add(new Triangle(vertices[0], vertices[i], vertices[i%5+1]));
            _triangles.add(new Triangle(vertices[i], vertices[i%5+1], vertices[i+5]));
            _triangles.add(new Triangle(vertices[i+5], vertices[i%5+1+5], vertices[i%5+1]));
            _triangles.add(new Triangle(vertices[11], vertices[i+5], vertices[i%5+1+5]));
        }
    }

    void split()
    {
        if (_triangles == null) { return; }

        int len = _triangles.size();
        for (int i = 0; i < len; i++)
        {
            Triangle t = _triangles.get(0);
            _triangles.remove(0);
            PVector newv1 = PVector.add(t._v1, t._v2).div(2.);
            PVector newv2 = PVector.add(t._v2, t._v3).div(2.);
            PVector newv3 = PVector.add(t._v3, t._v1).div(2.);
            newv1.mult(_radius / newv1.mag());
            newv2.mult(_radius / newv2.mag());
            newv3.mult(_radius / newv3.mag());
            _triangles.add(new Triangle(t._v1 , newv1, newv3));
            _triangles.add(new Triangle(newv1, t._v2 , newv2));
            _triangles.add(new Triangle(newv3, newv2, t._v3 ));
            _triangles.add(new Triangle(newv1, newv2, newv3));
        }
    }

    void drawMe()
    {
        push();
        specular(#ffffff);
        shininess(8);
        fill(_cFill, 200);
        noStroke();
        translate(_center.x, _center.y, _center.z);
        for (Triangle t : _triangles)
        {
            t.drawMe();
        }
        pop();
    }

    void prepareTriangularPrisms(int maxiterations)
    {
        for (Triangle t : _triangles)
        {
            t.createPrism(maxiterations);
        }
    }

    void drawTriangularPrisms()
    {
        pushMatrix();
        translate(_center.x, _center.y, _center.z);
        for (Triangle t : _triangles)
        {
            t.drawPrism();
        }
        popMatrix();
    }
}