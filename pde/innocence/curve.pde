class Curve
{
    final float _startX, _stopX;
    final float _scaleX, _scaleY;
    final int _offset, _ankerNum;
    final float[] _randomTable;
    PVector[] _ankerPoints;

    Curve(float startX, float stopX, float scaleX, float scaleY, int offset)
    {
        _startX = startX;
        _stopX = stopX;
        _scaleX = scaleX;
        _scaleY = scaleY;
        _offset = offset;
        _ankerNum = (int)((_stopX - _startX) * 3);
        _randomTable = new float[100];
        for (int i = 0; i < 100; i++)
        {
            _randomTable[i] = random(1);
        }
    }

    float func(float x, float a, float b, float c)
    {
        int m = round(_randomTable[(int)(a*x)%_randomTable.length]);
        return m + (1-m*2) * mod(b * exp(cos(c*x)) * pow(sin(PI*a*x),3), 1);
    }

    // float func(float x, float a, float b)
    // {
    //     int m = round(_randomTable[(int)(a*x)%_randomTable.length]);
    //     return m + (1-m*2) * mod(b * pow(sin(PI*a*x), 3), 1);
    // }

    float mod(float x, float y)
    {
        return x - y * floor(x/y);
    }

    void calcAnkerPoints()
    {
        _ankerPoints = new PVector[_ankerNum];
        for (int i = 0; i < _ankerNum; i++)
        {
            float x = _startX + (_stopX - _startX) * i / (_ankerNum-1);
            float y = (func(x/_scaleX, 0.82, 2.3, 0.9) + _offset) * _scaleY;
            //float y = (func(x/_scaleX, .96, 1.9) + _offset) * _scaleY;
            _ankerPoints[i] = new PVector(x, y);
        }
    }
}

class CurveManager
{
    ArrayList<Curve> _curves;
    final float _scaleX, _scaleY;

    CurveManager(float scaleX, float scaleY, float radius)
    {
        _scaleX = scaleX;
        _scaleY = scaleY;
    }

    void createCurves()
    {
        _curves = new ArrayList<Curve>();
        for (int i = 0; i < ceil(height/_scaleY)+1; i++)
        {
            Curve c = new Curve(0, width, _scaleX, _scaleY, i);
            c.calcAnkerPoints();
            _curves.add(c);
        }
    }

    void rendering()
    {
        Render render = new Render();
        render.createVecListArray(_curves);
        PImage img = render.distanceField();
        image(img, 0, 0);
    }
}

class Render
{
    ArrayList<PVector>[][] _vecListArray;
    final int _size = 25;
    final int _iLenX = 64, _iLenY = 36;

    void createVecListArray(ArrayList<Curve> curves)
    {
        _vecListArray = new ArrayList[_iLenX][_iLenY];
        for (int i = 0; i < _iLenX; i++)
        {
            for (int j = 0; j < _iLenY; j++)
            {
                _vecListArray[i][j] = new ArrayList<PVector>();
            }
        }
        for (Curve curve : curves)
        {
            for (PVector p : curve._ankerPoints)
            {
                int ix = (int)(constrain(p.x/_size, 0, _iLenX-1));
                int iy = (int)(constrain(p.y/_size, 0, _iLenY-1));
                _vecListArray[ix][iy].add(p);
            }
        }
    }

    PImage distanceField()
    {
        PImage img = createImage(width, height, RGB);
        img.loadPixels();
        for (int x = 0; x < img.width; x++)
        {
            int ix = x/_size;
            for (int y = 0; y < img.height; y++)
            {
                int iy = y/_size;
                //float nVal = (1 + cos(calcMinDistSq(x, y, ix, iy)*.03)) / 2;
                //float nVal = acos(-cos(calcMinDistSq(x, y, ix, iy)*.03)) / PI;
                float val = 1 + calcMinDistSq(x, y, ix, iy)*.02;
                float nVal = (1 + cos(10 * PI / pow(val, .275))) / 2;
                img.pixels[x+img.width*y] = color(nVal*255);
            }
        }
        img.updatePixels();
        return img;
    }

    float calcMinDistSq(float x, float y, int ix, int iy)
    {
        float minDistSq = sq(height);
        for (int i = (int)max(ix-1, 0); i <= (int)min(ix+1, _iLenX-1); i++)
        {
            for (int j = (int)max(iy-1, 0); j <= (int)min(iy+1, _iLenY-1); j++)
            {
                for (PVector vec : _vecListArray[i][j])
                {
                    float distSq = sq(vec.x-x) + sq(vec.y-y);
                    minDistSq = min(minDistSq, distSq);
                }
            }
        }
        return minDistSq;
    }
}