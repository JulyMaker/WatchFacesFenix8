using Toybox.Math;
using Toybox.Graphics as G;

class ArcState {
    var lastV;
    var pos;

    function initialize() {
        lastV = 0.0;
        pos=[];
    }

    function buildGeometry(cx, cy, quarter, segments) {
        if (pos.size() > 0) { return; }  // ya calculado

        var innerRadius = 125;
        var radius = 135;
        
        var startAngle = quarter[0];
        var endAngle   = quarter[1];

        var angleStep = (endAngle - startAngle) / segments;

        for (var i = 0; i < segments; i++) {
            var angle = startAngle + (i * angleStep);
            var x1 = cx + Math.cos(angle) * innerRadius;
            var y1 = cy + Math.sin(angle) * innerRadius;
            var x2 = cx + Math.cos(angle) * radius;
            var y2 = cy + Math.sin(angle) * radius;

            pos.add([x1, y1, x2, y2]);
        }
    }
}

module ArcUtils {

    const SEGMENT= 30;

    function quarter1()
    {
        var startAngle = -165 * Math.PI / 180;
        var endAngle   =  -105 * Math.PI / 180;

        return [startAngle, endAngle];
    }

    function quarter2()
    {
        var startAngle = -75 * Math.PI / 180;
        var endAngle   =  -15 * Math.PI / 180;

        return [startAngle, endAngle];
    }

    function quarter3()
    {
        var startAngle = 15 * Math.PI / 180;
        var endAngle   =  75 * Math.PI / 180;

        return [startAngle, endAngle];
    }

    function quarter4()
    {
        var startAngle = 107 * Math.PI / 180;
        var endAngle   =  167 * Math.PI / 180;

        return [startAngle, endAngle];
    }

    function drawIconQ1(dc, x, y, icon, color) {
        icon.locX = x - 25;
        icon.locY = y - 128;
        icon.setColor(color);
        icon.draw(dc);  // ¡IMPORTANTE!
    }

     function drawIconQ2(dc, x, y, icon, color) {
        icon.locX = x + 20;
        icon.locY = y - 129;
        icon.setColor(color);
        icon.draw(dc);  // ¡IMPORTANTE!
    }

    function drawIconQ3(dc, x, y, icon, color) {
        icon.locX = x + 25;
        icon.locY = y + 110;
        icon.setColor(color);
        icon.draw(dc);  // ¡IMPORTANTE!
    }

    function drawIconQ4(dc, x, y, icon, color) {
        icon.locX = x - 25;
        icon.locY = y + 110;
        icon.setColor(color);
        icon.draw(dc);  // ¡IMPORTANTE!
    }

    function drawArcSegments(dc, col1, col2, percent, quarter, dir, state) {
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;
    
        
        state.buildGeometry(cx, cy, quarter, SEGMENT);
        var filledSegments = (SEGMENT * percent).toNumber();

        for (var i = 0; i < SEGMENT; i++) {
            dc.setPenWidth(1);
            if (dir && i < filledSegments) {
                //dc.setPenWidth(1);
                dc.setColor(col1, G.COLOR_TRANSPARENT);
            }else if (!dir && i >= SEGMENT - filledSegments) {
                //dc.setPenWidth(1);
                dc.setColor(col1, G.COLOR_TRANSPARENT);
            } else {
                //dc.setPenWidth(1);
                dc.setColor(col2, G.COLOR_TRANSPARENT);
            }

            var p= state.pos[i];
            dc.drawLine(p[0], p[1], p[2], p[3]);
            //dc.drawLine(x1, y1, x2, y2);
        }

        state.lastV = percent;
    }

    function updateArcSegments(dc, col1, col2, percent, quarter, dir, state) {

        if (percent == state.lastV){ return;} // no change

        var prevSeg = (SEGMENT * state.lastV).toNumber();
        var newSeg  = (SEGMENT * percent).toNumber();
        var init = (prevSeg < newSeg)? prevSeg : newSeg;
        var fin  = (prevSeg > newSeg)? prevSeg : newSeg;
        var pos =0;

        if (newSeg > prevSeg) { dc.setColor(col1, G.COLOR_TRANSPARENT); }
        else{ dc.setColor(col2, G.COLOR_TRANSPARENT);}
        
        for (var i = init; i < fin; i++) {
            dc.setPenWidth(1);
            if (dir) {
                pos = i;
            }else if (!dir) {
                pos = SEGMENT - 1 - i;   
            }
        
            //dc.drawLine(x1, y1, x2, y2);
            var p= state.pos[pos];
            dc.drawLine(p[0], p[1], p[2], p[3]);
        }

        state.lastV = percent;
    }

}