package sketches.sketch20231013a;

import processing.core.*;

import static processing.core.PApplet.*;

import support.util.*;
import support.shapes.attribute.Attribute;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static support.shapes.attribute.DrawStyle.*;

public class ParticleManager
{
    private final PApplet pApplet;
    private final float minDiameter, maxDiameter;
    private final int inactiveThreshNum;
    private final List<Particle> particles;
    private final Particle[] initParticles;
    private final float[] rangeRadius;
    private final float rangeOffset;

    public ParticleManager(PApplet pApplet, float minDiameter, float maxDiameter, int inactiveThreshNum, int initNum, float rangeOffset)
    {
        this.pApplet = pApplet;
        this.minDiameter = minDiameter;
        this.maxDiameter = maxDiameter;
        this.inactiveThreshNum = inactiveThreshNum;
        this.rangeOffset = rangeOffset;
        particles = new ArrayList<>();
        initParticles = new Particle[initNum];
        rangeRadius = new float[initNum];
    }

    public void initialize()
    {
        for (int i = 0; i < initParticles.length; i++)
        {
            //PVector c = new PVector(pApplet.width/2, pApplet.height/2);
            PVector c = new PVector(pApplet.random(pApplet.width), pApplet.random(pApplet.height));
            initParticles[i] = new Particle(c, getRadius(), new Attribute(0xffffffff, STROKEANDFILL),
                    false, 0, i);
        }
        particles.clear();
        particles.addAll(Arrays.asList(initParticles));
    }

    public void updateParticles(float maxStepDist)
    {
        if (getInactiveNum() >= inactiveThreshNum) { return; }

        // a circular range where generate particles
        for (int i = 0; i < initParticles.length; i++)
        {
            rangeRadius[i] = calcInactiveClosureRadius(initParticles[i]) + rangeOffset;
        }

        while (addParticle());
        particles.forEach(p -> p.update(pApplet.random(maxStepDist)));
        particles.forEach(p -> p.stopMovingCheck(particles));
        particles.removeAll(particles.stream().filter(Particle::isDeath).collect(Collectors.toList()));

        // make the end of branches front
        particles.sort((p1, p2) -> p2.getVerticesSize() - p1.getVerticesSize());

        // dye strokes of stopping particles
        particles.stream().filter(Particle::isStopping)
                .forEach(p ->
                {
                    float t = PVector.sub(p.center, initParticles[p.getId()].center).magSq() / sq(rangeRadius[p.getId()] - rangeOffset);
                    p.setStroke(pApplet.lerpColor(0xfffee440, 0xffe9190f, t));
                });
    }

    public void drawParticles()
    {
        //particles.forEach(p -> p.drawMe(pApplet));
        if (getInactiveNum() < inactiveThreshNum)
        {
            particles.stream().filter(Particle::isStopping).forEach(p -> p.drawMe(pApplet));
        }
        else
        {
            particles.forEach(p -> p.drawMe(pApplet));
        }
    }

    private boolean addParticle()
    {
        for (int i = 0; i < 32; i++)
        {
            int index = (int) pApplet.random(initParticles.length);
            Attribute attr = new Attribute(Util.chooseInt(pApplet, 0xff00bbf9, 0xff00f5d4, 0xffff5ca8),
                    Util.chooseInt(pApplet, 0xffffffff, 0xff000000), STROKEANDFILL);
            float r = (1 - pApplet.random(pApplet.random(pApplet.random(1)))) * rangeRadius[index];
            Particle particle = new Particle(PVector.random2D().mult(r).add(initParticles[index].center), getRadius(), attr, true,
                    (int) pApplet.random(256, 1024), index);
            if (particles.stream().noneMatch(p -> p.isOverlap(particle)))
            {
                particles.add(particle);
                return true;
            }
        }
        return false;
    }

    private float getRadius()
    {
        return lerp(minDiameter, maxDiameter, sq(pApplet.random(1))) / 2;
    }

    private int getInactiveNum()
    {
        return (int) particles.stream().filter(Particle::isStopping).count();
    }

    /**
     * Calculate radius of the minimum circle which surrounds the cluster of inactive particles.
     * @param cp a particle which generates the cluster of inactive particles
     * @return radius of the circle closure
     */
    private float calcInactiveClosureRadius(Particle cp)
    {
        Optional<Particle> opt = particles.stream()
                .filter(p -> p.getVerticesSize() == 1 && p.getId() == cp.getId())
                .max((p1, p2) ->
                {
                    float dist1 = PVector.sub(p1.center, cp.center).magSq();
                    float dist2 = PVector.sub(p2.center, cp.center).magSq();
                    return (int) PMath.sign(dist1 - dist2);
                });

        return opt.map(particle -> PVector.dist(particle.center, cp.center)).orElse(0F);
    }
}
