class Sphere
{
    float radius;
    int res;
    boolean inverse = false;
    SphereFace root;

    Sphere(float radius, int res)
    {
        this.radius = radius;
        this.res = res;
        root = new SphereFace(radius, res);
    }

    void drawMe(float dratio, int stepFrame)
    {
        if ((!inverse && isCylinder(root)) || (inverse && isSphere(root))) { inverse = !inverse; }
        if (!inverse) { sphere2cylinder(root, 1., dratio, stepFrame); }
        else { cylinder2sphere(root, 0., dratio, stepFrame); }
        //println(countFaces(root));
    }

    void sphere2cylinder(SphereFace face, float preRatio, float dratio, int stepFrame)
    {
        for (SphereFace child : face.children)
        {
            if (preRatio > dratio * stepFrame) { child.cylinderRatio = constrain(child.cylinderRatio + dratio, 0., 1.); }
            child.setVertices();
            child.drawMe();
            sphere2cylinder(child, child.cylinderRatio, dratio, stepFrame);
        }
    }

    void cylinder2sphere(SphereFace face, float preRatio, float dratio, int stepFrame)
    {
        for (SphereFace child : face.children)
        {
            if (preRatio < 1. - dratio * stepFrame) { child.cylinderRatio = constrain(child.cylinderRatio - dratio, 0., 1.); }
            child.setVertices();
            child.drawMe();
            cylinder2sphere(child, child.cylinderRatio, dratio, stepFrame);
        }
    }

    // int countFaces(SphereFace face)
    // {
    //     int c = 1;
    //     for (SphereFace child : face.children) { c += countFaces(child); }
    //     return c;
    // }

    boolean isSphere(SphereFace face)
    {
        for (SphereFace child : face.children)
        {
            if (child.cylinderRatio > 0.) { return false; }
            return isSphere(child);
        }
        return true;
    }

    boolean isCylinder(SphereFace face)
    {
        for (SphereFace child : face.children)
        {
            if (child.cylinderRatio < 1.) { return false; }
            return isCylinder(child);
        }
        return true;
    }
}