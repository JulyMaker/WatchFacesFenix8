using Toybox.Math;
using Toybox.Graphics as G;

module ArcUtils {

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

    function drawArcSegments(dc, col1, col2, percent, quarter, dir) {

        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;
    
        var radius = 135;
        var innerRadius = 125;
    
        var startAngle = quarter[0];
        var endAngle   =  quarter[1];
    
        var segments = 30;
        var filledSegments = (segments * percent).toNumber();
    
        var angleStep = (endAngle - startAngle) / segments;
    
        for (var i = 0; i < segments; i++) {
    
            var angle = startAngle + (i * angleStep);
    
            var x1 = cx + Math.cos(angle) * innerRadius;
            var y1 = cy + Math.sin(angle) * innerRadius;
    
            var x2 = cx + Math.cos(angle) * radius;
            var y2 = cy + Math.sin(angle) * radius;

            if (dir && i < filledSegments) {
                dc.setPenWidth(1);
                dc.setColor(col1, G.COLOR_TRANSPARENT);
            }else if (!dir && i >= segments - filledSegments) {
                dc.setPenWidth(1);
                dc.setColor(col1, G.COLOR_TRANSPARENT);
            } else {
                dc.setPenWidth(1);
                dc.setColor(col2, G.COLOR_TRANSPARENT);
            }
    
            dc.drawLine(x1, y1, x2, y2);
        }
    }

}