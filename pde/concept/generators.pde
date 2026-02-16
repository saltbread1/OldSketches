abstract class RandomCircleGenerator<T extends Circle>
{
    final ArrayList<T> _circleList = new ArrayList<T>();
    final T _initCircle;

    RandomCircleGenerator(T initCircle)
    {
        _initCircle = initCircle;
        _circleList.add(initCircle);
    }

    abstract void drawMe();

    abstract boolean addCircle();

    abstract boolean isOverlap(T newCircle, ArrayList<T> circleList);
}

class CurpetsGG extends RandomCircleGenerator<CurpetsGenerator>
{
    CurpetsGG(CurpetsGenerator initGen)
    {
        super(initGen);
    }

    void prepareDrawing()
    {
        for (CurpetsGenerator gen : _circleList)
        {
            for (CurpetsGenerator other : _circleList)
            {
                if (other.equals(gen)) { continue; }
                gen._circleList.add(other);
            }
        }
        for (CurpetsGenerator gen : _circleList) { gen.createCurpets(); }
        for (CurpetsGenerator gen : _circleList) { gen.updateCurpets(); }
    }

    @Override
    void drawMe()
    {
        for (CurpetsGenerator gen : _circleList) { gen.drawMe(); }
        //for (CurpetsGenerator gen : _circleList) { gen.drawPolygon(); }
    }

    @Override
    boolean addCircle()
    {
        for (int i = 0; i < 100; i++)
        {
            float radius = map(sq(random(1)), 0, 1, _initCircle._radius*.2, _initCircle._radius*2);
            PVector center = new PVector(random(width), random(height));
            CurpetsGenerator newGen = new CurpetsGenerator(center, radius, (int)random(3, 10));
            if (!isOverlap(newGen, _circleList))
            {
                _circleList.add(newGen);
                return true;
            }
        }
        return false;
    }

    @Override
    boolean isOverlap(CurpetsGenerator newGen, ArrayList<CurpetsGenerator> genList)
    {
        for (CurpetsGenerator gen : genList)
        {
            float d = PVector.dist(gen._center, newGen._center);
            if ((gen._radius + newGen._radius)*3 > d)
            {
                return true;
            }
        }
        return false;
    }
}

class QuadCurpet extends RandomCircleGenerator<Circle>
{
    final CurpetsGenerator _parentCircle;

    QuadCurpet(CurpetsGenerator parentCircle, Circle initCircle)
    {
        super(initCircle);
        _parentCircle = parentCircle;
    }

    @Override
    void drawMe()
    {
        //_circleList.get(0).drawMe();
        for (int i = 0; i < _circleList.size()-1; i++)
        {
            Circle preCircle = i == 0 ? _parentCircle : _circleList.get(i-1);
            Circle curCircle = _circleList.get(i);
            Circle exCircle = _circleList.get(i+1);
            PVector[] p1 = calcOverlappedPoint(preCircle, curCircle);
            PVector[] p2 = calcOverlappedPoint(curCircle, exCircle);
            Quad quad = new Quad(p1[0], p1[1], p2[0], p2[1]);
            int alpha = (int)map(i, 0, _circleList.size()-1, 250, 0);
            quad.drawMe(alpha);
            //curCircle.drawMe();
        }
        //_circleList.get(_circleList.size()-1).drawMe();
    }

    PVector[] calcOverlappedPoint(Circle circle1, Circle circle2)
    {
        PVector c1 = circle1._center;
        PVector c2 = circle2._center;
        float r1 = circle1._radius;
        float r2 = circle2._radius;
        PVector sub = PVector.sub(c2, c1);
        float rad = acos((sq(r1)-sq(r2)+sub.magSq())/(2*r1*sub.mag()));
        PVector[] ret = new PVector[2];
        sub.normalize().mult(r1);
        ret[0] = sub.copy().rotate(rad).add(c1);
        ret[1] = sub.rotate(-rad).add(c1);
        return ret;
    }

    @Override
    boolean addCircle()
    {
        Circle preCircle = _circleList.get(_circleList.size()-1);
        for (int i = 0; i < 100; i++)
        {
            float radius = map(sq(random(1)), 0, 1, _initCircle._radius*.4, _initCircle._radius*2);
            float r = max(preCircle._radius, radius) + min(preCircle._radius, radius)*random(.1, .5);
            PVector center = PVector.random2D().mult(r).add(preCircle._center);
            Circle newCircle = new Circle(center, radius);
            if (!isOverlap(newCircle, _parentCircle._circleList))
            {
                _circleList.add(newCircle);
                _parentCircle._circleList.add(newCircle);
                return true;
            }
        }
        return false;
    }

    @Override
    boolean isOverlap(Circle newCircle, ArrayList<Circle> circleList)
    {
        for (Circle circle : circleList)
        {
            Circle preCircle = _circleList.get(_circleList.size()-1);
            if (circle.equals(preCircle)) { continue; }
            float d = PVector.dist(circle._center, newCircle._center);
            if (circle._radius + newCircle._radius > d)
            {
                return true;
            }
        }
        return false;
    }
}