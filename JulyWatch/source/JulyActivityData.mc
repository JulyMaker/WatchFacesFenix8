using Toybox.ActivityMonitor;
using Toybox.Time as T;
using Toybox.Graphics as G;
using Toybox.WatchUi;
using Toybox.System as S;

using Toybox.Math;
using Toybox.SensorHistory as H;

using ColorsUtils as C;

module SensorUtils{

    function getActivitySensor(){
        return ActivityMonitor.getInfo();
    }

    function getHRSensor(){
        var hrHistory = ActivityMonitor.getHeartRateHistory(1, true);
        var hrSample = hrHistory.next();
        if (hrSample != null && hrSample.heartRate != null) {
            return hrSample.heartRate;
        }

        return 0.0;
    }

    function getBodyBattery(){     
        var history = H.getBodyBatteryHistory({
            :period => 1, // Último dato
            :order => H.ORDER_NEWEST_FIRST
        });
        
        if (history != null) {
            var sample = history.next();
            if (sample != null && sample.data != null) {
                return sample.data;
            }
        }
        
        return 0.0;
    }

    function getStatsSensor(){    // Battery and Solar intensity 
        return S.getSystemStats();
    }
}

module ActivityData {

    var cy    ;
    var cx    ;
    var leftX ;
    var rightX;
    var dataYU;
    var dataYD;

    var hasHeartRate;
    var hasBoddyBatt;
    var hasSolarInt;

    var HRSensor;
    var activitySensor;
    var bodyBattSensor;
    var statsSensor;
    var distanceFont;
    //var fakeBB;

    function initialize(width, height){
        cy = height / 2;
        cx = width / 2;
        leftX = width * 0.20;
        rightX = width * 0.80;
        dataYU = cy - 40;
        dataYD = cy + 20;
        //fakeBB = 100;

        hasHeartRate = ActivityMonitor has :getHeartRateHistory;
        hasBoddyBatt = H has :getBodyBatteryHistory;
        hasSolarInt  = S.getSystemStats() has :solarIntensity;
        distanceFont = WatchUi.loadResource(Rez.Fonts.distanceFont);

        HRSensor = 0;
        activitySensor = 0;
        bodyBattSensor = 0;
        statsSensor = 0;
    }

    // Sensors 
    function getHRSensor(){
        HRSensor = SensorUtils.getHRSensor();
    }
    
    function getActivitySensor(){
        activitySensor= SensorUtils.getActivitySensor();
    }

    function getBodyBattery(){
        //if(fakeBB > 0){ fakeBB = (fakeBB - 10);}
        //bodyBattSensor = fakeBB;
        bodyBattSensor = SensorUtils.getBodyBattery();
    }

    function getStatsSensor(){
        statsSensor = SensorUtils.getStatsSensor();
    }

    // Draw activities
    function drawMoveActivity(dc, dca, dirty){
        if(dirty == 0) {return ;}

        // Pasos
        if (dirty & 0x01){ drawActivityData(dc, leftX, dataYU, activitySensor.steps, G.COLOR_BLUE); }
        // Distancia
        if (dirty & 0x02){ drawUnitsData(dc, cx, dataYU - 68, activitySensor.distance, C.hexToColor("#eeaa17")); }
        // Escaleras
        if (dirty & 0x04){ drawActivityData(dc, leftX, dataYD, activitySensor.floorsClimbed, G.COLOR_WHITE); }
    }

    function drawIcon(dc, x, y, dca, color, iconPos, type)
    {
        var icon = dca.icon(type);
        icon.locY = y - iconPos;
        icon.locX = x;
        icon.draw(dc);
    }

    function drawActivityData(dc, x, y, data, color){
        dc.setColor(color, G.COLOR_TRANSPARENT);
        var dataStr = data.format("%d");
        dc.drawText(x, y, G.FONT_XTINY, dataStr, G.TEXT_JUSTIFY_CENTER);
    }

    function drawUnitsData(dc, x, y, data, color) {
        dc.setColor(color, G.COLOR_TRANSPARENT);

        var units = "m";
        var dataStr = data.format("%d");
        
        if (data > 1000) {
            units = "km";
            data = data / 1000;  
            dataStr = data.format("%.1f");
        }
        
        dc.drawText(x, y, distanceFont, "#" + dataStr + units, G.TEXT_JUSTIFY_CENTER);
    }  

    function min(a, b) {
        return a < b ? a : b;
    }

    function getActivityPercent(activity) {
        if (activitySensor == null) { return 0.0; }

        var percent = 1.0;
        var value = 0;
        var goal = 0;
        
        switch(activity){
            case  :steps:
                value = activitySensor.steps;
                goal = activitySensor.stepGoal;
                break;
            case  :floor:
                value = activitySensor.floorsClimbed;
                goal = activitySensor.floorsClimbedGoal;
                break;
            case :activeMinutes:
                value = activitySensor.activeMinutesWeek.total;
                goal = activitySensor.activeMinutesWeekGoal;
                break;
            case :bodyBatt:
                value = bodyBattSensor;
                goal = 100.0;
                break;
            
        }
            
        if (goal > 0) {
            percent = min(1.0, (value.toFloat() / goal.toFloat()));
        }

        return percent;
    }
}