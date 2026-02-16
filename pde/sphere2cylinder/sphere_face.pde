class SphereFace // rectangle
{
    SphereFace parent;
    ArrayList<SphereFace> children;
    float radius, cylinderRatio = 0;
    int res, latIndex, lonIndex;
    PVector v1, v2, v3, v4;

    SphereFace(float radius, int res)
    {
        this(null, radius, res, 0, res/2);
    }

    SphereFace(SphereFace parent, float radius, int res, int latIndex, int lonIndex)
    {
        this.parent = parent;
        this.radius = radius;
        this.res = res;
        this.latIndex = latIndex;
        this.lonIndex = lonIndex;
        createChildren();
    }

    void createChildren()
    {
        children = new ArrayList<SphereFace>();
        if (lonIndex == res/2 && latIndex < res-1) { children.add(new SphereFace(this, radius, res, latIndex+1, lonIndex)); }
        if (lonIndex >= res/2 && lonIndex < res-1) { children.add(new SphereFace(this, radius, res, latIndex, lonIndex+1)); }
        if (lonIndex <= res/2 && lonIndex > 0) { children.add(new SphereFace(this, radius, res, latIndex, lonIndex-1)); }
    }

    void setVertices()
    {
        float dlat = PI / res;
        float dlon = TAU / res;
        float latIndex2 = latIndex <= 0 ? latIndex+.001 : latIndex;
        float latIndex3 = latIndex >= res-1 ? latIndex+.999 : latIndex+1.;
        v1 = createVertex(dlat * latIndex2, dlon * lonIndex);
        v2 = createVertex(dlat * latIndex3, dlon * lonIndex);
        v3 = createVertex(dlat * latIndex3, dlon * (lonIndex+1));
        v4 = createVertex(dlat * latIndex2, dlon * (lonIndex+1));
    }

    PVector createVertex(float lat, float lon)
    {
        float x = radius * sin(lat) * cos(lon);
        float y = radius * sin(lat) * sin(lon);
        float z = radius * cos(lat);
        PVector v = new PVector(x, y);
        float exLen = (radius - v.mag()) * cylinderRatio;
        v.add(v.normalize(null).mult(exLen));
        v.z = z;
        return v;
    }

    void drawMe()
    {
        push();
        fill(#000000);
        stroke(#b00000);
        beginShape();
        myVertex(v1);
        myVertex(v2);
        myVertex(v3);
        myVertex(v1);
        myVertex(v4);
        myVertex(v3);
        endShape();
        pop();
    }

    void myVertex(PVector v)
    {
        vertex(v.x, v.y, v.z);
    }
}