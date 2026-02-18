using Toybox.ActivityMonitor;
using Toybox.Time as T;
using Toybox.Graphics as G;
using Toybox.WatchUi;
using Toybox.System as S;
using Toybox.Position as P;
using Toybox.Weather as W;
using Toybox.Math;
using Toybox.SensorHistory as H;

using TinyFont as TF;

module ActivityUtils{

    function min(a, b) {
        return a < b ? a : b;
    }

    // Obtener el último valor de Body Battery
    function getBodyBattery(){
        var bodyBattery = 0.0;
        
        // Verificar si el sensor está disponible
        if (H has :getBodyBatteryHistory) {
            var history = H.getBodyBatteryHistory({
                :period => 1, // Último dato
                :order => H.ORDER_NEWEST_FIRST
            });
            
            if (history != null) {
                var sample = history.next();
                if (sample != null && sample.data != null) {
                    bodyBattery = sample.data;
                }
            }
        }
        
        return bodyBattery;
    }

    function getActivityPercent(activity) {
        var activityInfo = ActivityMonitor.getInfo();
        if (activityInfo == null) { return 0.0; }

        var percent = 1.0;
        var value = 0;
        var goal = 0;
        
        switch(activity){
            case  :steps:
                value = activityInfo.steps;
                goal = activityInfo.stepGoal;
                break;
            case  :floor:
                value = activityInfo.floorsClimbed;
                goal = activityInfo.floorsClimbedGoal;
                break;
            case :activeMinutes:
                value = activityInfo.activeMinutesWeek.total;
                goal = activityInfo.activeMinutesWeekGoal;
                break;
            case :bodyBatt:
                value = getBodyBattery();
                goal = 100.0;
                break;
            
        }
            
        if (goal > 0) {
            percent = min(1.0, (value.toFloat() / goal.toFloat()));
        }

        return percent;
    }

    function getSolarIntensity() {
        var solarValue = "0";
        
        // Verificar si el sensor está disponible
        if (H has :getSolarIntensityHistory) {
            try {
                // Obtener el último valor (últimos 60 segundos)
                var history = H.getSolarIntensityHistory({
                    :period => 1,        // 1 = últimos datos
                    :order => H.ORDER_NEWEST_FIRST
                });
                
                if (history != null) {
                    var sample = history.next();
                    if (sample != null && sample.data != null) {
                        solarValue = sample.data;
                        
                        // El valor está en alguna unidad (¿lux? ¿W/m²?)
                        // Garmin suele devolver valores de 0-100,000+ para luz solar
                    }
                }
            } catch (ex) {
                S.println("Error getting solar: " + ex.toString());
            }
        }
        
        return solarValue;
    }
}

module ActivityData {

    function drawActivityData(dc, width, height, timeData, dca) {
        var cy = height / 2;
        var cx = width / 2;

        var leftX = width * 0.20;
        var rightX = width * 0.80;
        var dataYU = cy - 40;
        var dataYD = cy + 20;
        var separation = 8;

        // 1. Obtener datos de actividad
        var activityInfo = ActivityMonitor.getInfo();
        var heartRate = null;
        
        // Obtener frecuencia cardiaca si está disponible
        if (ActivityMonitor has :getHeartRateHistory) {
            var hrHistory = ActivityMonitor.getHeartRateHistory(1, true);
            var hrSample = hrHistory.next();
            if (hrSample != null && hrSample.heartRate != null) {
                heartRate = hrSample.heartRate;
            }
        }
        
        // 2. Ppasos
        drawStepsData(dc, leftX, dataYU, activityInfo.steps, separation, dca);

        // 3. Frecuencia cardiaca
        drawHeartRateData(dc, rightX, dataYU, heartRate, separation, dca);

        //4. Distancia
        drawDistanceData(dc, cx, dataYU - 70, activityInfo.distance, separation, dca);

        //4. Escaleras
        drawStairsData(dc, leftX, dataYD, activityInfo.floorsClimbed, separation, dca);

        //5. Bateria
        drawBatteryData(dc, rightX, dataYD, S.getSystemStats().battery, separation, dca);

        drawSunTimes(dc, cx, dataYD + 70);
    }

    function drawStepsData(dc, x, y, steps, separation, dca) {
      var stepsStr = steps.format("%d");
      
      dc.setColor(G.COLOR_BLUE, G.COLOR_TRANSPARENT);
      drawStepsIcon(dc, x, y - separation, dca);
      dc.drawText(x, y, G.FONT_XTINY, stepsStr, G.TEXT_JUSTIFY_CENTER);
      
    }

