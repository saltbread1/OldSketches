class Torus
{
    final PVector _center;
    final float _torusR, _tubeR;
    ArrayList<Quad> _faceList;

    Torus(PVector center, float torusR, float tubeR)
    {
        _center = center;
        _torusR = torusR;
        _tubeR = tubeR;
    }

    void createFaces(float start, float stop)
    {
        int resLon = round(120*abs(stop-start)/TAU);
        int resMeri = 40;
        _faceList = new ArrayList<Quad>();
        for (int i = 0; i < resLon; i++)
        {
            for (int j = 0; j < resMeri; j++)
            {
                PVector v1 = calcTorusPoint(start, stop, resLon, resMeri, i  , j  ).add(_center);
                PVector v2 = calcTorusPoint(start, stop, resLon, resMeri, i  , j+1).add(_center);
                PVector v3 = calcTorusPoint(start, stop, resLon, resMeri, i+1, j+1).add(_center);
                PVector v4 = calcTorusPoint(start, stop, resLon, resMeri, i+1, j  ).add(_center);
                _faceList.add(new Quad(v1, v2, v3, v4));
            }
        }
    }

    void fluctuateFaces()
    {
        for (Quad face : _faceList)
        {
            PVector cen = face.getCenter();
            float r = sq(random(1)) * sqrt(face.getArea()) * 6.2;
            float phi = random(TAU);
            float theta = random(PI);
            face.translate(
                    new PVector(
                        r*sin(theta)*cos(phi),
                        r*sin(theta)*sin(phi),
                        r*cos(theta) ));
        }
    }
    
    PVector calcTorusPoint(float start, float stop, int resLon, int resMeri, int iLon, int iMeri)
    {
        float t = start+(stop-start)*iLon/resLon;
        float p = TAU*iMeri/resMeri;
        float x = _torusR*cos(t)+_tubeR*cos(p)*cos(t);
        float y = _torusR*sin(t)+_tubeR*cos(p)*sin(t);
        float z = _tubeR*sin(p);
        return new PVector(x, y, z);
    }

    void drawMe()
    {
        for (Quad face : _faceList) { face.drawMe(); }
    }

    void drawMe(PGraphics pg)
    {
        for (Quad face : _faceList) { face.drawMe(pg); }
    }

    void translate(PVector dv)
    {
        _center.add(dv);
        for (Quad face : _faceList) { face.translate(dv); }
    }

    void rotate(PVector dir, float rad, PVector init)
    {
        PVector c = rotate3D(_center, dir, rad, init);
        _center.set(c.x, c.y, c.z);
        for (Quad face : _faceList) { face.rotate(dir, rad, init); }
    }
}

class Quad
{
    PVector _v1, _v2, _v3, _v4;

    Quad(PVector v1, PVector v2, PVector v3, PVector v4)
    {
        _v1 = v1;
        _v2 = v2;
        _v3 = v3;
        _v4 = v4;
    }

    void drawMe()
    {
        beginShape(QUADS);
        myVertex(_v1);
        myVertex(_v2);
        myVertex(_v3);
        myVertex(_v4);
        endShape();
    }

    void drawMe(PGraphics pg)
    {
        pg.beginShape(QUADS);
        myVertex(_v1, pg);
        myVertex(_v2, pg);
        myVertex(_v3, pg);
        myVertex(_v4, pg);
        pg.endShape();
    }

    PVector getCenter()
    {
        return PVector.add(_v1, _v2).add(_v3).add(_v4).div(4);
    }

    float[] getEdges()
    {
        float[] edges = new float[4];
        edges[0] = PVector.dist(_v1, _v2);
        edges[1] = PVector.dist(_v2, _v3);
        edges[2] = PVector.dist(_v3, _v4);
        edges[3] = PVector.dist(_v4, _v1);
        return edges;
    }

    float getArea()
    {
        float[] edges = getEdges();
        float e12 = edges[0];
        float e23 = edges[1];
        float e34 = edges[2];
        float e41 = edges[3];
        // Bretschneider's formula
        float t = (e12 + e23 + e34 + e41)/2;
        float a = PVector.angleBetween(PVector.sub(_v2, _v1), PVector.sub(_v4, _v1));
        float c = PVector.angleBetween(PVector.sub(_v2, _v3), PVector.sub(_v4, _v3));
        return sqrt( (t-e12)*(t-e23)*(t-e34)*(t-e41) - e12*e23*e34*e41*sq(cos((a+c)/2)) );
    }

