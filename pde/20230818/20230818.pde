import java.util.Collections;
import java.util.Comparator;

BezierGenerator _bg;
int _randomSeed;

void setup()
{
    size(1920, 1080);
    smooth();
    initialize();
}

void initialize()
{
    seedSettings();
    _bg = new BezierGenerator();
    _bg.createBeziers(200);
}

void draw()
{
    clearScene();
    _bg.drawBeziers();
}

void keyPressed()
{
    if (key == 's' || key == 'S') { saveImage(); }
    else if (key == 'r' || key == 'R') { initialize(); redraw(); }
}

String timestamp()
{
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) 
        + "_"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    return timestamp;
}

void clearScene() { background(#ffffff); }

void saveImage() { saveFrame(timestamp() + "_" + _randomSeed + "_####.png"); }

void seedSettings()
{
    _randomSeed = (int)random(65536);
    println("randomSeed: " + _randomSeed);
    randomSeed(_randomSeed); // 12204
}

enum BezierType
{
    STROKE,
    FILL,
}

class BinaryBezier
{
    Bezier _root;
    float _stepRad;
    final color _c1, _c2;
    BezierType _type;

    class Bezier
    {
        final PVector _start, _control1, _control2, _goal;
        final Bezier _parent;
        final ArrayList<Bezier> _children;

        Bezier(PVector start, PVector control1, PVector control2, PVector goal, Bezier parent)
        {
            _start = start;
            _control1 = control1;
            _control2 = control2;
            _goal = goal;
            _parent = parent;
            _children = new ArrayList<Bezier>();
        }

        Bezier(PVector start, PVector control1, PVector control2, PVector goal)
        {
            _start = start;
            _control1 = control1;
            _control2 = control2;
            _goal = goal;
            _parent = null;
            _children = new ArrayList<Bezier>();
        }

        boolean drawMe(color c1, color c2, BezierType type)
        {
            FloatList param = getBeizerPoints(4);
            if (param == null) { return false; }
            pushStyle();
            for (int i = 0; i < param.size()-1; i++)
            {
                float t1 = param.get(i);
                float t2 = param.get(i+1);
                color c = lerpColor(c1, c2, t2);
                switch (type)
                {
                    case STROKE:
                        stroke(c);
                        noFill();
                        break;
                    case FILL:
                        noStroke();
                        fill(c);
                        break;

                }
                // line( bezierPoint(_start.x, _control1.x, _control2.x, _goal.x, t1),
                //       bezierPoint(_start.y, _control1.y, _control2.y, _goal.y, t1),
                //       bezierPoint(_start.x, _control1.x, _control2.x, _goal.x, t2),
                //       bezierPoint(_start.y, _control1.y, _control2.y, _goal.y, t2) );
                circle( bezierPoint(_start.x, _control1.x, _control2.x, _goal.x, t1),
                        bezierPoint(_start.y, _control1.y, _control2.y, _goal.y, t1),
                        calcLength(20)*.1 );
            }
            popStyle();
            return true;
        }

        void addChild(Bezier child) { _children.add(child); }

        ArrayList<Bezier> getChildren() { return _children; }

        float calcLength(float n)
        {
            float l = 0;
            for (int i = 0; i < n; i++)
            {
                float t1 = (float)i/n;
                float t2 = (float)(i+1)/n;
                float x1 = bezierPoint(_start.x, _control1.x, _control2.x, _goal.x, t1);
                float y1 = bezierPoint(_start.y, _control1.y, _control2.y, _goal.y, t1);
                float x2 = bezierPoint(_start.x, _control1.x, _control2.x, _goal.x, t2);
                float y2 = bezierPoint(_start.y, _control1.y, _control2.y, _goal.y, t2);
                l += dist(x1, y1, x2, y2);
            }
            return l;
        }

        FloatList getBeizerPoints(float dl)
        {
            FloatList params = new FloatList();
            float l = calcLength((int)max(PVector.dist(_start, _goal)*.2, 1));
            int n = (int)(l/dl);
            if (n < 1) { return null; }
            float stepDist = l/n;
            int m = n*8;
            float x = _start.x;
            float y = _start.y;
            int c = 0;
            params.append(0);
            for (int i = 1; i < m; i++)
            {
                float t = (float)i/m;
                float x0 = bezierPoint(_start.x, _control1.x, _control2.x, _goal.x, t);
                float y0 = bezierPoint(_start.y, _control1.y, _control2.y, _goal.y, t);
                if (dist(x, y, x0, y0) > stepDist)
                {
                    x = x0;
                    y = y0;
                    params.append(t);
                }
            }
            params.append(1);

            return params;
        }
    }

    BinaryBezier(color c1, color c2, BezierType type, float stepRad)
    {
        _c1 = c1;
        _c2 = c2;
        _type = type;
        _stepRad = stepRad;
    }

    Bezier createNextBranch(float length, PVector start, PVector preControl2, Bezier parent)
    {
        float k1 = random(length*.32, length*.48); // length of start to control1
        float k2 = random(k1*1.6, length*.81); // length of start to control2

        PVector d = PVector.fromAngle(_stepRad); // direction of start to goal
        PVector control1 = preControl2 == null
                ? PVector.mult(d, k1).rotate(random(PI*.16, PI*.41)*(1-(int)random(2)*2)).add(start)
                : PVector.sub(start, preControl2).normalize().mult(k1).add(start);
        
        float rad = PVector.angleBetween(d, PVector.sub(control1, start));
        PVector control2 = PVector.mult(d, k2).rotate(random(rad*.23, rad*.79)*(1-(int)random(2)*2)).add(start);
        PVector goal = PVector.add(start, PVector.mult(d, length));

        _stepRad += random(-1,1)*PI*.38;

        return new Bezier(start, control1, control2, goal, parent);
    }

    void createBranchTree(float length, float ratio, PVector start, PVector preControl2, Bezier parent)
    {
        if (length < 16) { return; }
        Bezier branch = null;
        if (parent == null)
        {
            _root = createNextBranch(length, start, null, null);
            branch = _root;
        }
        else
        {
            branch = createNextBranch(length, start, preControl2, parent);
            parent.addChild(branch);
        }
        createBranchTree(length*ratio, ratio, branch._goal, branch._control2, branch);
        createBranchTree(length*ratio, ratio, branch._goal, branch._control2, branch);
    }

    void drawMe()
    {
        int h = getTreeHeight(_root, 0);
        drawMeR(_root, h, 0);
    }

    void drawMeR(Bezier b, int h, int i)
    {
        color lc1 = lerpColor(_c1, _c2, (i+0.)/h);
        color lc2 = lerpColor(_c1, _c2, (i+1.)/h);
        b.drawMe(lc1, lc2, _type);
        for (Bezier child : b.getChildren()) { drawMeR(child, h, i+1); }
    }

    int getTreeHeight(Bezier b, int h)
    {
        if (b.getChildren().size() == 0) { return h; }
        return getTreeHeight(b.getChildren().get(0), h+1);
    }

    float getLength()
    {
        return getLengthR(_root);
    }

    float getLengthR(Bezier b)
    {
        float a = b.calcLength(20);
        for (Bezier child : b.getChildren()) { a += getLengthR(child); }
        return a;
    }

    float getRootLength()
    {
        return _root.calcLength(20);
    }
}

class BezierGenerator
{
    ArrayList<BinaryBezier> _branchList;
    final color[] _palette = {#060606, #4b0082, #1e482a, #992c1d, #802c00, #18002d, #1c3f6e, #802a00, #0e3734};

    BezierGenerator()
    {
    }

    void createBeziers(int n)
    {
        _branchList = new ArrayList<BinaryBezier>();
        for (int i = 0; i < n; i++)
        {
            color c0 = #ffffff;
            BezierType type = random(1) < .4 ? BezierType.STROKE : BezierType.FILL;
            float rad = random(TAU);
            PVector s = new PVector(random(width), random(height));
            int k = 2+(int)random(2);
            for (int j = 0; j < k; j++)
            {
                color c = _palette[(int)(sq(random(1))*_palette.length)];
                float l = 80 + sq(random(1))*400;
                float r = random(.5, .75);
                BinaryBezier branch = new BinaryBezier(c0, c, type, rad);
                branch.createBranchTree(l, r, s, null, null);
                _branchList.add(branch);
                rad += TAU/k;
            }
        }
        Collections.sort(_branchList, new BinaryBezierComparator());
    }

    void drawBeziers()
    {
        for (BinaryBezier b : _branchList) { b.drawMe(); }
    }
}