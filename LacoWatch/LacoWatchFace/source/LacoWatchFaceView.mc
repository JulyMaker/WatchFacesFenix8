import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using TimeUtils as TU;
using Hands as H;
using Toybox.Graphics as G;
using ColorsUtils as C;



class LacoWatchFaceView extends WatchUi.WatchFace {

    var lay;
    var lacoDelegate;
    var LUME = C.hexToColor("#D4DEBA");       // crema vintage
    var LUME_DIM = C.hexToColor("#c7b98b");   // Nigtht mode cream
    var BACKGROUND = C.hexToColor("#222121"); // Background color
    var RECTDATECOLOR = C.hexToColor("#bdbaba");   // Rect date rectangle color
    var color;

    function initialize() {
        WatchFace.initialize();

        lacoDelegate = new LacoDelegate(self);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        lay = new Layout(dc.getWidth(), dc.getHeight());
        Fonts.init(lay);

        TU.initHours(lay.cx, lay.cy - lay.sy(10));
        TU.initMinutes(lay.cx, lay.cy - lay.sy(18));
        TU.initArrow(lay);
        TU.initMinuteTicks(lay);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function drawBackground(dc as Dc) {
        dc.setColor(BACKGROUND, BACKGROUND);
        dc.clear();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        drawBackground(dc);
        var timeData = TU.getTimeData();
        if((timeData[:h] < 22) && (timeData[:h] > 8)) { color = LUME_DIM; } else { color = LUME; }

        TU.drawHours(dc, color);                          // Hour numbers
        lay.drawCenterCircle(dc, lay.cx, lay.cy, color);  // Center Circle

        TU.drawMinutes(dc, color);                        // Minute numbers
        TU.drawTriangle12(dc, color);                     // Minute 12 triangle
        TU.drawMinuteTicks(dc, color);                    // Minute ticks  

        lay.drawRectDate(dc, RECTDATECOLOR);              // Date rectangle 
        TU.drawDate(dc, lay.cx, lay.top, timeData, G.COLOR_BLACK);       // Date text
        
        H.drawHand(dc,   H.hourHand, lay.cx, lay.cy, timeData[:hour], lay.hour,  0.5, color);
        H.drawHand(dc, H.minuteHand, lay.cx, lay.cy,  timeData[:min],  lay.min, 0.75, color);
        
        lay.drawCenter(dc, lay.cx, lay.cy, G.COLOR_BLACK);

        //lacoDelegate.drawZones(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
