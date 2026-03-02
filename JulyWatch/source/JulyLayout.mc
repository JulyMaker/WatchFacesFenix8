class Layout {

    var w;
    var h;
    var cx;
    var cy;

    var leftX;
    var rightX;
    var dataYU;
    var dataYD;

    var scale;

    function initialize(w, h) {
        self.w = w; 
        self.h = h;
        cx = w * 0.5;
        cy = h * 0.5;

        leftX  = w * 0.20;
        rightX = w * 0.80;

        // Escala base respecto a un diseño base (ej 260px fenix 8)
        scale = w / 260.0;

        dataYU = cy - sy(40);
        dataYD = cy + sy(20);
    }

    function sx(v) { return (v * scale).toNumber(); }
    function sy(v) { return (v * scale).toNumber(); }
}