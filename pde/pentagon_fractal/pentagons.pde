class FirstPentagon extends Pentagon
{
    FirstPentagon(float totalLen)
    {
        super();
        setParameters(new PVector(width/2, height/2), totalLen, totalLen*.5, -PI*3./5.);
    }

    FirstPentagon(PVector center, float totalLen, float rotRad)
    {
        super();
        setParameters(center, totalLen, totalLen*.5, rotRad);
    }

    void setEdgeLength(float edgeLen)
    {
        this.edgeLen = edgeLen > totalLen - toleratedError ? totalLen - toleratedError
            : edgeLen < toleratedError ? toleratedError : edgeLen;
        updateParameters();
    }

    void setRotationRadians(float rotRad)
    {
        this.rotRad = !_inverse ? rotRad : rotRad + halfExRad + exRad;
        updateParameters();
    }

    @Override
    Pentagon[] createChildren()
    {
        Pentagon[] children = new Pentagon[vnum];
        for (int i = 0; i < vnum; i++)
        {
            children[i] = new GeneratedPentagon(i, this);
        }
        setChildrenParameters(children);
        return children;
    }
}

class GeneratedPentagon extends Pentagon
{
    GeneratedPentagon(int vindex, Pentagon parent) { super(vindex, parent); }

    @Override
    Pentagon[] createChildren()
    {
        Pentagon[] children;
        if (isSameVertexSeries(2, 3))
        {
            children = new Pentagon[2];
            children[0] = new OverlappedPentagon(1, this);
            children[1] = new TouchedPentagonLeft(3, this);
        }
        else if (isSameVertexSeries(3, 3))
        {
            children = new Pentagon[3];
            children[0] = new OverlappedPentagon(1, this);
            children[1] = new TouchedPentagonRight(2, this);
            children[2] = new OverlappedPentagon(3, this);
        }
        else
        {
            children = new Pentagon[3];
            children[0] = new OverlappedPentagon(1, this);
            children[1] = new GeneratedPentagon(2, this);
            children[2] = new GeneratedPentagon(3, this);
        }
        setChildrenParameters(children);
        return children;
    }

    boolean isSameVertexSeries(int vindex, int maxiterations)
    {
        Pentagon penta = this;
        for (int i = 0; i < maxiterations; i++)
        {
            if (penta.parent.parent == null || penta.vindex != vindex) { return false; }
            penta = penta.parent;
        }
        return true;
    }
}

class GeneratedPentagonLeft extends Pentagon
{
    GeneratedPentagonLeft(int vindex, Pentagon parent) { super(vindex, parent); }

    @Override
    Pentagon[] createChildren()
    {
        Pentagon[] children = new Pentagon[3];
        children[0] = new OverlappedTerminalPentagon(1, this);
        children[1] = new TouchedPentagonLeft(2, this);
        children[2] = new GeneratedPentagon(3, this);
        setChildrenParameters(children);
        return children;
    }
}

class GeneratedPentagonRight extends Pentagon
{
    GeneratedPentagonRight(int vindex, Pentagon parent) { super(vindex, parent); }

    @Override
    Pentagon[] createChildren()
    {
        Pentagon[] children = new Pentagon[3];
        children[0] = new OverlappedPentagon(1, this);
        children[1] = new GeneratedPentagon(2, this);
        children[2] = new TouchedPentagonRight(3, this);
        setChildrenParameters(children);
        return children;
    }
}

class TouchedPentagonLeft extends Pentagon
{
    TouchedPentagonLeft(int vindex, Pentagon parent) { super(vindex, parent); }

    @Override
    Pentagon[] createChildren()
    {
        Pentagon[] children = new Pentagon[1];
        children[0] = new GeneratedPentagonLeft(3, this);
        setChildrenParameters(children);
        return children;
    }
}

class TouchedPentagonRight extends Pentagon
{
    TouchedPentagonRight(int vindex, Pentagon parent) { super(vindex, parent); }

    @Override
    Pentagon[] createChildren()
    {
        Pentagon[] children = new Pentagon[2];
        children[0] = new OverlappedPentagon(1, this);
        children[1] = new GeneratedPentagonRight(2, this);
        setChildrenParameters(children);
        return children;
    }
}

class OverlappedPentagon extends Pentagon
{
    OverlappedPentagon(int vindex, Pentagon parent) { super(vindex, parent); }

    @Override
    Pentagon[] createChildren()
    {
        Pentagon[] children = new Pentagon[2];
        children[0] = new TerminalPentagon(1, this);
        children[1] = new OverlappedPentagon(3, this);
        setChildrenParameters(children);
        return children;
    }
}

class TerminalPentagon extends Pentagon
{
    TerminalPentagon(int vindex, Pentagon parent) { super(vindex, parent); }

    @Override
    Pentagon[] createChildren()
    {
        Pentagon[] children = new Pentagon[2];
        children[0] = new TerminalPentagon(1, this);
        children[1] = new TerminalPentagon(4, this);
        setChildrenParameters(children);
        return children;
    }
}

class OverlappedTerminalPentagon extends Pentagon
{
    OverlappedTerminalPentagon(int vindex, Pentagon parent) { super(vindex, parent); }

    @Override
    Pentagon[] createChildren()
    {
        Pentagon[] children = new Pentagon[3];
        children[0] = new TerminalPentagon(1, this);
        children[1] = new TerminalPentagon(2, this);
        children[2] = new TerminalPentagon(4, this);
        setChildrenParameters(children);
        return children;
    }
}