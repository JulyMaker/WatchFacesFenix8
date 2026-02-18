using Toybox.Graphics;

module TinyFont {

    // Matrix 3x5 = 15 bits
    const FONT = {
        "0" => [1,1,1, 1,0,1, 1,0,1, 1,0,1, 1,1,1],
        "1" => [0,1,0, 1,1,0, 0,1,0, 0,1,0, 1,1,1],
        "2" => [1,1,1, 0,0,1, 1,1,1, 1,0,0, 1,1,1],
        "3" => [1,1,1, 0,0,1, 0,1,1, 0,0,1, 1,1,1],
        "4" => [1,0,1, 1,0,1, 1,1,1, 0,0,1, 0,0,1],
        "5" => [1,1,1, 1,0,0, 1,1,1, 0,0,1, 1,1,1],
        "6" => [1,1,1, 1,0,0, 1,1,1, 1,0,1, 1,1,1],
        "7" => [1,1,1, 0,0,1, 0,1,0, 1,0,0, 1,0,0],
        "8" => [1,1,1, 1,0,1, 1,1,1, 1,0,1, 1,1,1],
        "9" => [1,1,1, 1,0,1, 1,1,1, 0,0,1, 1,1,1],
        "." => [0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,1,0],

        "-" => [0,0,0, 0,0,0, 1,1,1, 0,0,0, 0,0,0],

        "°" => [1,1,0, 1,1,0, 0,0,0, 0,0,0, 0,0,0],

        "C" => [1,1,1, 1,0,0, 1,0,0, 1,0,0, 1,1,1],

        "F" => [1,1,1, 1,0,0, 1,1,1, 1,0,0, 1,0,0],

        "a" => [0,0,0, 1,1,0, 0,0,1, 1,1,1, 1,0,1],
        "b" => [1,0,0, 1,0,0, 1,1,0, 1,0,1, 1,1,0],
        "c" => [0,0,0, 0,1,1, 1,0,0, 1,0,0, 0,1,1],
        "d" => [0,0,1, 0,0,1, 0,1,1, 1,0,1, 0,1,1],
        "e" => [0,0,0, 0,1,0, 1,1,1, 1,0,0, 0,1,1],
        "f" => [0,1,1, 0,1,0, 1,1,1, 0,1,0, 0,1,0],
        "g" => [0,0,0, 0,1,1, 1,0,1, 0,1,1, 0,0,1],
        "h" => [1,0,0, 1,0,0, 1,1,0, 1,0,1, 1,0,1],
        "i" => [0,1,0, 0,0,0, 0,1,0, 0,1,0, 0,1,0],
        "j" => [0,0,1, 0,0,0, 0,0,1, 1,0,1, 0,1,0],
        "k" => [1,0,0, 1,0,1, 1,1,0, 1,0,1, 1,0,1],
        "l" => [1,0,0, 1,0,0, 1,0,0, 1,0,0, 0,1,1],
        "m" => [0,0,0, 1,1,0, 1,0,1, 1,0,1, 1,0,1],
        "n" => [0,0,0, 1,1,0, 1,0,1, 1,0,1, 1,0,1],
        "o" => [0,0,0, 0,1,0, 1,0,1, 1,0,1, 0,1,0],
        "p" => [0,0,0, 1,1,0, 1,0,1, 1,1,0, 1,0,0],
        "q" => [0,0,0, 0,1,1, 1,0,1, 0,1,1, 0,0,1],
        "r" => [0,0,0, 1,1,0, 1,0,0, 1,0,0, 1,0,0],
        "s" => [0,0,0, 0,1,1, 1,1,0, 0,0,1, 1,1,0],
        "t" => [0,1,0, 1,1,1, 0,1,0, 0,1,0, 0,0,1],
        "u" => [0,0,0, 1,0,1, 1,0,1, 1,0,1, 0,1,1],
        "v" => [0,0,0, 1,0,1, 1,0,1, 0,1,0, 0,1,0],
        "w" => [0,0,0, 1,0,1, 1,0,1, 1,1,1, 0,1,0],
        "x" => [0,0,0, 1,0,1, 0,1,0, 0,1,0, 1,0,1],
        "y" => [0,0,0, 1,0,1, 0,1,1, 0,0,1, 1,1,0],
        "z" => [0,0,0, 1,1,1, 0,0,1, 0,1,0, 1,1,1]
    };

    function drawChar(dc, x, y, ch, scale, color) {
        var glyph = FONT[ch];

        if (glyph == null) {return;}

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        for (var i = 0; i < 15; i++) {
            if (glyph[i] == 1) {
                var dx = i % 3;
                var dy = i / 3;
                dc.fillRectangle(
                    x + dx * scale,
                    y + dy * scale,
                    scale,
                    scale
                );
            }
        }
    }

    function drawText(dc, x, y, text, scale, color, separ) {
        var cx = x;

        for (var i = 0; i < text.length(); i++) {
            var ch = text.substring(i, i+1);
            drawChar(dc, cx, y, ch, scale, color);
            cx += (separ * scale); // ancho + espacio
        }
    }

     // 🔋 BATERIA MINI (5x10 px aprox)

    function drawBattery(dc, x, y, percent, scale, color) {
        var w = 8 * scale;
        var h = 5 * scale;

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        // marco
        dc.drawRectangle(x, y, w, h);
        dc.fillRectangle(x + w, y + scale, scale, h - 2 * scale);

        var fill = ((w - 2 * scale) * percent / 100).toNumber();
        dc.fillRectangle(x + scale, y + scale, fill, h - 2 * scale);
    }

    function drawBatteryV(dc, x, y, percent, scale, color) {
        var w = 4 * scale;
        var h = 10 * scale;
    
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, w, h);
    
        dc.fillRectangle(
            x + scale,
            y - scale,
            w - 2 * scale,
            scale
        );
    
        var innerH = h - 2 * scale;
        var fill = ((innerH * percent) / 100).toNumber();
    
        dc.fillRectangle(
            x + scale,
            y + h - scale - fill,
            w - 2 * scale,
            fill
        );
    }

}
