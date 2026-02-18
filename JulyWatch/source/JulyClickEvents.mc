using Toybox.System;
using Toybox.WatchUi;
using Toybox.Graphics as G;

class WFDelegate extends WatchUi.WatchFaceDelegate  {

    function initialize() {
        WatchFaceDelegate .initialize();
    }

    var zones = {
        :field1 => { :x=>38,  :y=>60, :width=>32, :height=>52 },
        :field2 => { :x=>83,  :y=>20, :width=>75, :height=>20 },
        :field3 => { :x=>192, :y=>60, :width=>32, :height=>52 },
        :field4 => { :x=>192, :y=>150,:width=>32, :height=>52 },
        :field5 => { :x=>38,  :y=>150,:width=>32, :height=>52 },
        :dateFi => { :x=>83,  :y=>120,:width=>95, :height=>21 }
    };

    function pointInRect(x, y, r){
        return  x >= r[:x] &&
                x <= r[:x] + r[:width] &&
                y >= r[:y] &&
                y <= r[:y] + r[:height];
    }

    function onPress(evt as WatchUi.ClickEvent){
        var p = evt.getCoordinates();
        var x = p[0];
        var y = p[1];
        System.println(evt.getCoordinates());

        if (pointInRect(x, y, zones[:steps])) {
            //System.launchApplication("com.garmin.activitytracker");
            //System.openApp(System.APP_STEPS);
            return true;
        }

        return false;
    }

    function getZoneAt(x, y){

        var keys = zones.keys();
    
        for (var i = 0; i < keys.size(); i++) {
            var k = keys[i];
            var z = zones[k];
    
            if (x >= z[:x] &&
                x <= z[:x] + z[:width] &&
                y >= z[:y] &&
                y <= z[:y] + z[:height]) 
            {return k;}
        }
    
        return null;
    }

    public function drawZones(dc, color) as Void {
        dc.setColor(color, G.COLOR_TRANSPARENT);
    
        var keys = zones.keys();
        for (var i = 0; i < keys.size(); i++) {
            var z = zones[keys[i]];
            dc.drawRectangle(z[:x], z[:y],
                z[:width], z[:height]);
        }
    }

}