class CircleGenerator
{
    final Circle _start;
    final float _maxRadius;
    ArrayList<Circle> _circlelist;

    CircleGenerator(Circle start)
    {
        _start = start;
        _maxRadius = _start._radius*.1;
    }

    CircleGenerator(float maxRadius)
    {
        _maxRadius = maxRadius;
        _start = createCircle();
    }

    void createCircleList()
    {
        _circlelist = new ArrayList<Circle>();
        _circlelist.add(_start);
        while (addCircle(150));
    }

    boolean addCircle(int maxiterations)
    {
        for (int i = 0; i < maxiterations; i++)
        {
            Circle newCirc = createCircle();
            if (!isOverlap(newCirc))
            {
                _circlelist.add(newCirc);
                return true;
            }
        }
        return false;
    }

    Circle createCircle()
    {
        PVector c = new PVector(random(width), random(height));
        float r = sq(random(1))*_maxRadius;
        //return new RectCircle(c, r);
        return r > 28 ? new RectCircle0(c, r) : r > 12 ? new RectCircle1(c, r) : new Circle(c, r);
    }

    boolean isOverlap(Circle newCirc)
    {
        for (Circle other : _circlelist)
        {
            float d = PVector.dist(other._center, newCirc._center);
            if (d < other._radius + newCirc._radius)
            {
                return true;
            }
        }
        return false;
    }

    void drawMe()
    {
        for (Circle circle : _circlelist) { circle.drawMe(); }
    }
}

class Circle
{
    final PVector _center;
    final float _radius;
    final color[] _palette = {#9f664b, #3e4e7c, #d16d67, #529c66, #aa548f, #7c8463, #c49c3d, #628b90};
    final color _colour;
    final int _seed = (int)random(65536);

    Circle(PVector center, float radius, color colour)
    {
        _center = center;
        _radius = radius;
        _colour = colour;
    }

    Circle(PVector center, float radius)
    {
        _center = center;
        _radius = radius;
        _colour = _palette[(int)random(_palette.length)];
    }

    void drawMe()
    {
        pushStyle();
        noFill();
        stroke(_colour, 160);
        // noStroke();
        // fill(_colour, 180);
        circle(_center.x, _center.y, _radius*2);
        popStyle();
    }
}

class Circle3D extends Circle
{
    final PVector _height;

    Circle3D(PVector center, float radius, color colour)
    {
        super(center, radius, colour);
        PVector offset = PVector.random2D().mult(_radius*4);
        _height = new PVector(0, 0, radius*20).add(offset);
    }

    Circle3D(PVector center, float radius)
    {
        super(center, radius);
        PVector offset = PVector.random2D().mult(_radius*4);
        _height = new PVector(0, 0, radius*20).add(offset);
    }

    @Override
    void drawMe()
    {
        int num = 8;//(int)(max(_radius*.4, 16));

        pushStyle();
        // fill(_colour, 200);
        // noStroke();
        fill(#000000);
        stroke(_colour, 120);
        beginShape(TRIANGLE_FAN);
        myVertex(PVector.add(_center, _height));
        for (int i = 0; i <= num; i++)
        {
            PVector v1 = PVector.fromAngle(TAU*i/num).mult(_radius).add(_center);
            //PVector v2 = PVector.fromAngle(TAU*(i+1)/num).mult(_radius).add(_center);
            myVertex(v1);
            //myVertex(v1.add(h));
            //myVertex(v2);
            //myVertex(v2.add(h));
        }
        endShape();
        popStyle();
    }
}

// class NoiseCircle extends Circle
// {
//     PVector[] _vertices;

//     NoiseCircle(PVector center, float radius)
//     {
//         super(center, radius);
//         createVertices();
//     }

//     void createVertices()
//     {
//         int num = (int)(max(_radius*.4, 16));
//         _vertices = new PVector[num];

//         for (int i = 0; i < num; i++)
//         {
//             float t = TAU*i/num;
//             float r = _radius * (.6 + myNoise(t, num*.01, _seed)*.4);
//             _vertices[i] = PVector.fromAngle(t).mult(r).add(_center);
//         }
//     }

//     @Override
//     void drawMe()
//     {
//         pushStyle();
//         noFill();
//         stroke(_colour, 180);
//         beginShape();
//         for (PVector v : _vertices) { myVertex(v); }
//         endShape();
//         popStyle();
//     }
// }

abstract class RectCircle extends Circle
{
    final int _num;
    final color[] _colours;
    ArrayList<Rect> _rectList;

    // RectCircle(PVector center, float radius, int num)
    // {
    //     super(center, radius);
    //     _num = num;
    //     _colours = new color[_num];
    //     for (int i = 0; i < _num; i++)
    //     {
    //         _colours[i] = _colour;//_palette[(int)random(_palette.length)];
    //     }
    //     createRectList();
    // }

