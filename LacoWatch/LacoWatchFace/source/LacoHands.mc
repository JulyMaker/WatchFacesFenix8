
using Toybox.Math;
using Toybox.System;
using Toybox.Graphics as G;
using ColorsUtils as C;

module Hands{
    var borderColor = C.hexToColor("#000000" );
    const BASE_WIDTH  = 1;
    const BODY_WIDTH  = 7;
    const BORDER_SIZE = 2;

    var hourHand = {
      :lastValue => -1,
      :points => null
    };

    var minuteHand = {
        :lastValue => -1,
        :points => null
    };

    function recalcHands(cx, cy, value, length, med){
        var angle = value * 2 * Math.PI;
    
        var dx = Math.sin(angle);
        var dy = -Math.cos(angle);
    
        var px = -dy;
        var py = dx;
    
        var tipX = cx + dx * length;
        var tipY = cy + dy * length;
    
        var bodyLength = length * med;
    
        var bodyX = cx + dx * bodyLength;
        var bodyY = cy + dy * bodyLength;
    
        // ========= MAIN POLYGON =========
        var points = [
            [cx - px * BASE_WIDTH, cy - py * BASE_WIDTH],
            [bodyX - px * BODY_WIDTH, bodyY - py * BODY_WIDTH],
            [tipX, tipY],
            [bodyX + px * BODY_WIDTH, bodyY + py * BODY_WIDTH],
            [cx + px * BASE_WIDTH, cy + py * BASE_WIDTH]
        ];
    
        // ========= BORDER =========
        var borderPoints = [
            [cx - px * (BASE_WIDTH + BORDER_SIZE), cy - py * (BASE_WIDTH + BORDER_SIZE)],
            [bodyX - px * (BODY_WIDTH + BORDER_SIZE), bodyY - py * (BODY_WIDTH + BORDER_SIZE)],
            [cx + dx * (length + BORDER_SIZE), cy + dy * (length + BORDER_SIZE)],
            [bodyX + px * (BODY_WIDTH + BORDER_SIZE), bodyY + py * (BODY_WIDTH + BORDER_SIZE)],
            [cx + px * (BASE_WIDTH + BORDER_SIZE), cy + py * (BASE_WIDTH + BORDER_SIZE)]
        ];

        return [points, borderPoints];
    }

    function drawHand(dc, handState, cx, cy, value, length, med, color) {

        if (value != handState[:lastValue]) {
            handState[:points] = recalcHands(cx, cy, value, length, med);
            handState[:lastValue] = value;
        }

        dc.setColor(borderColor, G.COLOR_TRANSPARENT);
        dc.fillPolygon(handState[:points][1]);
    
        dc.setColor(color, G.COLOR_TRANSPARENT);
        dc.fillPolygon(handState[:points][0]);
    }
}