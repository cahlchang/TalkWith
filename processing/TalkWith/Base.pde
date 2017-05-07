import java.util.*;
List<Integer> lstBowel = new ArrayList<Integer>();

void SetSimpleWorld() {
        String raw_text[] = loadStrings("time.conf");
        String raw_times = raw_text[0];
	
        String lstStrTime[] = split(raw_times, ',');
        for (String sTime : lstStrTime) {
                int time = Integer.parseInt(sTime);
                lstBowel.add(time);
        }
}

float timeStart = 0.0f;
float timePre = 0.0f;
float timeNow = 0.0f;
int frNow = 0;
int bwPre = -1;
Boolean flgOpen = false;
int posPre = 0;

void TimebaseEventHandler() {
        timeNow += (1.0 / frameRate);
        frNow++;
        float timeCheck = timeNow;

        if (0 <= frNow - lstBowel.size()) {
                TalkDefaultOff();
                bwPre = -1;
                flgOpen = false;
                return;
        }
		
        int bwNow = lstBowel.get(frNow);
        
        if (0 != bwNow - bwPre) {
                if ( bwNow == -1 && checkTalkOff(timeCheck, timePre)) {
                        TalkDefaultOff();
                        flgOpen = false;
                        bwPre = bwNow;
                        timePre = timeCheck;
                }
                else if( bwNow != -1 && checkTalkOn(timeCheck, timePre) ) {
                        TalkOn(bwNow);
                        flgOpen = true;
                        bwPre = bwNow;
                        timePre = timeCheck;
                }
        }
        else {
                if( flgOpen && checkTalkNaturalOff(timeNow, timePre) ) {
                        TalkDefaultOff();
                        bwPre = -1;
                        flgOpen = false;
                }
        }
}

float GetTimeNow() {
        return timeNow;
}

Boolean checkTalkOn(float tn, float tp) {
        if (0 < tp - tn + 0.1)
                return false;
	
        return true;
}

Boolean checkTalkOff(float tn, float tp) {
        if (0 < tp - tn + 0.12)
                return false;
	
        return true;
}

Boolean checkTalkNaturalOff(float tn, float tp) {
        if (0 < tp - tn + 0.08)
                return false;
	
        return true;
}