    // RectCircle(float radius, int num)
    // {
    //     this(new PVector(width/2, height/2), radius, num);
    // }

    RectCircle(PVector center, float radius)
    {
        //this(center, radius, (int)max(sqrt(radius)*5, 10));
        super(center, radius);
        _num = (int)max(sqrt(radius)*5, 10);
        _colours = new color[_num];
        for (int i = 0; i < _num; i++)
        {
            _colours[i] = _colour;
        }
        createRectList();
    }

    abstract void createRectList();

    @Override
    void drawMe()
    {
        for (Rect rect : _rectList) { rect.drawMe(); }
    }

    float myNoise(float val, float scale, float seed)
    {
        return noise((cos(val)+1)*scale, (sin(val)+2)*scale, seed);
    }
}

class RectCircle0 extends RectCircle
{
    RectCircle0(PVector center, float radius)
    {
        super(center, radius);
    }

    @Override
    void createRectList()
    {
        // calculate heights of rects
        float[] heights = new float[_num];
        float maxHeight = 0;
        for (int i = 0; i < _num; i++)
        {
            //float h = _radius * (.12 + sq(random(1))*.6);
            //float h = abs(randomGaussian())*_radius*.34+8;
            float h = _radius * (.28 + myNoise(TAU*i/_num, _num*.072, _seed)*.66);
            heights[i] = h;
            if (h > maxHeight) { maxHeight = h; }
        }

        _rectList = new ArrayList<Rect>();
        float minorRadius = _radius - maxHeight;
        for (int i = 0; i < _num; i++)
        {
            float rad = TAU/_num*i;
            PVector dir = PVector.fromAngle(rad);
            PVector dirHeight = PVector.mult(dir, -heights[i]);
            PVector dirMaxHeight = PVector.mult(dir, maxHeight);
            PVector v1 = PVector.fromAngle(rad - PI/_num).mult(minorRadius).add(dirMaxHeight).add(_center);
            PVector v2 = PVector.fromAngle(rad + PI/_num).mult(minorRadius).add(dirMaxHeight).add(_center);
            Rect rect = new Rect0(v1, v2, dirHeight, _colours[i]);
            _rectList.add(rect);
        }
    }
}

class RectCircle1 extends RectCircle
{
    Circle3D _circle3D;

    RectCircle1(PVector center, float radius)
    {
        super(center, radius);
    }

    @Override
    void createRectList()
    {
        _rectList = new ArrayList<Rect>();
        float height = _radius*.5;
        float minorRadius = _radius - height;
        for (int i = 0; i < _num; i++)
        {
            float rad = TAU/_num*i;
            PVector dir = PVector.fromAngle(rad);
            PVector dirHeight = PVector.mult(dir, -height);
            PVector dirMaxHeight = PVector.mult(dir, height);
            PVector v1 = PVector.fromAngle(rad - PI/_num).mult(minorRadius).add(dirMaxHeight).add(_center);
            PVector v2 = PVector.fromAngle(rad + PI/_num).mult(minorRadius).add(dirMaxHeight).add(_center);
            Rect rect = new Rect1(v1, v2, dirHeight, _colours[i]);
            _rectList.add(rect);
        }

        _circle3D = new Circle3D(_center, minorRadius, _colour);
    }

    @Override
    void drawMe()
    {
        for (Rect rect : _rectList) { rect.drawMe(); }
        _circle3D.drawMe();
    }
}

abstract class Rect
{
    final PVector _v1, _v2, _v3, _v4;
    final color _colour;

    Rect(PVector v1, PVector v2, PVector dirHeight, color colour)
    {
        _v1 = v1;
        _v2 = v2;
        _v3 = PVector.add(_v2, dirHeight);
        _v4 = PVector.add(_v1, dirHeight);
        _colour = colour;
    }

    abstract void drawMe();
}

class Rect0 extends Rect
{
    Rect0(PVector v1, PVector v2, PVector dirHeight, color colour)
    {
        super(v1, v2, dirHeight, colour);
    }

    void drawMe()
    {
        pushStyle();
        noStroke();
        beginShape();
        fill(#000000, 100);
        myVertex(_v1);
        myVertex(_v2);
        fill(_colour, 180);
        myVertex(_v3);
        myVertex(_v4);
        endShape();
        popStyle();
    }
}

class Rect1 extends Rect
{
    Rect1(PVector v1, PVector v2, PVector dirHeight, color colour)
    {
        super(v1, v2, dirHeight, colour);
    }

    void drawMe()
    {
        pushStyle();
        noStroke();
        beginShape();
        fill(_colour, 220);
        myVertex(_v1);
        myVertex(_v2);
        fill(#000000, 160);
        myVertex(_v3);
        myVertex(_v4);
        endShape();
        popStyle();
    }
}