    function drawStepsIcon(dc, x, y, dca) {
       var iconSize = 15;

        var iconSteps = dca.icon(:steps);
        iconSteps.locY = y - iconSize;
        iconSteps.locX = x;
        //iconSteps.setText(" ^ ");
        iconSteps.draw(dc);  // ¡IMPORTANTE!
    }

    function drawHeartRateData(dc, x, y, heartRate, separation, dca) {
       var hrStr = "--";
       if (heartRate != null) {
           hrStr = heartRate.format("%d");
       }
       
       drawHeartIcon(dc, x, y - separation, dca);
       dc.drawText(x, y, G.FONT_XTINY, hrStr, G.TEXT_JUSTIFY_CENTER);
    }

    function drawHeartIcon(dc, x, y, dca) {
       // Dibuja un icono de corazón simple
       var iconSize = 15;
       
       var iconHeart = dca.icon(:heart);
        iconHeart.locY = y - iconSize;
        iconHeart.locX = x;
        iconHeart.draw(dc);  // ¡IMPORTANTE!
    }

    function drawDistanceData(dc, x, y, distance, separation, dca) {
        var units = " m";
        var distanceStr = distance.format("%d");
        var offset = 25 + (distanceStr.length() *3);

      if (distance > 1000) {
          units = " km";
          distance = distance / 1000;
          offset = 25 + (distance.format("%.1f").length() *3);
          distanceStr = "   " + distance.format("%.1f");
      }
      
      drawDistanceIcon(dc, x - offset, y + 5, distanceStr, dca);
      dc.drawText(x, y, G.FONT_XTINY, distanceStr + units, G.TEXT_JUSTIFY_CENTER);
    }

    function drawDistanceIcon(dc, x, y, distanceStr, dca) {
       var iconSize = 3;
       
        var iconDistance = dca.icon(:dist);
        iconDistance.locY = y - iconSize;
        iconDistance.locX = x;
        iconDistance.draw(dc);  // ¡IMPORTANTE!
    }

    function drawStairsData(dc, x, y, stairs, separation, dca) {
      var stairsStr = stairs.format("%d");

      drawStairsIcon(dc, x, y,stairsStr, dca);
      dc.drawText(x, y, G.FONT_XTINY, stairsStr, G.TEXT_JUSTIFY_CENTER);
    }

    function drawStairsIcon(dc, x, y, stairsStr, dca) {
       var iconSize = 22;
       
        var iconStairs = dca.icon(:stair);
        iconStairs.locY = y + iconSize;
        iconStairs.locX = x;
        iconStairs.draw(dc);  // ¡IMPORTANTE!
    }

    function drawBatteryData(dc, x, y, batteryLevel, separation, dca) {
      var batteryStr = batteryLevel.format("%d");
      
      TF.drawBatteryV(dc, x - 3, y + 23, batteryLevel, 2, G.COLOR_WHITE);
      //drawBatteryIcon(dc, x, y, dca);
      dc.drawText(x, y, G.FONT_XTINY, batteryStr, G.TEXT_JUSTIFY_CENTER);
    }

    function drawBatteryIcon(dc, x, y, dca) {
       var iconSize = 22;
       
        var iconBattery = dca.icon(:batte);
        iconBattery.locY = y + iconSize;
        iconBattery.locX = x;
        iconBattery.draw(dc);  // ¡IMPORTANTE!
    }

    function degToRad(d) { return d * Math.PI / 180.0; }
    function radToDeg(r) { return r * 180.0 / Math.PI; }

    function formatSunTime(t) {
        if(t == null) { return "--"; }
        var infoSunR = T.Gregorian.info( t, T.FORMAT_MEDIUM );
        return (infoSunR.hour < 10 ? "0" : "")+infoSunR.hour+":"+ (infoSunR.min < 10 ? "0" : "") + infoSunR.min;
    }

    function drawSunTimes(dc, x, y) {
        //var curpos = W.getCurrentConditions().observationLocationPosition;
        var curpos = P.getInfo().position; 
        if (curpos != null) {
            var sunrise = W.getSunrise(curpos, T.now());
            var sunset  = W.getSunset(curpos, T.now());
            dc.drawText(x, y, G.FONT_XTINY, formatSunTime(sunrise) + " - " + formatSunTime(sunset), G.TEXT_JUSTIFY_CENTER);
        }else{
            dc.drawText(x, y, G.FONT_XTINY, "-- - --", G.TEXT_JUSTIFY_CENTER);
        }
    }
}