abstract class Pentagon
{
    final int vnum = 5;
    final float exRad = TAU / vnum;
    final float halfExRad = exRad * .5;
    final float scaleRatio = (sqrt(5.)-1.)/2.;
    final float toleratedError = .1;

    PVector center;
    float totalLen, edgeLen, radius, rotRad;
    int vindex;
    Pentagon parent;
    PVector[] vertices, extraVertices;

    Pentagon()
    {
        vindex = -1;
        parent = null;
    }

    Pentagon(int vindex, Pentagon parent)
    {
        this.vindex = vindex;
        this.parent = parent;
    }

    void setParameters(PVector center, float totalLen, float edgeLen, float rotRad)
    {
        this.center = center;
        this.totalLen = totalLen;
        this.rotRad = rotRad;
        this.edgeLen = edgeLen > totalLen - toleratedError ? totalLen - toleratedError
            : edgeLen < toleratedError ? toleratedError : edgeLen;
        updateParameters();
    }

    void updateParameters()
    {
        radius = edgeLen / (2.*sin(halfExRad));
        vertices = new PVector[vnum];
        float theta = !_inverse ? rotRad - (HALF_PI + halfExRad) : rotRad - (HALF_PI + exRad*2.);
        for (int i = 0; i < vnum; i++)
        {
            vertices[i] = PVector.fromAngle(theta).mult(radius).add(center);
            theta += TAU/vnum;
        }
        extraVertices = new PVector[vnum];
        for (int i = 0; i < vnum; i++)
        {
            extraVertices[i] = 
                PVector.sub(vertices[i], vertices[!_inverse ? (i+1)%vnum : (i-1+vnum)%vnum])
                       .normalize()
                       .mult(totalLen-edgeLen)
                       .add(vertices[i]);
        }
    }

    void drawMe()
    {
        beginShape(/*TRIANGLE_FAN*/);
        //vertex(center.x, center.y);
        for (int i = 0; i < vnum; i++)
        {
            PVector v = vertices[i];
            PVector ev = extraVertices[i];
            vertex(v.x, v.y);
            line(v.x, v.y, ev.x, ev.y);
        }
        //vertex(vertices[0].x, vertices[0].y);
        endShape(CLOSE);
    }

    abstract Pentagon[] createChildren();
    
    void setChildrenParameters(Pentagon[] children)
    {
        for (Pentagon child : children)
        {
            float newTotalLen = totalLen * scaleRatio;
            float newEdgeLen = edgeLen * scaleRatio;
            PVector v = vertices[child.vindex];
            PVector ev = extraVertices[child.vindex];
            PVector d = PVector.sub(ev, v);
            float newRotRad  = d.heading();
            PVector u = PVector.fromAngle(!_inverse ? newRotRad + (HALF_PI-halfExRad) : newRotRad - (HALF_PI-halfExRad))
                               .mult(radius * scaleRatio);
            PVector newCenter = d.normalize().mult(newTotalLen - newEdgeLen).add(ev).add(u);
            child.setParameters(newCenter, newTotalLen, newEdgeLen, newRotRad);
        }
    }
}