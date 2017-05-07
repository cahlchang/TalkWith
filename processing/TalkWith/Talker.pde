String lblDefaultOff = "defaull_off";
String lblDefaultOn = "defaull_on";

String lblNow = lblDefaultOff;
List<PGraphics> lstImageDefault = new ArrayList<PGraphics>();
List<List> lstImageVowel = new ArrayList<List>();
PGraphics imgNow;

void CreateSampleImage(){
        lstImageDefault.add(createImageSymbol("base_default.1.png", 1));
        lstImageDefault.add(createImageSymbol("base_default.0.png", 1));

        lstImageVowel.add(createGraphicsList(new String[]{"base_a.0.png", "base_a.1.png"}));
        lstImageVowel.add(createGraphicsList(new String[]{"base_i.0.png", "base_i.1.png"}));
        lstImageVowel.add(createGraphicsList(new String[]{"base_u.0.png", "base_u.1.png"}));
        lstImageVowel.add(createGraphicsList(new String[]{"base_e.0.png", "base_e.1.png"}));
        lstImageVowel.add(createGraphicsList(new String[]{"base_o.0.png", "base_o.1.png"}));

        for (PGraphics pg : lstImageDefault) {
                canvas.image(pg, 0, height - pg.height);
        }
    
        for (List<PGraphics> list : lstImageVowel) {
                for (PGraphics pg : list) {
                        canvas.image(pg, 0, height - pg.height);
                }
        }

        imgNow = lstImageDefault.get(0);
}

int iPos = 0;
int iVowelNow = -1;
int iVowelPre = -1;
void TalkEventHandler() {
        if (lblNow == lblDefaultOff) {
                if (0 != lstImageDefault.size() - iPos) {
                        imgNow = lstImageDefault.get( iPos );
                }

                canvas.image(imgNow, 0, height - imgNow.height);
	
                if (0 != iPos - lstImageDefault.size())
                        iPos++;
        }
        else if(lblNow == lblDefaultOn) {
                if (0 != iVowelPre - iVowelNow) {
                        List<PGraphics> lst = lstImageVowel.get( iVowelNow );
                        imgNow = lst.get( iPos );
                        iVowelPre = iVowelNow;
                }
	
                canvas.image(imgNow, 0, height - imgNow.height);
                
                if (0 != iPos - 2)
                        iPos++;

        }
}

List<PGraphics> createGraphicsList(String[] aryPath) {
        ArrayList list = new ArrayList<PGraphics>(){};

        for (String pathImage : aryPath) {
                list.add(createImageSymbol(pathImage, 1));
        }
    
        return list;
}

void TalkOn(int i) {
        if ( lblNow == lblDefaultOn &&  iVowelNow == i)
                return;
    
        iVowelNow = i;
        iPos = 0;
        lblNow = lblDefaultOn;
}

void TalkDefaultOff() {
        if ( lblNow == lblDefaultOff )
                return;

        iPos = 0;
        lblNow = lblDefaultOff;
}
