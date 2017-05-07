PGraphics createImageSymbol(String nameImage, float nScale) {
        PImage pi = loadImage(nameImage);
        pi.resize(int(pi.width * nScale), int(pi.height * nScale));

        PGraphics pg = createGraphics(pi.width, pi.height);
        pg.beginDraw();
        pg.image(pi, 0, 0);
        pg.endDraw();

        return pg;
}

// String pathGen = "data/gen/";

Map<String, String> mapVowel = new HashMap<String, String>() {
        {
                put("default", "_1.3_default.");
                put("a", "_1.3_a.");
                put("i", "_1.3_i.");
                put("u", "_1.3_u.");
                put("e", "_1.3_e.");
                put("o", "_1.3_o.");
        }
};

void CreateReadyImage() {
        String nameBase = "base";
        String nameExt = ".png";

        for (String key : mapVowel.keySet() ) {
                for (int i = 0; i < 2; i++) {
                        String value = mapVowel.get( key );
                        String[] ary = {"base.png", value + i + nameExt};
                        PGraphics pg = getReadyImage(ary);
                        pg.save("data/gen/" + nameBase + "_" + key + "." + i + nameExt);
                }
        }

        println("end");
}

PGraphics getReadyImage(String[] aryPath) {
        List<PImage> lstImage= new ArrayList<PImage>();
    
        for (String path : aryPath) {
                lstImage.add(loadImage("templete/" + path));
        }
    
        PImage piOrg = lstImage.get(0);
    
        float nshOrg = 600;
        float nScale = nshOrg / piOrg.height;
        int nsh = 600;
        int nsw = int(piOrg.width * nScale);
    
        PGraphics pg = createGraphics(nsw, nsh);
        pg.beginDraw();
    
        for (PImage pi : lstImage) {
                pi.resize(nsw, nsh);
                pg.image(pi, 0, 0);
        }
        pg.endDraw();

        return pg;
}
