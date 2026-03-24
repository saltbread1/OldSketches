class Circle
{
    final PVector _center;
    final float _radius;

    Circle(PVector center, float radius)
    {
        _center = center;
        _radius = radius;
    }

    void drawMe()
    {
        circle(_center.x, _center.y, _radius*2);
    }
}

class Quad
{
    final PVector[] _vertices = new PVector[4];
    final color[] _palette = {#a30000, #b28500, #cccc00, #008000, #008080, #000080, #68228b, #800080, #c23b8f, #b83d00, #007f4d, #5c007a};

    Quad(PVector v1, PVector v2, PVector v3, PVector v4)
    {
        _vertices[0] = v1;
        _vertices[1] = v2;
        _vertices[2] = v3;
        _vertices[3] = v4;
    }

    void drawMe(int alpha)
    {
        PVector edge1 = PVector.sub(_vertices[2], _vertices[0]);
        PVector edge2 = PVector.sub(_vertices[3], _vertices[1]);
        int num = (int)max(max(edge1.mag(), edge2.mag())/2, 5);
        pushStyle();
        beginShape(QUAD_STRIP);
        for (int i = 0; i <= num; i++)
        {
            float ratio = (float)i/(float)num;
            PVector v1 = PVector.mult(edge1, ratio).add(_vertices[0]);
            PVector v2 = PVector.mult(edge2, ratio).add(_vertices[1]);
            color c = _palette[(int)random(_palette.length)];
            noStroke();
            fill(c, alpha);
            vertex(v1.x, v1.y);
            vertex(v2.x, v2.y);
        }
        endShape();
        stroke(#ffffff, alpha);
        line(_vertices[0].x, _vertices[0].y, _vertices[2].x, _vertices[2].y);
        line(_vertices[1].x, _vertices[1].y, _vertices[3].x, _vertices[3].y);
        popStyle();
    }

    void drawMeOnlyStroke()
    {
        PVector edge1 = PVector.sub(_vertices[2], _vertices[0]);
        PVector edge2 = PVector.sub(_vertices[3], _vertices[1]);
        int num = (int)max(max(edge1.mag(), edge2.mag())/6, 5);
        pushStyle();
        stroke(#ffffff);
        beginShape(QUAD_STRIP);
        for (int i = 0; i <= num; i++)
        {
            float ratio = (float)i/(float)num;
            PVector v1 = PVector.mult(edge1, ratio).add(_vertices[0]);
            PVector v2 = PVector.mult(edge2, ratio).add(_vertices[1]);
            vertex(v1.x, v1.y);
            vertex(v2.x, v2.y);
        }
        endShape();
        popStyle();
    }
}

class CurpetsGenerator extends Circle
{
    final ArrayList<QuadCurpet> _curpetList = new ArrayList<QuadCurpet>();
    final ArrayList<Circle> _circleList = new ArrayList<Circle>();
    final int _vNum;
    final float _initTheta = random(TAU);

    CurpetsGenerator(PVector center, float radius, int vNum)
    {
        super(center, radius);
        _vNum = vNum;
        _circleList.add(this);
    }

    void createCurpets()
    {
        float theta = _initTheta;
        float dtheta = TAU/_vNum;
        for (int i = 0; i < _vNum; i++)
        {
            PVector v1 = PVector.fromAngle(theta).mult(_radius).add(_center);
            PVector v2 = PVector.fromAngle(theta+dtheta).mult(_radius).add(_center);
            Circle initCircle = new Circle(PVector.add(v1, v2).div(2), PVector.sub(v1, v2).mag()/2);
            _curpetList.add(new QuadCurpet(this, initCircle));
            _circleList.add(initCircle);
            theta += dtheta;
        }
    }

    void updateCurpets()
    {
        int sucCnt;
        do
        {
            sucCnt = 0;
            for (QuadCurpet curpet : _curpetList)
            {
                if (curpet.addCircle()) { sucCnt++; }
            }
        }
        while (sucCnt > 0);
    }

    void updateCurpets(int num)
    {
        for (int i = 0; i < num; i++)
        {
            for (QuadCurpet curpet : _curpetList) { curpet.addCircle(); }
        }
    }

    @Override
    void drawMe()
    {
        for (QuadCurpet curpet : _curpetList) { curpet.drawMe(); }
    }

    // void drawPolygon()
    // {
    //     float theta = _initTheta;
    //     float dtheta = TAU/_vNum;
    //     pushStyle();
    //     beginShape();
    //     fill(#ffffff);
    //     noStroke();
    //     for (int i = 0; i < _vNum; i++)
    //     {
    //         PVector v = PVector.fromAngle(theta).mult(_radius).add(_center);
    //         vertex(v.x, v.y);
    //         theta += dtheta;
    //     }
    //     endShape();
    //     popStyle();
    // }
}
