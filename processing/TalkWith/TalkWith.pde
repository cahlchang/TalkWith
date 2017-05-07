import ddf.minim.*;
import java.util.*;

Minim minim;
AudioPlayer player;

int widthStage = 1200;
int heightStage = 800;
PGraphics canvas;

void setup() {
        size(1200, 800);
        frameRate(30);

        noFill();
        smooth();
        viewMode();
}

Boolean isView = false;

void viewMode() {
        canvas = createGraphics(widthStage, heightStage, JAVA2D);
        canvas.beginDraw();
        canvas.background(110,110,110,50);
        
        isView = true;
        minim = new Minim(this);
        CreateSampleImage();
        //not implemet yet
        //CreateTheater("sample_serif.txt");
        SetSimpleWorld();
        player = minim.loadFile("test3.mp3");
        player.play();
}

void readyMode() {
        CreateReadyImage();
}

void draw() {
        //backgroud view
        background(0,0,0);
        canvas.beginDraw();
        canvas.background(110,110,110,50);
        
        TimebaseEventHandler();
        TalkEventHandler();
        SetDebugMode();
        
        canvas.endDraw();
        image(canvas, 0, 0);
        canvas.save("frames/" + nf(frameCount, 6, 0) + ".png");

        // alpha channel not work...
        // saveFrame("frames/######.png");
}
