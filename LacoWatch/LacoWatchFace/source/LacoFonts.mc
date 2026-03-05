using Toybox.Graphics as G;

class Fonts {

    static var big;
    static var small;
    static var tiny;

    static function init(lay) {
        big   = G.getVectorFont({ :face =>"RobotoCondensedBold", :size => lay.sy(36) });
        small = G.getVectorFont({ :face =>["NotoSansHebrewBold", "RobotoCondensedBold"], :size => lay.sy(23) });
        tiny  = G.getVectorFont({ :face =>"RobotoCondensedBold", :size => lay.sy(17) });
    }
}