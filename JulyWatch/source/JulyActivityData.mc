using Toybox.ActivityMonitor;
using Toybox.Time;
using Toybox.Graphics as G;

module ActivityData {
    
    function drawActivityData(dc, width, height, timeData) {
        var cy = height / 2;
        
        var leftX = width * 0.20;
        var rightX = width * 0.80;
        var dataY = cy - 40; // Ajusta esta posición según tu diseño
        
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
        
        // 2. Dibujar icono y texto de pasos
        drawStepsData(dc, leftX, dataY, activityInfo.steps);
        
        // 3. Dibujar icono y texto de frecuencia cardiaca
        //drawHeartRateData(dc, rightX, dataY, heartRate);
    }

    function drawStepsData(dc, x, y, steps) {
      var stepsStr = steps.format("%d");
      
      // Dibujar icono de pasos (puedes usar un caracter o dibujar líneas)
      dc.setColor(G.COLOR_BLUE, G.COLOR_TRANSPARENT);
      
      // Icono simple de pasos usando texto o líneas
      // Opción 1: Usar un caracter de fuente si tienes uno
      //dc.drawText(x, y - 15, G.FONT_XTINY, "👣", G.TEXT_JUSTIFY_CENTER);
      
      // Opción 2: Dibujar un icono simple
      drawStepsIcon(dc, x, y - 20);
      
      // Dibujar número de pasos
      dc.drawText(x, y, G.FONT_XTINY, stepsStr, G.TEXT_JUSTIFY_CENTER);
    }

    function drawStepsIcon(dc, x, y) {
       // Dibuja un icono simple de pasos (un pequeño pie/caminante)
       var iconSize = 6;
       
       // Punto superior (rodilla)
       dc.fillCircle(x, y - iconSize, 1);
       
       // Línea de la pierna
       dc.drawLine(x, y - iconSize + 1, x, y);
       
       // Pie (pequeña línea diagonal)
       dc.drawLine(x, y, x + 2, y - 1);
    }
}