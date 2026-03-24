package sketches.sketch20231013a;

import processing.core.*;

import static processing.core.PApplet.*;

import support.util.*;
import support.shapes.*;
import support.shapes.attribute.Attribute;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class Particle extends Circle
{
    private boolean isActive;
    private int lifeCount;
    private final List<PVector> vertices;

    public Particle(PVector center, float radius, Attribute attr, boolean isActive, int lifeCount, int id)
    {
        super(center, radius, attr, id);
        this.isActive = isActive;
        this.lifeCount = lifeCount;
        vertices = new ArrayList<>();
    }

    public boolean isStopping() { return !isActive; }

    public boolean isDeath() { return lifeCount < 0; }

    public int getVerticesSize() { return vertices.size(); }

    public void update(float stepDist)
    {
        if (isStopping() || isDeath()) { return; }
        center.add(PVector.random2D().mult(stepDist));
        lifeCount--;
    }

    public void stopMovingCheck(List<Particle> particles)
    {
        if (isStopping() || isDeath()) { return; }

        Particle other = getInactiveMinimumDistance(particles);
        if (other == null) { return; }
        else if (!isOverlap(other)) { return; }

        // If this particle has overlapped other inactive particle.
        isActive = false;
        setId(other.getId());
        addVertex(other);
        other.addVertex(this);
        particles.forEach(p ->
        {
            if (!p.isStopping() && p.isOverlap(this))
            {
                p.lifeCount = -1;
            }
        });
    }

    /**
     * Add the intersection points with collided particle to the list.
     * And then, sort it by angle from the center.
     * @param other the collided particle
     */
    private void addVertex(Particle other)
    {
        PVector cDiff = PVector.sub(other.center, center);
        float a = 2 * cDiff.x;
        float b = 2 * cDiff.y;
        float c = cDiff.y;
        float d = - cDiff.x;
        float p = - center.magSq() + other.center.magSq() + sq(radius) - sq(other.radius);
        float q = center.x * other.center.y - other.center.x * center.y;
        float din = a * d - b * c;
        if (abs(din) < .000001F) {din = PMath.sign(din) * .000001F;}
        float x = (p * d - b * q) / din;
        float y = (a * q - p * c) / din;
        vertices.add(new PVector(x, y));
        vertices.sort((v1, v2) -> (int) PMath.sign(PVector.sub(v1, center).heading() - PVector.sub(v2, center).heading()));
    }

    public boolean isOverlap(Particle other)
    {
        if (other == this) { return false; }
        float dist = PVector.dist(center, other.center);
        return dist < radius + other.radius;
    }

    private Particle getInactiveMinimumDistance(List<Particle> particles)
    {
        Optional<Particle> opt = particles.stream()
                .filter(p -> p != this && p.isStopping())
                .min((p1, p2) ->
                {
                    float dist1 = PVector.dist(center, p1.center) - radius - p1.radius;
                    float dist2 = PVector.dist(center, p2.center) - radius - p2.radius;
                    return (int) PMath.sign(dist1 - dist2);
                });

        return opt.orElse(null);
    }

    @Override
    public void drawShape(PGraphics pg)
    {
        if (isDeath()) { return; }

        if (!isStopping())
        {
            super.drawShape(pg);
        }
        else if (getVerticesSize() < 2)
        {
            pg.ellipse(center.x, center.y, 8, 8);
        }
        else
        {
            pg.beginShape();
            vertices.forEach(v -> pg.vertex(v.x, v.y));
            pg.endShape(CLOSE);
        }
    }
}
