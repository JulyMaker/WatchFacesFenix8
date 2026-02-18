import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.Graphics as G;
using Toybox.Weather as W;
using Toybox.Time as Time;
using Toybox.Math;

using TimeUtils as TU;
using ActivityData;
using ActivityUtils;
using ArcUtils;
using MoonUtils as MU;
using WeatherUtils as WU;
using ColorsUtils as C;
using TinyFont as TF;
using BirthdayUtils as BU;

const CLICK_DEBUG = false;

class JulyWatchView extends WatchUi.WatchFace {

    var dca;
    var wfDelegate;
    var degMin = true;
    var degHour = true;
    var dirHour = true; // true=horz / false=vert
    
    function addIcon(id as Symbol, st as String){
        dca.register(self, id, st);
    }

    function addGroup(id as Symbol, str){
        var group = dca.getGroup(id);
        for (var i = 0; i < group.size(); i++){
            dca.register(self, group[i], str[i]);
        }
    }

    function loadIcons(){
        dca = DrawableCache.getInstance(); 
        var strAux;

        // Icons
        dca.registerGroup(:icons, [:steps,:heart,:dist, :stair, :batte, :sclock, :cronos,
        :bodyBatt, :stairs, :ssmall, :hsmall]);
        strAux = ["stepsicon", "hearthicon", "distanicon", "stairsicon","batteryicon", "clockicon",
        "cronoicon", "bodyBatt", "stairsicons", "stepicons", "hearthicons"];
        addGroup(:icons, strAux);

        // Moon icons
        // 0: nueva       (0.000 - 0.125)   1: crescent1 (0.125 - 0.250)   2: Cuarto crec (0.250 - 0.375)
        // 3: crescent2   (0.375 - 0.500)   4: full      (0.500 - 0.625)   5: menguante1  (0.625 - 0.750)
        // 6: Cuarto meng (0.750 - 0.875)   7: Menguante2(0.875 - 1.000)
        dca.registerGroup(:moon, [:moon0,:moon1,:moon2,:moon3,:moon4,:moon5,:moon6,:moon7]);
        strAux = ["moonvacia", "mooncrec1", "moonmediaD", "mooncrec2","moonllena","moondecre1",
        "moonmediaC", "moondecre2"];
        addGroup(:moon, strAux);
            
        // Weather icons
        dca.registerGroup(:weather, [:wea0,:wea1,:wea2,:wea3,:wea4,:wea5,:wea6,:wea7, :wea8,
        :wea9, :wea10, :wea11, :wea12, :wea13, :wea14, :wea15, :wea16, :wea17, :wea18, :wea19]);
        strAux = ["lunFog", "lunRayo", "lunNiebla", "lunLluvia", "lunNieve", "lun", "lunPNub",
         "lunNub", "solFog", "solNub", "solRayo", "solNiebla", "solLluvia", "solNieve", "solPNub",
          "sol", "Nuves", "Niebla", "Viento", "AguaNieve"];
        addGroup(:weather, strAux);

        addIcon(:birth, "birthdayicons");
    }

    function initialize() {
        WatchFace.initialize();

        wfDelegate = new WFDelegate();
        //setInputDelegate(wfDelegate);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        loadIcons();
    }

    // Clear Screen
    function clearScreen(dc as Dc) {
      dc.setColor(G.COLOR_BLACK, G.COLOR_BLACK);
      dc.clear();
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

    // Update the view
    function onUpdate(dc as Dc) as Void {
        clearScreen(dc);

        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;

        var timeData = TU.getTimeData();
        
        // Main Structure
        ActivityData.drawActivityData(dc, w, h, timeData, dca);
        drawSeparators(dc, w, h, cx, cy);
        TU.drawHours(dc, cx, cy - 110, timeData, dirHour, degHour);
        TU.drawMinutes(dc, cx, cy - 5, timeData, degMin);
        TU.drawDate(dc, cx, cy - 10, timeData);
       
        // Middle icons 
        WU.drawWeather(dc, dca, cx - 95, cy - 12, G.COLOR_WHITE);
        //dc.drawText(cx + 90, cy - 10, G.FONT_XTINY, WU.temp(), G.TEXT_JUSTIFY_CENTER);
        TF.drawText(dc, cx - 82, cy - 5, WU.temp(), 2, G.COLOR_YELLOW, 2.5);
        MU.drawMoon(dc, dca, cx + 68, cy - 9);
        dc.setColor(G.COLOR_YELLOW, G.COLOR_TRANSPARENT);
        dc.drawText(cx + 90, cy - 10, G.FONT_XTINY, ActivityUtils.getSolarIntensity(), G.TEXT_JUSTIFY_CENTER);
       
        // BirthDay
        var names = BU.getBirthday(dc, timeData, cx, cy, dca);
        if(names){TF.drawText(dc, cx - 82, cy - 80, names, 1, C.hexToColor("#e20e0e"), 3.5);}
        
        if(CLICK_DEBUG) {wfDelegate.drawZones(dc, G.COLOR_DK_RED);}

        // Icons and activity arcs
        ArcUtils.drawIconQ1(dc, cx, cy, dca.icon(:ssmall), G.COLOR_RED);
        ArcUtils.drawIconQ2(dc, cx, cy, dca.icon(:cronos), G.COLOR_BLUE);
        ArcUtils.drawIconQ3(dc, cx, cy, dca.icon(:bodyBatt), G.COLOR_GREEN);
        ArcUtils.drawIconQ4(dc, cx, cy, dca.icon(:stairs), G.COLOR_YELLOW);
        ArcUtils.drawArcSegments(dc, G.COLOR_RED, C.hexToColor("#7a1b04"), ActivityUtils.getActivityPercent(:steps), ArcUtils.quarter1(), false);
        ArcUtils.drawArcSegments(dc, G.COLOR_BLUE, C.hexToColor("#0f0d7c"), ActivityUtils.getActivityPercent(:activeMinutes), ArcUtils.quarter2(), true);
        ArcUtils.drawArcSegments(dc, G.COLOR_GREEN, G.COLOR_DK_GREEN, ActivityUtils.getActivityPercent(:bodyBatt), ArcUtils.quarter3(), false);
        ArcUtils.drawArcSegments(dc, G.COLOR_YELLOW, C.hexToColor("#a8760a"), ActivityUtils.getActivityPercent(:floor), ArcUtils.quarter4(), true);
    }

    function onTap(clickEvent) {
        System.println(clickEvent.getCoordinates()); // e.g. [36, 40]
        System.println(clickEvent.getType());        // CLICK_TYPE_TAP = 0
        return true;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        dca.clearAll();
        dca = null;
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
