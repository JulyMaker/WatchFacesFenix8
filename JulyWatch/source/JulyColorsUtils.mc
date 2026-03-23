using Toybox.Math;
using Toybox.Graphics as G;

module ColorsUtils {
    function lerpColor(c1, c2 , t) {
        var ar = (c1 >> 16) & 0xFF;
        var ag = (c1 >> 8)  & 0xFF;
        var ab = c1 & 0xFF;
    
        var br = (c2 >> 16) & 0xFF;
        var bg = (c2 >> 8)  & 0xFF;
        var bb = c2 & 0xFF;
    
        var r = (ar + (br - ar) * t).toNumber();
        var g = (ag + (bg - ag) * t).toNumber();
        var b = (ab + (bb - ab) * t).toNumber();
    
        return (r << 16) | (g << 8) | b;
    }

    function gradientMulti(colors, t) {
        var n = colors.size() - 1;   // 4 tramos para 5 colores
        var scaled = t * n;
        var idx = Math.floor(scaled).toNumber();
    
        if (idx >= n) { return colors[n]; }
    
        var localT = scaled - idx;
        return lerpColor(colors[idx], colors[idx + 1], localT);
    }

    function hexToColor(hex) {
        hex = hex.substring(1, hex.length());
        
        var r = hex.substring(0, 2).toNumberWithBase(16);
        var g = hex.substring(2, 4).toNumberWithBase(16);
        var b = hex.substring(4, 6).toNumberWithBase(16);
        
        return G.createColor( 0xFF, r, g, b);
    }

    function drawGradient(dc, startColor, midColor, endColor, startX, startY, endX, endY) {
		if (midColor < 0) {
			var height = (endY - startY).toFloat();
			for (var i=0; i<=height; i++) {
				var color = lerpColorsCompact(startColor, endColor, i / height);
				dc.setColor(color, 0);
                dc.drawLine(startX, startY + i, endX, startY + i);
			}
			return;
		}

		var midY = (startY + endY) / 2;
		drawGradient(dc, startColor, -1, midColor, startX, startY, endX, midY);
		drawGradient(dc, midColor, -1, endColor, startX, midY, endX, endY);
	}

	// Draw the color gradient from left to right. Behaves like dc.DrawLine.
	function drawGradientLR(dc, startColor, midColor, endColor, startX, startY, endX, endY) {
		if (midColor < 0) {
			var width = (endX - startX).toFloat();
			for (var i=0; i<=width; i++) {
                var color = lerpColorsCompact(startColor, endColor, i / width);
				dc.setColor(color, 0);
                dc.drawLine(startX + i, startY, startX + i, endY);
			}
			return;
		}

		var midX = (startX + endX) / 2;
		drawGradientLR(dc, startColor, -1, midColor, startX, startY, midX, endY);
		drawGradientLR(dc, midColor, -1, endColor, midX, startY, endX, endY);
	}

    function lerpColorsCompact(startColor, endColor, ratio){		
		var mask1 = 0xff00ff;
		var mask2 = 0x00ff00; // 0xff00ff00 if alpha is required
		var f2 = (256 * ratio).toNumber();
		var f1 = 256 - f2;
		return (((((startColor & mask1) * f1) + ((endColor & mask1) * f2)) >> 8) & mask1) | (((((startColor & mask2) * f1) + ((endColor & mask2) * f2)) >> 8) & mask2);
	}  
}