package support.shapes;

import support.shapes.attribute.Attribute;
import processing.core.*;
import static processing.core.PApplet.*;

import java.util.ArrayDeque;

public class Icosphere extends SimpleShape3D implements Translatable, Rotatable3D
{
    public float radius;
    public int subdivision;
    public ArrayDeque<Triangle> faceList;

    public Icosphere(float radius, int subdivision, Attribute attr)
    {
        super(attr);
        this.radius = radius;
        this.subdivision = subdivision;
    }

    public Icosphere(float radius, int subdivision)
    {
        this(radius, subdivision, null);
    }

    @Override
    public void createFaces()
    {
        icosahedron();
        for (int i = 0; i < subdivision; i++) { split(); }
    }

    private void icosahedron()
    {
        PVector[] vertices = new PVector[12];
        vertices[0] = new PVector(0, 0, radius);
        float hrad = 0;
        float vrad = atan2(1, 2);
        for (int i = 1; i <= 5; i++)
        {
            float z = radius * sin(vrad);
            float rxy = radius * cos(vrad);
            vertices[i] = new PVector(rxy*cos(hrad-PI/5), rxy*sin(hrad-PI/5), z);
            vertices[i+5] = new PVector(rxy*cos(hrad), rxy*sin(hrad), -z);
            hrad += TAU/5;
        }
        vertices[11] = new PVector(0, 0, -radius);

        faceList = new ArrayDeque<Triangle>();
        for (int i = 1; i <= 5; i++)
        {
            addFace(vertices[0], vertices[i], vertices[i%5+1]);
            addFace(vertices[i], vertices[i+5], vertices[i%5+1]);
            addFace(vertices[i+5], vertices[i%5+1+5], vertices[i%5+1]);
            addFace(vertices[11], vertices[i%5+1+5], vertices[i+5]);
        }
    }

    private void split()
    {
        int len = faceList.size();
        for (int i = 0; i < len; i++)
        {
            Triangle t = faceList.poll();
            PVector newv1 = PVector.add(t.v1, t.v2).div(2);
            PVector newv2 = PVector.add(t.v2, t.v3).div(2);
            PVector newv3 = PVector.add(t.v3, t.v1).div(2);
            newv1.mult(radius / newv1.mag());
            newv2.mult(radius / newv2.mag());
            newv3.mult(radius / newv3.mag());
            addFace(t.v1 , newv1, newv3);
            addFace(newv1, t.v2 , newv2);
            addFace(newv3, newv2, t.v3 );
            addFace(newv1, newv2, newv3);
        }
    }

    @Override
    public void addFace(PVector... v)
    {
        faceList.add(new Triangle(v[0].copy(), v[1].copy(), v[2].copy(), attr));
    }

    @Override
    public Icosphere copy() { return new Icosphere(radius, subdivision, attr.copy()); }

    @Override
    public void drawShape(PGraphics pg)
    {
        for (Triangle face : faceList) { face.drawMe(pg); }
    }

    @Override
    public void translate(PVector dv)
    {
        for (Triangle face : faceList)
        {
            face.translate(dv);
        }
    }

    @Override
    public void rotate3D(PVector axis, float rad, PVector init)
    {
        for (Triangle face : faceList)
        {
            face.rotate3D(axis, rad, init);
        }
    }
}
