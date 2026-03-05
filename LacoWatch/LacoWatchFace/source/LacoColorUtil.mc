using Toybox.Math;
using Toybox.Graphics as G;

module ColorsUtils {
    function hexToColor(hex) {
        hex = hex.substring(1, hex.length());
        
        var r = hex.substring(0, 2).toNumberWithBase(16);
        var g = hex.substring(2, 4).toNumberWithBase(16);
        var b = hex.substring(4, 6).toNumberWithBase(16);
        
        return G.createColor( 0xFF, r, g, b);
    }
}