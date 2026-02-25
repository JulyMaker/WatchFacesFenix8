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
using ActivityData as AD;
using SensorUtils as SU;
using ArcUtils;
using MoonUtils as MU;
using WeatherUtils as WU;
using ColorsUtils as C;
using TinyFont as TF;
using BirthdayUtils as BU;
using Prof as P;

const DEGMIN = true;
const DEGHOUR = true;
const DIRHOUR = true; // true=horz / false=vert

class JulyWatchView extends WatchUi.WatchFace {
    var dca;
    var wfDelegate;
    var zon;
    
    var settings;

    var arcSteps ;
    var arcActMin;
    var arcFloor ;
    var arcBody  ;

    var minCCache  ;
    var hourCCache ;

    var w;
    var h;
    var cx;
    var cy;
    var font;

    function initialize() {
        WatchFace.initialize();
        wfDelegate = new WFDelegate(self);

        settings = Settings.get();
        font = G.getVectorFont({ :face =>"RobotoCondensedBold", :size => 16});

        arcSteps  = new ArcState();
        arcActMin = new ArcState();
        arcFloor  = new ArcState();
        arcBody   = new ArcState();

        minCCache = new ColorCache();
        hourCCache= new ColorCache();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        if (dca == null) { loadIcons(); }
        zon = new ZonesMap();
        //arcSteps  = new ArcState();
        //arcActMin = new ArcState();
        //arcFloor  = new ArcState();
        //arcBody   = new ArcState();

        clearScreen(dc);
        w = dc.getWidth();
        h = dc.getHeight();
        cx = w / 2;
        cy = h / 2;
        
        // Separators lines
        drawSeparators(dc, w, h, cx, cy);

        // Activity icons
        AD.initialize(w, h);
        AD.drawIcon(dc, AD.leftX, AD.dataYU, dca, G.COLOR_BLUE, 23, :steps);
        AD.drawIcon(dc, AD.rightX, AD.dataYU, dca, G.COLOR_RED, 23, :heart);
        AD.drawIcon(dc, AD.leftX, AD.dataYD, dca, G.COLOR_WHITE, -22, :stair);

        // heartRate init
        dc.setColor(G.COLOR_RED, G.COLOR_TRANSPARENT);
        dc.drawText(AD.rightX, AD.dataYU, G.FONT_XTINY, "--", G.TEXT_JUSTIFY_CENTER);

        // Icons in arcs
        ArcUtils.drawIconQ1(dc, cx, cy, dca.icon(:ssmall), G.COLOR_RED);
        ArcUtils.drawIconQ2(dc, cx, cy, dca.icon(:cronos), G.COLOR_BLUE);
        ArcUtils.drawIconQ3(dc, cx, cy, dca.icon(:bodyBatt), G.COLOR_GREEN);
        ArcUtils.drawIconQ4(dc, cx, cy, dca.icon(:stairs), G.COLOR_YELLOW);
        // Draw Activity arcsv
        AD.getActivitySensor();
        ArcUtils.drawArcSegments(dc, G.COLOR_RED, C.hexToColor("#7a1b04"), AD.getActivityPercent(:steps), ArcUtils.quarter1(), false, arcSteps);
        ArcUtils.drawArcSegments(dc, G.COLOR_BLUE, C.hexToColor("#0f0d7c"), AD.getActivityPercent(:activeMinutes), ArcUtils.quarter2(), true, arcActMin);
        ArcUtils.drawArcSegments(dc, G.COLOR_GREEN, G.COLOR_DK_GREEN, AD.getActivityPercent(:bodyBatt), ArcUtils.quarter3(), false, arcBody);
        ArcUtils.drawArcSegments(dc, G.COLOR_YELLOW, C.hexToColor("#a8760a"), AD.getActivityPercent(:floor), ArcUtils.quarter4(), true, arcFloor);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        //if(dca == null) { loadIcons(); }
        //if(zon        == null){zon = new ZonesMap();}
        //if(arcSteps   == null){arcSteps  = new ArcState();}
        //if(arcActMin  == null){arcActMin = new ArcState();}
        //if(arcFloor   == null){arcFloor  = new ArcState();}
        //if(arcBody    == null){arcBody   = new ArcState();}
        //if(minCCache  == null){minCCache = new ColorCache();}
        //if(hourCCache == null){hourCCache= new ColorCache();}
    }

