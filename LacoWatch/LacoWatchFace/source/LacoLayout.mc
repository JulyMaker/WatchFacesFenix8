using Toybox.Graphics as G;

class Layout {

    var w;
    var h;
    var cx;
    var cy;

    var hour;
    var min;

    var centerCircleOut;
    var centerCircleIn;

    var boxWidth ;
    var boxHeight;
    var left;
    var top;

    var scale;

    function initialize(w, h) {
        self.w = w; 
        self.h = h;
        cx = w * 0.5;
        cy = h * 0.5;

        hour = cx*0.42;
        min  = cx*0.9;

        centerCircleIn  = cx*0.435;
        centerCircleOut = cx*0.44;

        // Escala base respecto a un diseño base (ej 260px fenix 8)
        scale = w / 260.0;

        boxWidth  = sy(40);
        boxHeight = sy(15);
        var boxY = cy + cy * 0.05;
        left = cx - boxWidth/2;
        top  = boxY + boxHeight/2;
    }

    function sx(v) { return (v * scale).toNumber(); }
    function sy(v) { return (v * scale).toNumber(); }

    function drawCenterCircle(dc, cx, cy, color) {
       dc.setColor(color, G.COLOR_TRANSPARENT);
       dc.drawCircle(cx, cy, centerCircleIn);
       dc.drawCircle(cx, cy, centerCircleOut);
    }

    function drawCenter(dc, cx, cy,color){
       dc.setColor(color, G.COLOR_TRANSPARENT);
       dc.fillCircle(cx, cy, 4);
    }

    function drawRectDate(dc, color) {
       //dc.setColor(color, G.COLOR_TRANSPARENT);
       //dc.fillRectangle(left, top, boxWidth, boxHeight);

       // fondo ventana
       dc.setColor(color, G.COLOR_WHITE);
       dc.fillRectangle(left, top, boxWidth, boxHeight);
       
       // borde fino
       dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
       dc.drawRectangle(left, top, boxWidth, boxHeight);

       // sombra interior superior
       dc.setColor(G.COLOR_BLACK, G.COLOR_TRANSPARENT);
       dc.drawLine(left+1, top+1, left+boxWidth-1, top+1);
       dc.drawLine(left+1, top+boxHeight-2, left+boxWidth-1, top+boxHeight-2);
    }
}