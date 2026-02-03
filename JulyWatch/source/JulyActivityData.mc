using Toybox.ActivityMonitor;
using Toybox.Time;
using Toybox.Graphics as G;
using Toybox.WatchUi;

module ActivityData {

    function drawActivityData(dc, width, height, timeData, icons) {
        var cy = height / 2;
        var cx = width / 2;

        var leftX = width * 0.20;
        var rightX = width * 0.80;
        var dataY = cy - 40; // Ajusta esta posición según tu diseño
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
        drawStepsData(dc, leftX, dataY, activityInfo.steps, separation, icons);

        // 3. Frecuencia cardiaca
        drawHeartRateData(dc, rightX, dataY, heartRate, separation, icons);

        //4. Distancia
        drawDistanceData(dc, cx, dataY - 75, activityInfo.distance, separation, icons);
    }

    function drawStepsData(dc, x, y, steps, separation, icons) {
      var stepsStr = steps.format("%d");
      
      // Dibujar icono de pasos (puedes usar un caracter o dibujar líneas)
      dc.setColor(G.COLOR_BLUE, G.COLOR_TRANSPARENT);
      drawStepsIcon(dc, x, y - separation, icons);

      // Dibujar número de pasos
      dc.drawText(x, y, G.FONT_XTINY, stepsStr, G.TEXT_JUSTIFY_CENTER);
      
    }

    function drawStepsIcon(dc, x, y, icons) {
       // Dibuja un icono simple de pasos (un pequeño pie/caminante)
       var iconSize = 15;

        var iconSteps = icons[:steps];
        iconSteps.locY = y - iconSize;
        iconSteps.locX = x;
        //iconSteps.setText(" ^ ");
        iconSteps.draw(dc);  // ¡IMPORTANTE!
    }

    function drawHeartRateData(dc, x, y, heartRate, separation, icons) {
       var hrStr = "--";
       if (heartRate != null) {
           hrStr = heartRate.format("%d");
       }
       
       // Dibujar icono de corazón
       dc.setColor(G.COLOR_RED, G.COLOR_TRANSPARENT);
       drawHeartIcon(dc, x, y - separation, icons);
       
       // Dibujar frecuencia cardiaca
       dc.setColor(G.COLOR_RED, G.COLOR_TRANSPARENT);
       dc.drawText(x, y, G.FONT_XTINY, hrStr, G.TEXT_JUSTIFY_CENTER);
    }

    function drawHeartIcon(dc, x, y, icons) {
       // Dibuja un icono de corazón simple
       var iconSize = 15;
       
       var iconHeart = icons[:heart];
        iconHeart.locY = y - iconSize;
        iconHeart.locX = x;
        iconHeart.draw(dc);  // ¡IMPORTANTE!
    }

    function drawDistanceData(dc, x, y, distance, separation, icons) {
      var distanceStr = distance.format("%d");
      
      // Dibujar icono de distancia (puedes usar un caracter o dibujar líneas)
      dc.setColor(G.COLOR_YELLOW, G.COLOR_TRANSPARENT);
      drawDistanceIcon(dc, x - 25, y +5,distanceStr, icons);

      // Dibujar número de distancia
      dc.drawText(x, y, G.FONT_XTINY, distanceStr + " m", G.TEXT_JUSTIFY_CENTER);
    }

    function drawDistanceIcon(dc, x, y, distanceStr,icons) {
       // Dibuja un icono simple de distancia (una línea con una marca en el centro)
       var iconSize = 6;
       
        var iconDistance = icons[:dist];
        iconDistance.locY = y - iconSize;
        iconDistance.locX = x;
        iconDistance.draw(dc);  // ¡IMPORTANTE!
    }
}