class Triangle
{
    final PVector _v1, _v2, _v3;
    TriangularPrism _tp;

    Triangle(PVector v1, PVector v2, PVector v3)
    {
        _v1 = v1;
        _v2 = v2;
        _v3 = v3;
        _tp = new TriangularPrism(v1, v2, v3);
    }

    void drawMe()
    {
        beginShape();
        myVertex(_v1);
        myVertex(_v2);
        myVertex(_v3);
        endShape(CLOSE);
    }

    void createPrism(int maxiterations)
    {
        _tp.createTrajectory((int)max((sq(random(1)) * maxiterations), 4));
    }

    void drawPrism()
    {
        if (_tp == null) { return; }
        _tp.drawMe();
    }
}

class TriangularPrism
{
    final PVector _v1, _v2, _v3;
    final PVector _vg, _normal;
    final int _seed = (int)random(65536);
    ArrayList<PVector> _verticesOffsetList;

    TriangularPrism(PVector v1, PVector v2, PVector v3)
    {
        _v1 = v1;
        _v2 = v2;
        _v3 = v3;
        _vg = PVector.add(_v1, _v2).add(_v3).div(3);
        _normal = _vg.normalize(null);
    }

    void drawMe()
    {
        if (_verticesOffsetList == null) { return; }
        float noiseOffset = noise(0, _seed);
        int len = _verticesOffsetList.size();
        pushStyle();
        for (int i = 0; i < len-1; i++)
        {
            PVector curOffset = _verticesOffsetList.get(i);
            PVector posOffset = _verticesOffsetList.get(i+1);
            float noiseScale = .015;
            float curTheta = (noise(i*noiseScale, _seed) - noiseOffset) * TAU * 2;
            float posTheta = (noise((i+1)*noiseScale, _seed) - noiseOffset) * TAU * 2;
            PVector curV1 = PVector.add(rotate3d(_v1, _normal, curTheta), curOffset);
            PVector curV2 = PVector.add(rotate3d(_v2, _normal, curTheta), curOffset);
            PVector curV3 = PVector.add(rotate3d(_v3, _normal, curTheta), curOffset);
            PVector curVg = PVector.add(curV1, curV2).add(curV2).div(3);
            PVector posV1 = PVector.add(rotate3d(_v1, _normal, posTheta), posOffset);
            PVector posV2 = PVector.add(rotate3d(_v2, _normal, posTheta), posOffset);
            PVector posV3 = PVector.add(rotate3d(_v3, _normal, posTheta), posOffset);
            PVector posVg = PVector.add(posV1, posV2).add(posV2).div(3);
            curV1 = PVector.add(curV1, PVector.sub(curVg, curV1).normalize().mult(PVector.dist(curV1, curVg)*sq(i/(float)len)));
            curV2 = PVector.add(curV2, PVector.sub(curVg, curV2).normalize().mult(PVector.dist(curV2, curVg)*sq(i/(float)len)));
            curV3 = PVector.add(curV3, PVector.sub(curVg, curV3).normalize().mult(PVector.dist(curV3, curVg)*sq(i/(float)len)));
            posV1 = PVector.add(posV1, PVector.sub(posVg, posV1).normalize().mult(PVector.dist(posV1, posVg)*sq((i+1)/(float)len)));
            posV2 = PVector.add(posV2, PVector.sub(posVg, posV2).normalize().mult(PVector.dist(posV2, posVg)*sq((i+1)/(float)len)));
            posV3 = PVector.add(posV3, PVector.sub(posVg, posV3).normalize().mult(PVector.dist(posV3, posVg)*sq((i+1)/(float)len)));
            color cStroke = #e0e0e0;
            color cFill = Mixbox.lerp(#0357dd, #ff13b8, pow(i/(len-1.), .8));

            // draw inside
            fill(cFill);
            noStroke();
            emissive(cFill);
            beginShape(QUAD_STRIP);
            myVertex(curV1); myVertex(posV1);
            myVertex(curV2); myVertex(posV2);
            myVertex(curV3); myVertex(posV3);
            myVertex(curV1); myVertex(posV1);
            endShape();

            // draw outline
            stroke(cStroke);
            noFill();
            beginShape(LINES);
            myVertex(curV1); myVertex(posV1);
            myVertex(curV2); myVertex(posV2);
            myVertex(curV3); myVertex(posV3);
            endShape();

            // close end
            stroke(cStroke);
            fill(cFill);
            if (i >= len-2)
            {
                beginShape();
                myVertex(posV1); myVertex(posV2); myVertex(posV3);
                endShape(CLOSE);
            }

            // draw sphere
            PVector cenV1 = PVector.add(curV1, posV1).div(2);
            PVector cenV2 = PVector.add(curV2, posV2).div(2);
            PVector cenV3 = PVector.add(curV3, posV3).div(2);
            float t = .5;
            fill(#ffffff);
            noStroke();
            sphereDetail(16);
            emissive(#ffffff);

            pushMatrix();
            myTranslate(PVector.mult(cenV1, t).add(PVector.mult(cenV2, 1-t)));
            sphere(PVector.dist(cenV1, cenV2)/20);
            popMatrix();

            pushMatrix();
            myTranslate(PVector.mult(cenV2, t).add(PVector.mult(cenV3, 1-t)));
            sphere(PVector.dist(cenV2, cenV3)/20);
            popMatrix();

            pushMatrix();
            myTranslate(PVector.mult(cenV3, t).add(PVector.mult(cenV1, 1-t)));
            sphere(PVector.dist(cenV3, cenV1)/20);
            popMatrix();
        }
        popStyle();
    }

    void createTrajectory(int maxiterations)
    {
        _verticesOffsetList = new ArrayList<PVector>();
        PVector lastPos = new PVector();
        float radius = PVector.dist(_v1, _vg);
        _verticesOffsetList.add(lastPos);
        for (int i = 0; i < maxiterations; i++)
        {
            float r = radius * (1 - sq(i/(float)maxiterations));
            lastPos = calcNextPos(lastPos, r/3, r/4, i);
            _verticesOffsetList.add(lastPos);
        }
    }

    PVector calcNextPos(PVector curPos, float radius, float stepLen, int iteration)
    {
        PVector tmp = new PVector(1, 0, 0);
        if (PVector.angleBetween(_normal, tmp) < 0.0174) { tmp = new PVector(0, 1, 0); }
        // u, v and normal are vertical each other
        PVector u = _normal.cross(tmp).normalize();
        PVector v = _normal.cross(u).normalize();
        
        // calculate a point on the circle which is vertical to the normal
        float noiseScale = .1;
        float r = noise(iteration * noiseScale, _seed*3) * radius;
        float t = noise(iteration * noiseScale, _seed*4) * TAU;
        PVector p = PVector.add(u.mult(r*cos(t)), v.mult(r*sin(t))).add(curPos);

        return p.add(PVector.mult(_normal, stepLen));
    }

    PVector rotate3d(PVector target, PVector dir, float theta)
    {
        Quaternion q = new Quaternion(dir, theta);
        Quaternion qi = q.inverse(null);
        Quaternion qr = q.multr(target).multreq(qi);
        return new PVector(qr.x, qr.y, qr.z);
    }
}
