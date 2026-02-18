import Toybox.Lang;
import Toybox.WatchUi;

using Toybox.Math;
using Toybox.Time;
using Toybox.System;
using Toybox.Graphics as G;
using ColorsUtils as C;

module TimeUtils {

    // Get day of week symbol
    function getDaySymbol(dayOfWeek as Number) as Symbol {
        return {
            1 => :Sunday,
            2 => :Monday,
            3 => :Tuesday,
            4 => :Wednesday,
            5 => :Thursday,
            6 => :Friday,
            7 => :Saturday
        }[dayOfWeek];
    }

    // Get current time data
    function getTimeData() {
        var clock = System.getClockTime();
        var now   = Time.now();

        return {
            :hour => clock.hour,
            :min  => clock.min,
            :sec  => clock.sec,
            :date => Time.Gregorian.info(now, Time.FORMAT_MEDIUM),
            :dateShort => Time.Gregorian.info(now, Time.FORMAT_SHORT)
        };
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

    // Draw Minutes 
    function drawMinutes(dc, x, y, timeData, deg){
        var minStr  = timeData[:min] < 10
            ? "0" + timeData[:min]
            : timeData[:min].toString();

        if(deg){drawMin(dc, x, y, minStr);}
        else{drawMinW(dc, x, y, minStr);}
    }

    function drawMinW(dc, cx, y, minStr) as Void {
        dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
        dc.drawText(cx, y, G.FONT_NUMBER_THAI_HOT, minStr, G.TEXT_JUSTIFY_CENTER);
    }

    function drawMin(dc, x, y, minStr) as Void{

        var font = G.FONT_NUMBER_THAI_HOT;
        var colors = [
            C.hexToColor("#0aafbb"),
            C.hexToColor("#067074"),
            C.hexToColor("#eca725"),
            C.hexToColor("#db1a1a"),
            C.hexToColor("#5f0606")
        ];

        var top = y + 26; // 150
        var bottom = y + 90; //215;
        //dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
        //dc.drawLine(30, top, x * 2 - 30, top);
        //dc.drawLine(30, bottom, x * 2 - 30, bottom);

        var h = bottom - top; //dc.getFontHeight(font) * 1.30;
        var steps = 28.0;   // 🔥 cuanto mayor, más suave
    
        var bandH = (h as Float) / steps; // Math.round(h / steps); // ;

        for (var i = 0; i < steps; i++) {
              var t = i.toFloat() / (steps - 1);
              var col = C.gradientMulti(colors, t);

              var hy = Math.round(top + bandH * i);
              var nextHy = Math.round(top + bandH * (i + 1));
              var bandHeight = nextHy - hy;
      
              dc.setClip(0, hy, dc.getWidth(), bandHeight);
              dc.setColor(col, G.COLOR_TRANSPARENT);
              dc.drawText(x, y, font, minStr, G.TEXT_JUSTIFY_CENTER);
        }

        dc.clearClip();
    }

    // Hours
    function drawHours(dc, x, y, timeData, horiz, deg){
        var hourStr = timeData[:hour] < 10
            ? "0" + timeData[:hour]
            :timeData[:hour].toString();

        if(horiz){drawHoursH(dc, x, y, hourStr, deg);}
        else{drawHoursV(dc, x, y, hourStr, deg);}
    }

    function drawHoursV(dc, x, y, hourStr, deg) {
        var font = G.FONT_NUMBER_THAI_HOT;
    
        var colors = [
            C.hexToColor("#0aafbb"),
            C.hexToColor("#067074"),
            C.hexToColor("#eca725"),
            C.hexToColor("#db1a1a"),
            C.hexToColor("#5f0606")
        ];

        if(!deg){colors = [G.COLOR_WHITE]; }

        var left = x - 45;
        var rigth = x + 47;
        //dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
        //dc.drawLine(left, 30, left, y + 200);
        //dc.drawLine(rigth, 30, rigth, y + 200);

        var w = rigth - left; //dc.getFontHeight(font) * 1.30;
        var steps  = 40.0;     // más = más suave
        var bandW  = (w as Float) / steps;
    
        for (var i = 0; i < steps; i++) {
    
            var t = i.toFloat() / (steps - 1);
            var col = C.gradientMulti(colors, t);
    
            var hx = Math.round(left + bandW * i);
            var nextHx = Math.round(left + bandW * (i + 1));
            var bandWidth = nextHx - hx;
    
            dc.setClip(hx, 0, bandWidth, dc.getHeight());
            dc.setColor(col, G.COLOR_TRANSPARENT);
    
            // OUTLINE = 8 direcciones
            dc.drawText(x - 1, y,     font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x + 1, y,     font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x,     y - 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x,     y + 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
    
            dc.drawText(x - 1, y - 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x + 1, y - 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x - 1, y + 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x + 1, y + 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
        }
    
        dc.clearClip();
    
        // --- VACIADO DEL CENTRO ---
        dc.setColor(G.COLOR_BLACK, G.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, hourStr, G.TEXT_JUSTIFY_CENTER);
    }

    function drawHoursH(dc, x, y, hourStr, deg) {
        var font = G.FONT_NUMBER_THAI_HOT;
    
        var colors = [
            C.hexToColor("#0aafbb"),
            C.hexToColor("#067074"),
            C.hexToColor("#915a08"),
            C.hexToColor("#db1a1a"),
            C.hexToColor("#5f0606")
        ];
    
        if(!deg){colors = [G.COLOR_WHITE]; }

        var top = y + 26;
        var bottom = y + 95;
        //dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
        //dc.drawLine(30, top, x * 2 - 30, top);
        //dc.drawLine(30, bottom, x * 2 - 30, bottom);

        var h = bottom - top; //dc.getFontHeight(font) * 1.30;
        var steps  = 28.0;     // más = más suave
        var bandH  = (h as Float) / steps;
    
        for (var i = 0; i < steps; i++) {
    
            var t = i.toFloat() / (steps - 1);
            var col = C.gradientMulti(colors, t);
    
            var hy = Math.round(top + bandH * i);
            var nextHx = Math.round(top + bandH * (i + 1));
            var bandHeight = nextHx - hy;
    
            dc.setClip(0, hy, dc.getWidth(), bandHeight);
            dc.setColor(col, G.COLOR_TRANSPARENT);
    
            // OUTLINE = 8 direcciones
            dc.drawText(x - 1, y,     font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x + 1, y,     font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x,     y - 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x,     y + 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
    
            dc.drawText(x - 1, y - 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x + 1, y - 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x - 1, y + 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
            dc.drawText(x + 1, y + 1, font, hourStr, G.TEXT_JUSTIFY_CENTER);
        }
    
        dc.clearClip();
    
        // --- VACIADO DEL CENTRO ---
        dc.setColor(G.COLOR_BLACK, G.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, hourStr, G.TEXT_JUSTIFY_CENTER);
    }

}
