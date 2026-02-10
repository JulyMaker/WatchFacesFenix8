import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.Graphics as G;
using Toybox.Weather as W;
using TimeUtils;
using ActivityData;
using ActivityUtils;
using ArcUtils;
using Toybox.Math;

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
    function drawHours(dc, x, y, text) {
        var font = G.FONT_NUMBER_THAI_HOT;
        
        // Colores del degradado (arriba → abajo)
        var topColor    = Graphics.COLOR_DK_BLUE;
        var middleColor = Graphics.COLOR_BLUE;
        var bottomColor = Graphics.COLOR_DK_RED;
    
        // Arriba
        dc.setColor(topColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 2, font, text, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x, y - 1, font, text, Graphics.TEXT_JUSTIFY_CENTER);
    
        // Centro (laterales)
        dc.setColor(middleColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - 1, y, font, text, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x + 1, y, font, text, Graphics.TEXT_JUSTIFY_CENTER);
    
        // Abajo
        dc.setColor(bottomColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 1, font, text, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x, y + 2, font, text, Graphics.TEXT_JUSTIFY_CENTER);
    
        // Centro vacío
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, text, Graphics.TEXT_JUSTIFY_CENTER);
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
           //,secStr
       ]);
   
       dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
       dc.drawText(cx, y, G.FONT_XTINY, dateStr, G.TEXT_JUSTIFY_CENTER);
    }

    //function drawMoon(dc, x, y) {
//
    //    var phase = W.get
    //    if (phase == null) {return 0.0;}
    //
    //
    //
    //    var icon = moonIcons[phase];
    //
    //
    //
    //    dc.drawBitmap(x, y, icon);
    //
    //}

    function hexToColor(hex as String) {
        hex = hex.substring(1, hex.length());
        
        var r = hex.substring(0, 2).toNumberWithBase(16);
        var g = hex.substring(2, 4).toNumberWithBase(16);
        var b = hex.substring(4, 6).toNumberWithBase(16);
        
        return G.createColor( 0xFF, r, g, b);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        clearScreen(dc);

        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;

        var timeData = TimeUtils.getTimeData();
    
        var hourStr = timeData[:hour] < 10
            ? "0" + timeData[:hour]
            :timeData[:hour].toString();
        var minStr  = timeData[:min] < 10
            ? "0" + timeData[:min]
            : timeData[:min].toString();
    
        // Dibujo principal
        var icons = {} as Dictionary<Symbol, Text>;
        icons[:steps] = View.findDrawableById("stepsicon")  as Text;
        icons[:heart] = View.findDrawableById("hearthicon") as Text;
        icons[:dist]  = View.findDrawableById("distanicon") as Text;
        icons[:stair] = View.findDrawableById("stairsicon") as Text;
        icons[:batte] = View.findDrawableById("batteryicon") as Text;
        icons[:sclock] = View.findDrawableById("clockicon") as Text;


        icons[:cronos] = View.findDrawableById("cronoicon") as Text;
        icons[:bodyBatt] = View.findDrawableById("bodyBatt") as Text;
        icons[:stairs] = View.findDrawableById("stairsicons") as Text;

        icons[:ssmall] = View.findDrawableById("stepicons") as Text;
        icons[:hsmall] = View.findDrawableById("hearthicons") as Text;

        ActivityData.drawActivityData(dc, w, h, timeData, icons);
        drawHours(dc, cx, cy - 110, hourStr);
        drawSeparators(dc, w, h, cx, cy);
        drawDate(dc, cx, cy - 10, timeData);
        drawMinutes(dc, cx, cy - 5, minStr);
       
        dc.drawText(cx - 100, cy - 10, G.FONT_XTINY, ActivityUtils.getSolarIntensity(), G.TEXT_JUSTIFY_CENTER);

        // Dibujo de los iconos y las barras de actividad
        ArcUtils.drawIconQ1(dc, cx, cy, icons[:ssmall], G.COLOR_RED);
        ArcUtils.drawIconQ2(dc, cx, cy, icons[:cronos], G.COLOR_BLUE);
        ArcUtils.drawIconQ3(dc, cx, cy, icons[:bodyBatt], G.COLOR_GREEN);
        ArcUtils.drawIconQ4(dc, cx, cy, icons[:stairs], G.COLOR_YELLOW);
        ArcUtils.drawArcSegments(dc, G.COLOR_RED, hexToColor("#7a1b04"), ActivityUtils.getActivityPercent(:steps), ArcUtils.quarter1(), false);
        ArcUtils.drawArcSegments(dc, G.COLOR_BLUE, hexToColor("#0f0d7c"), ActivityUtils.getActivityPercent(:activeMinutes), ArcUtils.quarter2(), true);
        ArcUtils.drawArcSegments(dc, G.COLOR_GREEN, G.COLOR_DK_GREEN, ActivityUtils.getActivityPercent(:bodyBatt), ArcUtils.quarter3(), false);
        ArcUtils.drawArcSegments(dc, G.COLOR_YELLOW, hexToColor("#a8760a"), ActivityUtils.getActivityPercent(:floor), ArcUtils.quarter4(), true);

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
