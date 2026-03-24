package support.util;

import support.quaternion.Quaternion;
import processing.core.*;

import static processing.core.PApplet.*;

public class PMath
{
    public static PVector rotate(PVector target, float rad, PVector init)
    {
        return target.sub(init).rotate(rad).add(init);
    }

    /**
     * 3D vector rotation using quaternion
     *
     * @param target target vector
     * @param axis   rotation axis
     * @param rad    rotation angle(radians)
     * @param init   rotation initial point
     * @return rotated target vector
     */
    public static PVector rotate3D(PVector target, PVector axis, float rad, PVector init)
    {
        Quaternion q = new Quaternion(axis, rad);
        Quaternion qi = q.inverse(null);
        Quaternion qr = q.multr(PVector.sub(target, init)).multreq(qi);
        target.set(qr.getVector().add(init));
        return target;
    }

    public static PVector rotate3D(PVector target, PVector axis, float rad)
    {
        return rotate3D(target, axis, rad, new PVector());
    }

    /**
     * calc production vector: b -> a
     *
     * @param a vector to be projected
     * @param b vector to project
     * @return projected vector
     */
    public static PVector production(PVector a, PVector b)
    {
        return PVector.mult(a, a.dot(b) / a.magSq());
    }

    /**
     * calc intersection point of following 2 lines:
     * a + (b - a) * s
     * c + (d - c) * t
     * only 2D vector
     *
     * @param a point corresponded b
     * @param b point corresponded a
     * @param c point corresponded d
     * @param d point corresponded c
     * @return the parameter pair (s, t). Intersection point of a-b and c-d is "PVector.sub(b, a).mult(s).add(a)" or "PVector.sub(d, c).mult(t).add(c)"
     */
    public static PVector intersection(PVector a, PVector b, PVector c, PVector d)
    {
        PVector p = PVector.sub(b, a);
        PVector q = PVector.sub(d, c);
        PVector r = PVector.sub(c, a);
        float din = p.x * (-q.y) - (-q.x) * p.y;
        if (abs(din) < .000001F) {din = sign(din) * .000001F;}
        float s = (r.x * (-q.y) - (-q.x) * r.y) / din;
        float t = (p.x * r.y - r.x * p.y) / din;
        return new PVector(s, t);
    }

    public static PVector normal2D(PVector v)
    {
        return v.copy().rotate(HALF_PI).normalize();
    }

    public static PVector randomNormal(PVector v)
    {
        PVector tmp = PVector.random3D();
        while (PVector.angleBetween(v, tmp) < 0.02) {tmp = PVector.random3D();}
        return v.cross(tmp).normalize();
    }

    /**
     * get the angle between two vectors in the range of 0 to TAU
     *
     * @param base   vector base of angle
     * @param target the other vector
     * @return radians between base and target
     */
    public static float angleBetween(PVector base, PVector target)
    {
        float rad = PVector.angleBetween(base, target);
        if (base.cross(target).z < 0) {rad = TAU - rad;}
        return rad;
    }

    /**
     * calculate the distance between a line and a point
     *
     * @param start start point of the line
     * @param goal end point of the line
     * @param target point to be evaluated against the line
     * @return the distance between the start-goal line and the target point
     */
    public static float distance(PVector start, PVector goal, PVector target)
    {
        PVector sub = PVector.sub(goal, start);
        PVector normal = normal2D(sub);
        return abs(PVector.dot(normal, PVector.sub(target, start))) / normal.mag();
    }

    public static float mod(float x, float y)
    {
        return x-y*floor(x/y);
    }

    public static float fract(float x)
    {
        return mod(x, 1);
    }

    public static float sign(float x)
    {
        return x < 0 ? -1 : x == 0 ? 0 : 1;
    }

    public static float step(float a, float x)
    {
        if (x < a) { return 0; }
        return 1;
    }

    public static float smoothstep(float e0, float e1, float x)
    {
        float t = constrain((x - e0) / (e1 - e0), 0, 1);
        return t * t * (3 - 2 * t);
    }
}
