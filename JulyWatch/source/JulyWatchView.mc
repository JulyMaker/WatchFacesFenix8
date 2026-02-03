import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.Graphics as G;
using TimeUtils;
using ActivityData;

class JulyWatchView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Clear Screen
    function clearScreen(dc as Dc) {
      dc.setColor(G.COLOR_BLACK, G.COLOR_BLACK);
      dc.clear();
    }

    // Draw Hours
    function drawHours(dc, cx, y, hourStr) {
        dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
        dc.drawText(cx, y, G.FONT_NUMBER_THAI_HOT, hourStr, G.TEXT_JUSTIFY_CENTER);
    }

    // Draw Minutes 
    function drawMinutes(dc, cx, y, minStr) {
        dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
        dc.drawText(cx, y, G.FONT_NUMBER_THAI_HOT, minStr, G.TEXT_JUSTIFY_CENTER);
    }

    // Draw separators
    function drawSeparators(dc, width, height, cx, cy) {
       // Guiones laterales
       dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
       dc.drawText(5        , cy - 20, G.FONT_MEDIUM, "-", G.TEXT_JUSTIFY_LEFT);
       dc.drawText(width - 5, cy - 20, G.FONT_MEDIUM, "-", G.TEXT_JUSTIFY_RIGHT);
       
       var markHeight = 8;
       dc.drawLine(cx, 0, cx, markHeight);
       dc.drawLine(cx-1, 0, cx-1, markHeight);
       dc.drawLine(cx-2, 0, cx-2, markHeight);
       dc.drawLine(cx-3, 0, cx-3, markHeight);
       
       dc.drawLine(cx, height - markHeight, cx, height);
       dc.drawLine(cx-1, height - markHeight, cx-1, height);
       dc.drawLine(cx-2, height - markHeight, cx-2, height);
       dc.drawLine(cx-3, height - markHeight, cx-3, height);

       // Barras horizontales
       var barX = 15;
       var barW = width - 30;
       var barTopY = cy - 12;
       var barBottomY = cy + 12;

       dc.setColor(G.COLOR_LT_GRAY, G.COLOR_TRANSPARENT);
       dc.drawLine(barX, barTopY, barX + barW, barTopY);
       dc.drawLine(barX, barBottomY, barX + barW, barBottomY);
    }

    // Draw date with seconds
    function drawDate(dc, cx, y, timeData) {
       var dayWeek = WatchUi.loadResource(
           Rez.Strings[TimeUtils.getDaySymbol(timeData[:dateShort].day_of_week)]
       );
   
       //var secStr = timeData[:sec].format("%02d");
   
       //var dateStr = Lang.format("$1$ $2$ $3$   $4$", [
       var dateStr = Lang.format("$1$ $2$ $3$", [
           dayWeek,
           timeData[:date].day,
           timeData[:date].month
           //secStr
       ]);
   
       dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
       dc.drawText(cx, y, G.FONT_XTINY, dateStr, G.TEXT_JUSTIFY_CENTER);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        clearScreen(dc);

        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;

        dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT); 
        dc.drawArc(cx, cy-40, cx, Graphics.ARC_CLOCKWISE, 268, 266 - (100/56));


        var timeData = TimeUtils.getTimeData();
    
        var hourStr = timeData[:hour].toString();
        var minStr  = timeData[:min] < 10
            ? "0" + timeData[:min]
            : timeData[:min].toString();
    
        // Dibujo principal
        var icons = {} as Dictionary<Symbol, Text>;
        icons[:steps] = View.findDrawableById("stepsicon") as Text;
        icons[:heart] = View.findDrawableById("hearthicon") as Text;
        icons[:dist] = View.findDrawableById("distanicon") as Text;


        ActivityData.drawActivityData(dc, w, h, timeData, icons);
        drawHours(dc, cx, cy - 110, hourStr);
        drawSeparators(dc, w, h, cx, cy);
        drawDate(dc, cx, cy - 10, timeData);
        drawMinutes(dc, cx, cy - 5, minStr);
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
