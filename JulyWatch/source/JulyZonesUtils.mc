using Toybox.Graphics as G;

class ZonesMap {

    var zones = {
        :hour    => new Zone(82 , 42, 97, 70, -1),
        :hour2   => new Zone(132, 42, 48, 70, -1),
        :min     => new Zone(82 ,150, 96, 70, -1),
        :min2    => new Zone(132,150, 47, 70, -1),
        :weatIco => new Zone(25 ,120, 50, 21, -1),
        :weatTmp => new Zone(25 ,120, 50, 21, -1),
        :moon    => new Zone(188,120, 20, 21, -1),
        :solar   => new Zone(210,120, 30, 21, -1),
        :birthday=> new Zone(48 , 35, 25, 23, -1),
        :sun     => new Zone(82 ,220, 97, 21, -1),
        :battChg => new Zone(213,170,  8, 20, -1), //Battery charging

        :field1 => new Zone(32, 90, 42, 23, -1),
        :field2 => new Zone(80, 20, 92, 20, -1),
        :field3 => new Zone(190,90, 35, 23, -1),
        :field4 => new Zone(194,150,28, 20, -1), //Battery
        :field6 => new Zone(194,170,28, 26, -1), //Icon
        :field5 => new Zone(40, 150,27, 20, -1),
        :dateFi => new Zone(85, 120,88, 21, -1)
    };

    var zones240 = {
        :hour    => new Zone(80 , 40, 84, 61, -1),
        :hour2   => new Zone(117, 40, 48, 61, -1),
        :min     => new Zone(71 ,135, 92, 65, -1),
        :min2    => new Zone(121,135, 43, 65, -1),
        :weatIco => new Zone(21 ,111, 50, 20, -1),
        :weatTmp => new Zone(21 ,111, 50, 20, -1),
        :moon    => new Zone(172,111, 20, 20, -1),
        :solar   => new Zone(194,111, 30, 20, -1),
        :birthday=> new Zone( 44, 35, 25, 20, -1),
        :sun     => new Zone( 73,202, 92, 18, -1),
        :battChg => new Zone(198,157,  8, 20, -1), //Battery charging

        :field1 => new Zone(30, 85, 42, 20, -1),
        :field2 => new Zone(76, 20, 92, 20, -1),
        :field3 => new Zone(175,85, 35, 20, -1),
        :field4 => new Zone(180,135,28, 20, -1), //Battery
        :field6 => new Zone(180,155,28, 26, -1), //Icon
        :field5 => new Zone(35, 137,27, 20, -1),
        :dateFi => new Zone(80, 111,88, 21, -1)
    };
    
    var timers = {
        :activityT => new TimerControl(5),     // 5s
        :frecHRT   => new TimerControl(10),    // 10s
        :solarT    => new TimerControl(30),    // 30s
        :batteryT  => new TimerControl(120),   // 2min
        :bodybatT  => new TimerControl(300),   // 5min
        :weatherT  => new TimerControl(14400)  // 4h
    };

    var showZones;
    
    function initialize(){
        showZones=false;
    }

    function resolution(res){
        if(res == 240){
            zones = zones240;
        }
    }

    function clear(id, dc) {
        zones[id].clear(dc);
    }

    function drawZones(dc) {
        if(showZones){ return; }

        dc.setColor(G.COLOR_DK_GREEN, G.COLOR_TRANSPARENT);
    
        var keys = zones.keys();
        for (var i = 0; i < keys.size(); i++) {
            var z = zones[keys[i]];
            z.drawZone(dc);
        }
        showZones =true;
    }

    function clearZones(dc) {
        if(!showZones){ return; }
        dc.setColor(G.COLOR_BLACK, G.COLOR_TRANSPARENT);
    
        var keys = zones.keys();
        for (var i = 0; i < keys.size(); i++) {
            var z = zones[keys[i]];
            z.drawZone(dc);
        }

        showZones =false;
    }

    public function get(id){
        return zones[id];
    }

    public function getT(id){
        return timers[id];
    }
}

class TimerControl{
    var time;
    var tControl;

    function initialize(time) {
        self.time = time;
        self.tControl = -1;
    }

    function timer(now) {
        if (tControl == null || (now-tControl > time)) {
            tControl = now;
            return true;
        }
        return false;
    }
}

class Zone {

    var x;
    var y;
    var w;
    var h;
    var last;

    function initialize(x, y, w, h, last) {
        self.x = x;
        self.y = y;
        self.w = w;
        self.h = h;
        self.last = last;
    }

    function clear(dc) {
        dc.setColor(G.COLOR_BLACK, G.COLOR_BLACK);
        dc.fillRectangle(x, y, w, h);
    }

    function clearScreen(dc) {
      dc.setColor(G.COLOR_BLACK, G.COLOR_BLACK);
      dc.clear();
    }

    function hasChanged(value) {
        if (last == null || last != value) {
            last = value;
            return true;
        }
        return false;
    }

    function changed(value, control) {
        if (last == null) {
            last = value;
            return true;
        }

        if(last != value){
            var res = value - last;
            if( res > control || res < 0) {
                last = value;
            }

            return true;
        }

        return false;
    }

    function drawZone(dc){
      dc.drawRectangle(x, y, w, h);
    }
    
}
