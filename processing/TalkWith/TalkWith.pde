import ddf.minim.*;
import java.util.*;

Minim minim;
AudioPlayer player;

int widthStage = 1200;
int heightStage = 800;

void setup()
{
        size(1200, 800);
        frameRate(30);

        viewMode();
}

Boolean isView = false;

void viewMode()
{
        isView = true;
        minim = new Minim(this);
        CreateSampleImage();
        //not implemet yet
        //CreateTheater("sample_serif.txt");
        SetSimpleWorld();
        player = minim.loadFile("test3.mp3");
        player.play();
}

void readyMode()
{
        CreateReadyImage();
}

void draw()
{
        background(240);

        if (! isView)
                return;

        TimebaseEventHandler();
        TalkEventHandler();
        SetDebugMode();
        // if (mousePressed == true)
        // {
        // 		 image(p_img_on, 0, 0);
        // 		 //
        // 		 // img_on.tint(255,0);
        // }
        // else
        // {
        // 		 image(p_img_off, 0, 0);
        // 		 // img_off.tint(255,0);

        saveFrame("frames/######.tif");
}
