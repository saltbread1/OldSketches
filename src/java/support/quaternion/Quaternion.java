package support.quaternion;

import processing.core.PVector;
import java.lang.Math;

public class Quaternion
{
    // x*i + y*j + z*k + w
    public float x, y, z, w;

    public Quaternion() { w = 1; }

    public Quaternion(float x, float y, float z, float w) { set(x, y, z, w); }

    public Quaternion(PVector axis, float theta)
    {
        PVector normAxis = axis.normalize(null);
        this.x = (float)Math.sin(theta/2)*normAxis.x;
        this.y = (float)Math.sin(theta/2)*normAxis.y;
        this.z = (float)Math.sin(theta/2)*normAxis.z;
        this.w = (float)Math.cos(theta/2);
    }

    public Quaternion copy() { return new Quaternion(x, y, z, w); }

    public void set(float x, float y, float z, float w)
    {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    public Quaternion mult(float n)
    {
        return new Quaternion(x*n, y*n, z*n, w*n);
    }

    public Quaternion multeq(float n)
    {
        x *= n; y *= n; z *= n; w *= n;
        return this;
    }

    public Quaternion multr(Quaternion q)
    {
        float w1 = w;
        float w2 = q.w;
        PVector v1 = new PVector(x, y, z);
        PVector v2 = new PVector(q.x, q.y, q.z);
        float neww = w1*w2 - PVector.dot(v1, v2);
        PVector newv = PVector.mult(v2, w1).add(PVector.mult(v1, w2)).add(v1.cross(v2));
        return new Quaternion(newv.x, newv.y, newv.z, neww);
    }

    public Quaternion multreq(Quaternion q)
    {
        float w1 = w;
        float w2 = q.w;
        PVector v1 = new PVector(x, y, z);
        PVector v2 = new PVector(q.x, q.y, q.z);
        float neww = w1*w2 - PVector.dot(v1, v2);
        PVector newv = PVector.mult(v2, w1).add(PVector.mult(v1, w2)).add(v1.cross(v2));
        x = newv.x; y = newv.y; z = newv.z; w = neww;
        return this;
    }

    public Quaternion multl(Quaternion q)
    {
        float w1 = q.w;
        float w2 = w;
        PVector v1 = new PVector(q.x, q.y, q.z);
        PVector v2 = new PVector(x, y, z);
        float neww = w1*w2 - PVector.dot(v1, v2);
        PVector newv = PVector.mult(v2, w1).add(PVector.mult(v1, w2)).add(v1.cross(v2));
        return new Quaternion(newv.x, newv.y, newv.z, neww);
    }

    public Quaternion multleq(Quaternion q)
    {
        float w1 = q.w;
        float w2 = w;
        PVector v1 = new PVector(q.x, q.y, q.z);
        PVector v2 = new PVector(x, y, z);
        float neww = w1*w2 - PVector.dot(v1, v2);
        PVector newv = PVector.mult(v2, w1).add(PVector.mult(v1, w2)).add(v1.cross(v2));
        x = newv.x; y = newv.y; z = newv.z; w = neww;
        return this;
    }

    public Quaternion multr(PVector v)
    {
        return multr(new Quaternion(v.x, v.y, v.z, 0));
    }

    public Quaternion multreq(PVector v)
    {
        return multreq(new Quaternion(v.x, v.y, v.z, 0));
    }

    public Quaternion multl(PVector v)
    {
        return multl(new Quaternion(v.x, v.y, v.z, 0));
    }

    public Quaternion multleq(PVector v)
    {
        return multleq(new Quaternion(v.x, v.y, v.z, 0));
    }

    public Quaternion div(float n)
    {
        // x /= n; y /= n; z /= n; w /= n;
        return mult(1/n);
    }

    public Quaternion diveq(float n)
    {
        // x /= n; y /= n; z /= n; w /= n;
        return multeq(1/n);
    }

    public float mag()
    {
        return (float)Math.sqrt((double)(magSq()));
    }

    public float magSq()
    {
        return x*x + y*y + z*z + w*w;
    }

    public Quaternion normalize()
    {
        float m = mag();
        if (m > 0 && m != 1) { diveq(m); }
        return this;
    }

    public Quaternion normalize(Quaternion target)
    {
        if (target == null) { target = new Quaternion(); }
        float m = mag();
        if (m > 0 && m != 1) { target.set(x/m, y/m, z/m, w/m); }
        return this;
    }

    public Quaternion conjugate()
    {
        x *= -1; y *= -1; z *= -1;
        return this;
    }

    public Quaternion conjugate(Quaternion target)
    {
        if (target == null) { target = new Quaternion(); }
        target.set(x*-1, y*-1, z*-1, w);
        return target;
    }

    public Quaternion inverse()
    {
        conjugate();
        float msq = magSq();
        if (msq > 0 && msq != 1) { diveq(msq); }
        return this;
    }

    public Quaternion inverse(Quaternion target)
    {
        if (target == null) { target = new Quaternion(); }
        conjugate(target);
        float msq = magSq();
        if (msq > 0 && msq != 1) { target.diveq(msq); }
        return target;
    }

    public PVector getVector() { return new PVector(x, y, z); }

    public String toString()
    {
        String str = "";
        str += x < 0 ? "- " + Math.abs(x) : "  " + x;
        str += "i";
        str += y < 0 ? " - " + Math.abs(y) : " + " + y;
        str += "j";
        str += z < 0 ? " - " + Math.abs(z) : " + " + z;
        str += "k";
        str += w < 0 ? " - " + Math.abs(w) : " + " + w;
        return str;
    }
}