    // Clear Screen
    function clearScreen(dc as Dc) {
      dc.setColor(G.COLOR_BLACK, G.COLOR_BLACK);
      dc.clear();
    }
    function clearZone(dc as Dc, x, y, w, h) {
        dc.setColor(G.COLOR_BLACK, G.COLOR_BLACK);
        dc.fillRectangle(x, y, w, h);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        //clearScreen(dc);

        var timeData = TU.getTimeData();
        
        // Main Structure
        if (zon.get(:hour).hasChanged(timeData[:hour])) {
            var tens = timeData[:hour] / 10;
            if(zon.get(:hour2).hasChanged(tens))
            {
                zon.get(:hour).clear(dc);
                TU.drawHours(dc, cx, cy - 110, timeData, DIRHOUR, DEGHOUR, hourCCache);
            }else{
                zon.get(:hour2).clear(dc);
                TU.drawHour(dc, cx + 28, cy - 110, timeData, DIRHOUR, DEGHOUR, hourCCache);
            }
        }

        if (zon.get(:min).hasChanged(timeData[:min])) {
            var tens = timeData[:min] / 10;
            if(zon.get(:min2).hasChanged(tens))
            {
                zon.get(:min).clear(dc);
                TU.drawMinutes(dc, cx, cy - 5, timeData, DEGMIN, minCCache);
            }else{
                zon.get(:min2).clear(dc);
                TU.drawMinute(dc, cx + 28, cy - 5, timeData, DEGMIN, minCCache);
            }    
        }

        if (zon.get(:dateFi).hasChanged(timeData[:day])) {
            zon.get(:dateFi).clear(dc);
            zon.get(:sun).clear(dc);
            zon.get(:moon).clear(dc);
            zon.get(:birthday).clear(dc);

            TU.drawDate(dc, cx, cy - 10, timeData);  // Date   
            TU.drawSunTimes(dc, cx, cy + 90);        // SunTimes
            MU.drawMoon(dc, dca, cx + 68, cy - 9);   // Moon
            var names = BU.getBirthday(dc, timeData, cx, cy, dca); // BirthDay
            if(names){TF.drawText(dc, cx - 82, cy - 80, names, 1, C.hexToColor("#e20e0e"), 3.5);}

            // Draw Activity arcs
            ArcUtils.drawArcSegments(dc, G.COLOR_RED, C.hexToColor("#7a1b04"), AD.getActivityPercent(:steps), ArcUtils.quarter1(), false, arcSteps);
            ArcUtils.drawArcSegments(dc, G.COLOR_BLUE, C.hexToColor("#0f0d7c"), AD.getActivityPercent(:activeMinutes), ArcUtils.quarter2(), true, arcActMin);
            ArcUtils.drawArcSegments(dc, G.COLOR_GREEN, G.COLOR_DK_GREEN, AD.getActivityPercent(:bodyBatt), ArcUtils.quarter3(), false, arcBody);
            ArcUtils.drawArcSegments(dc, G.COLOR_YELLOW, C.hexToColor("#a8760a"), AD.getActivityPercent(:floor), ArcUtils.quarter4(), true, arcFloor);
        }
        if(settings.clearBirth){ zon.get(:birthday).clear(dc); }

        if (zon.getT(:weatherT).timer(timeData[:now])) { // Weather and temp 4h
            WU.getCondition(); // higth cost

            if(zon.get(:weatIco).hasChanged(WU.conditions.condition) ||
            zon.get(:weatTmp).hasChanged(WU.conditions.temperature)){
                zon.get(:weatIco).clear(dc);
                WU.drawWeatherIco(dc, dca, cx - 95, cy - 10, G.COLOR_WHITE);
                TF.drawText(dc, cx - 82, cy - 5, WU.temp(), 1.8, G.COLOR_YELLOW, 2.5);
            }
        }

        if (zon.getT(:activityT).timer(timeData[:now])) { // Move Activity
            AD.getActivitySensor(); // higth cost
            
            var dirty = 0;
            if(zon.get(:field1).hasChanged(AD.activitySensor.steps)){         dirty |= 0x01; zon.get(:field1).clear(dc);}
            if(zon.get(:field2).hasChanged(AD.activitySensor.distance)){      dirty |= 0x02; zon.get(:field2).clear(dc);}
            if(zon.get(:field5).hasChanged(AD.activitySensor.floorsClimbed)){ dirty |= 0x04; zon.get(:field5).clear(dc);}

            AD.drawMoveActivity(dc, dca, dirty);

            // Activity arcs
            ArcUtils.updateArcSegments(dc, G.COLOR_RED, C.hexToColor("#7a1b04"), AD.getActivityPercent(:steps), ArcUtils.quarter1(), false, arcSteps);
            ArcUtils.updateArcSegments(dc, G.COLOR_BLUE, C.hexToColor("#0f0d7c"), AD.getActivityPercent(:activeMinutes), ArcUtils.quarter2(), true, arcActMin);
            ArcUtils.updateArcSegments(dc, G.COLOR_YELLOW, C.hexToColor("#a8760a"), AD.getActivityPercent(:floor), ArcUtils.quarter4(), true, arcFloor);
        }

        if (zon.getT(:frecHRT).timer(timeData[:now])) { // Freq HR 10s
            AD.getHRSensor(); // higth cost
            
            if(zon.get(:field3).hasChanged(AD.HRSensor)){ // Frecuencia cardiaca
                zon.get(:field3).clear(dc);

                AD.drawActivityData(dc, AD.rightX, AD.dataYU, AD.HRSensor, G.COLOR_RED);
            }
        }

        if (zon.getT(:solarT).timer(timeData[:now])) {     //  1min
            if(AD.hasSolarInt){     
                AD.getStatsSensor(); // higth cost

                if(zon.get(:solar).hasChanged(AD.statsSensor.solarIntensity)){ // Nivel intensidad solar
                    zon.get(:solar).clear(dc);
                    dc.setColor(G.COLOR_YELLOW, G.COLOR_TRANSPARENT);
                    
                    dc.drawText(cx + 90, cy - 10, font, AD.statsSensor.solarIntensity, G.TEXT_JUSTIFY_CENTER);
                }
            }
            
            if(zon.get(:battChg).hasChanged(AD.statsSensor.charging)){ // Nivel de batería            
                if(AD.statsSensor.charging){
                    AD.drawIcon(dc, AD.rightX + 8, AD.dataYD + 23, dca, G.COLOR_WHITE, 0, :bCharg);
                }else{
                    zon.get(:battChg).clear(dc);
                }
            }
        }

        if (zon.getT(:batteryT).timer(timeData[:now])) {  // Bateria 2min
            if(!AD.hasSolarInt){ AD.getStatsSensor(); }   // higth cost

            var batteryLevel = AD.statsSensor.battery;
            
            if(zon.get(:field4).hasChanged(batteryLevel)){ // Nivel de batería
                zon.get(:field4).clear(dc);
                AD.drawActivityData(dc, AD.rightX, AD.dataYD, batteryLevel, G.COLOR_WHITE);

                if( zon.get(:field6).changed(batteryLevel, 10) ){
                    zon.get(:field6).clear(dc);
                    TF.drawBatteryV(dc, AD.rightX - 3, AD.dataYD + 23, batteryLevel, 2, G.COLOR_WHITE);
                } 
            }
        }
          
        if (zon.getT(:bodybatT).timer(timeData[:now])) {  // Body Batt 5min
            AD.getBodyBattery(); // higth cost
            ArcUtils.updateArcSegments(dc, G.COLOR_GREEN, G.COLOR_DK_GREEN, AD.getActivityPercent(:bodyBatt), ArcUtils.quarter3(), false, arcBody);
        }

        if(settings.clickDeb) {wfDelegate.drawZones(dc, G.COLOR_DK_RED);} else{ wfDelegate.clearZones(dc);}
        if(settings.zonesDebug) {zon.drawZones(dc);}else{zon.clearZones(dc);}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        //if (dca != null){
        //    dca.clearAll();
        //    dca = null;
        //}
        //
        //zon = null;
        //
        //arcSteps  = null;
        //arcActMin = null;
        //arcFloor  = null;
        //arcBody   = null;
        //
        //minCCache  = null;
        //hourCCache = null;
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        settings.readSettings();
        if(zon== null){ zon = new ZonesMap();}
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

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
        dca.registerGroup(:icons, [:steps,:heart, :stair, :batte, :sclock, :cronos,
        :bodyBatt, :stairs, :ssmall, :hsmall]);
        strAux = ["stepsicon", "hearthicon", "stairsicon","batteryicon", "clockicon",
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
        addIcon(:bCharg, "batChargeicon");

        //addIcon(:disAB, "disAB");
        //addIcon(:disABC,"disABC");
    }

    // Draw separators
    function drawSeparators(dc, width, height, cx, cy) {
       // Guiones laterales
       dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
       dc.drawText(5        , cy - 20, G.FONT_MEDIUM, "-", G.TEXT_JUSTIFY_LEFT);
       dc.drawText(width - 5, cy - 20, G.FONT_MEDIUM, "-", G.TEXT_JUSTIFY_RIGHT);
       
       var markHeight = 8;
       for (var i = 0; i < 4; i++) {
         dc.drawLine(cx - i,                   0, cx - i, markHeight);
         dc.drawLine(cx - i, height - markHeight, cx - i, height);
       }

       // Barras horizontales
       var barX = 15;
       var barW = width - 30;
       var barTopY = cy - 12;
       var barBottomY = cy + 12;

       dc.setColor(G.COLOR_LT_GRAY, G.COLOR_TRANSPARENT);
       dc.drawLine(barX, barTopY, barX + barW, barTopY);
       dc.drawLine(barX, barBottomY, barX + barW, barBottomY);
    }

    function reloadSettings() {
        settings.readSettings();
    }
}
