class Arc
{
    final PVector center;
    final float radius;

    Arc(PVector center, float radius)
    {
        this.center = center;
        this.radius = radius;
    }

    void drawMe(float start, float stop, int arcMode)
    {
        arc(center.x, center.y, radius*2, radius*2, start, stop, arcMode);
    }

    void drawMe()
    {
        circle(center.x, center.y, radius*2);
    }
}

abstract class ArcGenerator
{
    ArrayList<Arc> arcs;
    final Arc initArc;
    final color[] palette = {#5294e2, #8ecae6, #2b2d42, #a8dadc, #7b9e87, #c7ecee};

    ArcGenerator(Arc initArc)
    {
        this.initArc = initArc;
        arcs = new ArrayList<Arc>();
        arcs.add(initArc);
    }

    abstract void drawArcs();

    abstract boolean addArc();

    abstract boolean isOverlap(Arc newArc);
}

class ArcGenerator0 extends ArcGenerator
{
    ArcGenerator0(Arc initArc) { super(initArc); }

    @Override
    void drawArcs()
    {
        for (Arc arc : arcs)
        {
            if (arc.equals(initArc)) { continue; }
            color c = random(1) < .25 && arc.radius < initArc.radius*.25 ? #000000 : palette[(int)random(palette.length)];
            push();
            noStroke();
            fill(c);
            arc.drawMe();
            pop();
        }
    }

    @Override
    boolean addArc()
    {
        for (int i = 0; i < 100; i++)
        {
            PVector center = PVector.random3D().mult(initArc.radius).add(initArc.center);
            center.z = 0;
            float radius = sq(random(1))*initArc.radius*.4+2;
            Arc newArc = new Arc(center, radius);
            if (!isOverlap(newArc))
            {
                arcs.add(newArc);
                return true;
            }
        }
        return false;
    }

    @Override
    boolean isOverlap(Arc newArc)
    {
        for (Arc arc : arcs)
        {
            float d = PVector.dist(arc.center, newArc.center);
            if (abs(arc.radius-newArc.radius) < d && arc.radius+newArc.radius > d)
            {
                return true;
            }
        }
        return false;
    }
}

class ArcGenerator1 extends ArcGenerator
{
    final int seed = (int)random(65536);
    
    ArcGenerator1(Arc initArc)
    {
        super(initArc);
    }

    @Override
    void drawArcs()
    {
        int rem = (int)random(2);
        color outerStroke = random(1) < .6 ? #000000 : #eeeeee;

        push();
        for (int j = 0; j <= (arcs.size()-2)*2; j++)
        {
            int i = j % (arcs.size()-1) + 1;
            Arc arc = arcs.get(i);
            float theta1 = PVector.sub(arcs.get(i-1).center, arc.center).heading();
            float theta2 = i < arcs.size()-1 ? PVector.sub(arcs.get(i+1).center, arc.center).heading()
                : i%2 == rem ? theta1+HALF_PI : theta1-HALF_PI;
            if (i <= 1) { theta1 = rem == 0 ? theta1-HALF_PI : theta1+HALF_PI; }
            float start = i%2 == rem ? theta1 : theta2;
            float stop = i%2 == rem ? theta2 : theta1;
            if (start > stop) { stop += TAU; }

            color c = palette[(int)random(palette.length)];
            if (j <= arcs.size()-2)
            {
                noFill();
                strokeWeight(6);
                stroke(outerStroke);
                arc.drawMe(start, stop, OPEN);
            }
            else
            {
                noFill();
                strokeWeight(2);
                stroke(c);
                arc.drawMe(start, stop, OPEN);
                if (initArc.radius+arc.radius/2 < PVector.dist(initArc.center, arc.center))
                {
                    noStroke();
                    fill(random(1) < .75 ? #000000 : c);
                    circle(arc.center.x, arc.center.y, arc.radius);
                }
            }
        }
        pop();
    }

    @Override
    boolean addArc()
    {
        Arc preArc = arcs.get(arcs.size()-1);
        Arc newArc = null;
        for (int i = 1; i < 100; i++)
        {
            float noiseScale = .01;
            float radius = sq(noise(preArc.center.x*noiseScale, preArc.center.y*noiseScale, seed))*60;
            float r = preArc.equals(initArc) ? preArc.radius-radius*random(.5, .9) : preArc.radius+radius;
            PVector center = PVector.random2D().mult(r).add(preArc.center);
            newArc = new Arc(center, radius);
            if (!isOverlap(newArc) || preArc.equals(initArc))
            {
                arcs.add(newArc);
                return true;
            }
        }
        return false;
    }

    @Override
    boolean isOverlap(Arc newArc)
    {
        for (Arc arc : arcs)
        {
            float d = PVector.dist(arc.center, newArc.center);
            if (arc.radius+newArc.radius > d)
            {
                return true;
            }
        }
        return false;
    }
}