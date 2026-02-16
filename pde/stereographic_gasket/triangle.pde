class Triangle
{
    PVector v1, v2, v3;

    Triangle(PVector v1, PVector v2, PVector v3)
    {
        setVertices(v1, v2, v3);
    }

    void setVertices(PVector v1, PVector v2, PVector v3)
    {
        this.v1 = v1;
        this.v2 = v2;
        this.v3 = v3;
    }

    void drawMe()
    {
        push();
        fill(#ffffff);
        noStroke();
        beginShape();
        myVertex(v1);
        myVertex(v2);
        myVertex(v3);
        endShape(CLOSE);
        pop();
    }

    void myVertex(PVector v)
    {
        //vertex(v.x, v.y, v.z);
        vertex(v.x, v.y);
    }
}