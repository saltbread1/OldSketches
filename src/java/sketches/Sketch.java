package sketches;

import support.util.*;
import processing.core.PApplet;

public class Sketch extends PApplet
{
    public static final String OUTPUT_PATHNAME = "graphics";
    private float currSec;

    public void initialize()
    {
    }

    protected void updateCurrentSecond() { currSec += 1F / frameRate; }

    public float getCurrentSecond() { return currSec; }

    public void saveImage(String extension, int... seeds)
    {
        saveFrame(Util.getFilename(OUTPUT_PATHNAME + "/" + getClass().getSimpleName(), "####." + extension, seeds));
    }

    public void saveImage(int... seeds)
    {
        saveImage("png", seeds);
    }

    @Override
    public void keyPressed()
    {
        switch (key)
        {
            case 's':
                saveImage();
                break;
            case 'r':
                initialize();
                break;
            case 'q':
                exit();
                break;
            default:
                additionalKeyPressed();
                break;
        }
    }

    public void additionalKeyPressed() { /* none */ }
}