    void translate(PVector dv)
    {
        _v1.add(dv);
        _v2.add(dv);
        _v3.add(dv);
        _v4.add(dv);
    }

    void rotate(PVector dir, float rad, PVector init)
    {
        _v1 = rotate3D(_v1, dir, rad, init);
        _v2 = rotate3D(_v2, dir, rad, init);
        _v3 = rotate3D(_v3, dir, rad, init);
        _v4 = rotate3D(_v4, dir, rad, init);
    }
}

class TorusCurve
{
    final Torus _initTorus;
    final float _baseTorusR;
    final ArrayList<Torus> _torusList;
    final color _colour;
    final color[] _palette = {#00bfff, #87ceeb, #add8e6, #00ced1, #4682b4, #1e90ff, #6495ed, #87cefa};

    TorusCurve(Torus initTorus, float baseTorusR)
    {
        _initTorus = initTorus;
        _baseTorusR = baseTorusR;
        _torusList = new ArrayList<Torus>();
        _colour = _palette[(int)random(_palette.length)];
    }

    void createTorusList(int n)
    {
        _torusList.add(_initTorus);
        for (int i = 0; i < n; i++)
        {
            if (!addTorus(100)) { break; }
        }
        //while (addTorus(100));
        setupToruses();
    }

    boolean addTorus(int maxTrialIterations)
    {
        Torus preTorus = _torusList.get(_torusList.size()-1);
        for (int i = 1; i < maxTrialIterations; i++)
        {
            float noiseScale = .1;
            float newTorusR = random(.5, 2) * _baseTorusR;
            float r = preTorus._torusR + newTorusR;
            PVector center = PVector.random2D().mult(r).add(preTorus._center);
            Torus newTorus = new Torus(center, newTorusR, preTorus._tubeR);
            if (!isOverlap(newTorus))
            {
                _torusList.add(newTorus);
                return true;
            }
        }
        return false;
    }

    boolean isOverlap(Torus torus)
    {
        for (int i = 0; i < _torusList.size()-1; i++)
        {
            Torus other = _torusList.get(i);
            float r1 = torus._torusR + torus._tubeR;
            float r2 = other._torusR + other._tubeR;
            float d = PVector.dist(torus._center, other._center);
            if (r1 + r2 > d) { return true; }
        }
        return false;
    }

    void setupToruses()
    {
        int rem = (int)random(2);
        for (int i = 0; i < _torusList.size(); i++)
        {
            Torus torus = _torusList.get(i);
            float theta1 = i == 0 ? 0 : PVector.sub(_torusList.get(i-1)._center, torus._center).heading();
            float theta2 = i < _torusList.size()-1
                    ? PVector.sub(_torusList.get(i+1)._center, torus._center).heading()
                    : i%2 == rem
                    ? theta1+HALF_PI
                    : theta1-HALF_PI;
            if (i == 0) { theta1 = i%2 == rem ? theta2 - HALF_PI : theta2 + HALF_PI; }
            float start = i%2 == rem ? theta1 : theta2;
            float stop = i%2 == rem ? theta2 : theta1;
            if (start > stop) { stop += TAU; }
            torus.createFaces(start, stop);
            torus.fluctuateFaces();
        }

        for (int i = _torusList.size()-1; i > 0; i--)
        {
            Torus torus = _torusList.get(i);
            PVector a = PVector.sub(_torusList.get(i-1)._center, torus._center).normalize();
            PVector dir = a.cross(new PVector(0, 0, 1));
            PVector init = PVector.mult(a, torus._torusR).add(torus._center);
            //float[] rads = {-HALF_PI, 0, HALF_PI};
            //float rad = rads[(int)random(rads.length)];
            float rad = i == 1 ? random(TAU) : random(-1,1) * PI*.42;
            for (int j = i; j < _torusList.size(); j++) { _torusList.get(j).rotate(dir, rad, init); }
        }
        _torusList.remove(0);
    }

    void drawToruses()
    {
        for (Torus torus : _torusList) { torus.drawMe(); }
    }

    void drawToruses(PGraphics pg)
    {
        _pg.pushStyle();
        _pg.noStroke();
        _pg.fill(_colour);
        for (Torus torus : _torusList) { torus.drawMe(pg); }
        _pg.popStyle();
    }
}