import java.util.*;
PFont font;

float sp = second();
float mp = minute();
float hp = hour() % 12;
int cnt = 0;
int cntDisp = 0;

String rawText[];

void CreateTheater(String serifPath) {
        font = createFont("M+ 2p", 30);
        textFont(font);
        textSize(30);

        rawText = loadStrings(serifPath);
        // String rawText[] = loadStrings("time.conf");
        // String raw_times = raw_text[0];
}

void SetDebugMode() {
        float sn = second();
        cnt ++;
        if (0 != sn - sp)
        {
                cntDisp = cnt;
                cnt = 0;
        }
        sp = sn;
        fill(0);
        text("fps = " + cntDisp, width - 150, 80);
        fill(0);
        text("time = " + int(GetTimeNow()), width - 150, 120);
}

//Not implemented yet
void SetText ()
{
        // String[] fontList = PFont.list();
        // int a = 20;
        // printArray(fontList);


}				
