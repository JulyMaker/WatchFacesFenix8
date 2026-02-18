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
    
        if (idx >= n) {
            return colors[n];
        }
    
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
}