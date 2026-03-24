package support.closure;

import processing.core.*;

import static processing.core.PApplet.*;

import support.util.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ParticleClosure
{
    public static ArrayList<PVector> convexHull(List<PVector> points)
    {
        ArrayList<PVector> pointsCopy = new ArrayList<>(points);
        ArrayList<PVector> ret = new ArrayList<>();
        Optional<PVector> initOpt = pointsCopy.stream().min((p1, p2)->
        {
            float diff = p1.y - p2.y;
            if (diff == 0) { diff = p1.x - p2.x; }
            return diff == 0 ? -1 : (int) PMath.sign(diff);
        });
        if (!initOpt.isPresent()) { return ret; }
        PVector init = initOpt.get();
        ret.add(init);

        PVector curr = init;
        PVector dir = new PVector(1, 0);
        while (true)
        {
            PVector cacheCurr = curr;
            PVector cacheDir = dir;
            pointsCopy.sort((p1, p2) ->
            {
                float rad1 = PMath.angleBetween(cacheDir, PVector.sub(p1, cacheCurr));
                float rad2 = PMath.angleBetween(cacheDir, PVector.sub(p2, cacheCurr));
                return rad1 == rad2 ? -1 : (int) PMath.sign(rad1 - rad2);
            });
            Optional<PVector> opt = pointsCopy.stream().filter(p -> !p.equals(cacheCurr)).findFirst();
            if (opt.isPresent())
            {
                curr = opt.get();
                pointsCopy.remove(curr);
            }
            if (curr.equals(init)) { break; }
            dir = PVector.sub(curr, cacheCurr);
            ret.add(curr);
        }
        return ret;
    }

    public static ArrayList<PVector> fractalConvexHull(List<PVector> points, int recursiveNum)
    {
        ArrayList<PVector> ret = convexHull(points);
        ArrayList<PVector> rest = new ArrayList<>(points);
        rest.removeAll(ret);
        for (int n = 0; n < recursiveNum; n++)
        {
            for (int i = 0; i < ret.size(); i++)
            {
                PVector start = ret.get(i);
                PVector goal = ret.get((i+1)%ret.size());
                PVector dir = PVector.sub(goal, start).normalize();
                PVector middle = PVector.lerp(start, goal, .5F);
                PVector half = PVector.sub(start, middle);

                rest.sort((p1, p2) ->
                {
                    float dist1 = PMath.distance(start, goal, p1);
                    float dist2 = PMath.distance(start, goal, p2);
                    return dist1 == dist2 ? -1 : (int) PMath.sign(dist1 - dist2);
                });
                Optional<PVector> opt = rest.stream().filter(p ->
                {
                    PVector s2p = PVector.sub(p, start);
                    PVector m2p = PVector.sub(p, middle);
                    return abs(PVector.dot(half, m2p)) < half.magSq() && dir.cross(s2p).z > 0;
                }).findFirst();
                if (!opt.isPresent()) { continue; }

                PVector point = opt.get();
                PVector m2p = PVector.sub(point, middle);
                float dist = m2p.mag();
                //float threshDist = sqrt(abs(half.cross(m2p).z))*.7F;
                float threshDist = half.mag()*.9F;

                if (dist < threshDist)
                {
                    ret.add(++i, point);
                    rest.remove(point);
                }
                else
                {
                    PVector p = m2p.normalize(null).mult(threshDist).add(middle);
                    ret.add(++i, p);
                }
            }
        }
        return ret;
    }
}
