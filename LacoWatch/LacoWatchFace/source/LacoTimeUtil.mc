import Toybox.Lang;
import Toybox.WatchUi;

using Toybox.Math;
using Toybox.System;
using Toybox.Graphics as G;
using Toybox.Time as T;

module TimeUtils {

    var hoursPos=[];
    var minsPos=[];

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
        var now   = T.now();
        var short = T.Gregorian.info(now, T.FORMAT_SHORT);

        return {
            :h    => clock.hour,
            :hour => (clock.hour % 12 + clock.min/60.0) / 12.0,
            :min  => clock.min/60.0,
            :sec  => clock.sec,
            :day  => short.day,
            :date => T.Gregorian.info(now, T.FORMAT_MEDIUM)
        };
    }

    // Draw date with seconds
    function drawDate(dc, x, y, timeData, color) {
       dc.setColor(color, G.COLOR_TRANSPARENT);
   
       var dateStr = Lang.format("$1$ $2$", [
           timeData[:date].day,
           timeData[:date].month
       ]);
   
       dc.drawText(x, y, Fonts.tiny, dateStr, G.TEXT_JUSTIFY_CENTER);
    }

    // Hours
    function initHours(cx, cy) {
        var radius = cx * 0.35;
        for (var i = 1; i <= 12; i++) {
    
            var angle = (i / 12.0) * 360;
            var rad = Math.toRadians(angle - 90);
    
            var x = cx + Math.cos(rad) * radius;
            var y = cy + Math.sin(rad) * radius;
            
            hoursPos.add([x, y]);
        }
    }

    function drawHours(dc, color) {
        for (var i = 0; i < 12; i++) {
            dc.setColor(color, G.COLOR_TRANSPARENT);
            dc.drawText(hoursPos[i][0], hoursPos[i][1], Fonts.small, (i + 1).toString(), G.TEXT_JUSTIFY_CENTER);
        }
    }

    // Minutes
    function initMinutes(cx, cy){
         var radius = cx * 0.65;
        for (var i = 5; i < 60; i += 5) {
            var angle = (i / 60.0) * 360;
            var rad = Math.toRadians(angle - 90);
    
            var x = cx + Math.cos(rad) * radius;
            var y = cy + Math.sin(rad) * radius;
    
            minsPos.add([x, y]);
        }
    }

    function drawMinutes(dc, color) {
        for (var i = 5; i < 60; i += 5) {
            var ind = (i / 5) -1;
            var text = i.format("%d");
    
            dc.setColor(color, G.COLOR_TRANSPARENT);
            dc.drawText(minsPos[ind][0], minsPos[ind][1], Fonts.big, text, G.TEXT_JUSTIFY_CENTER);
        }
    }

    // Arrow 12
    var triangleArrow;
    var lineArrow;

    function initArrow(lay){
        var r = lay.cx * 0.65;
    
        var topX = lay.cx;
        var topY = lay.cy - r;
    
        triangleArrow = ([
            [topX, topY - lay.sy(12)],
            [topX - lay.sx(10), topY + lay.sy(6)],
            [topX + lay.sx(10), topY + lay.sy(6)]
        ]);

        lineArrow = drawThickLine(topX, topY + lay.sy(6), topX, topY + lay.sy(17), lay.sx(4));
    }

    function drawTriangle12(dc, color) {
        dc.setColor(color, G.COLOR_TRANSPARENT);
        dc.fillPolygon(triangleArrow);
        dc.fillPolygon(lineArrow);
    }

    function drawThickLine(x1, y1, x2, y2, width) {
        var dx = y2 - y1;
        var dy = x1 - x2;
        var len = Math.sqrt(dx*dx + dy*dy);
    
        dx = dx / len * width/2;
        dy = dy / len * width/2;
    
        return ([
            [x1 - dx, y1 - dy],
            [x1 + dx, y1 + dy],
            [x2 + dx, y2 + dy],
            [x2 - dx, y2 - dy]
        ]);
    }

    // Minutes Ticks
    var ticksPos = [];

    function initMinuteTicks(lay) {
        var outer;
        var thickness;
        var inner=lay.sx(140);

        for (var i = 0; i < 60; i++) {
    
            var angle = (i / 60.0) * 360;
            var rad = Math.toRadians(angle - 90);
    
            if (i % 15 == 0) {
                outer = lay.sx(105);
                thickness=5;
            }else if(i % 5 == 0) {
                outer = lay.sx(105);
                thickness=2;
            } else {
                outer = lay.sx(120);
                thickness=2;
            }
    
            var x1 = lay.cx + Math.cos(rad) * inner;
            var y1 = lay.cy + Math.sin(rad) * inner;
    
            var x2 = lay.cx + Math.cos(rad) * outer;
            var y2 = lay.cy + Math.sin(rad) * outer;

            ticksPos.add(drawThickLine(x1, y1, x2, y2, thickness));
        }
    }

    function drawMinuteTicks(dc, color) {
        for (var i = 0; i < 60; i++) {
            dc.setColor(color, G.COLOR_TRANSPARENT);
            dc.fillPolygon(ticksPos[i]);
        }
    }
}
