using Toybox.System as S;
using Toybox.WatchUi;
using Toybox.Graphics as G;

class WFDelegate extends WatchUi.WatchFaceDelegate  {

    private var _parentView as JulyWatchView;
    var showZones;

    function initialize( view as JulyWatchView) {
        WatchFaceDelegate .initialize();
        _parentView = view;

        showZones =false;
    }

    var zones = {
        :field1 => { :x=>38,  :y=>60, :width=>32, :height=>52 },
        :field2 => { :x=>83,  :y=>20, :width=>75, :height=>20 },
        :field3 => { :x=>192, :y=>60, :width=>32, :height=>52 },
        :field4 => { :x=>192, :y=>150,:width=>32, :height=>52 },
        :field5 => { :x=>38,  :y=>150,:width=>32, :height=>52 },
        :dateFi => { :x=>83,  :y=>120,:width=>95, :height=>21 },
        :birthday=>{ :x=>48,  :y=>35 ,:width=>25, :height=>21 }
    };

    var zoneActions = {
        :field1 => Complications.COMPLICATION_TYPE_STEPS,
        :field2 => Complications.COMPLICATION_TYPE_TRAINING_STATUS,
        :field3 => Complications.COMPLICATION_TYPE_HEART_RATE,
        :field4 => Complications.COMPLICATION_TYPE_BATTERY,
        :field5 => Complications.COMPLICATION_TYPE_FLOORS_CLIMBED,
        :dateFi => Complications.COMPLICATION_TYPE_CALENDAR_EVENTS
    };
    
    function pointInRect(x, y, r){
        return  x >= r[:x] &&
                x <= r[:x] + r[:width] &&
                y >= r[:y] &&
                y <= r[:y] + r[:height];
    }

    function onPress(evt as WatchUi.ClickEvent){
        var p = evt.getCoordinates();
        var zone = getZoneAt(p[0], p[1]);
    
        if(zone == :birthday){ 
            _parentView.settings.clearBirth =true;
            return true;
        }

        if (zone != null && zoneActions.hasKey(zone)) {
            try {
                Complications.exitTo(
                    new Complications.Id(zoneActions[zone])
                );
                return true;
            } catch (e) {
                System.println(e);
            }
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
        if(showZones){ return; }

        dc.setColor(color, G.COLOR_TRANSPARENT);
    
        var keys = zones.keys();
        for (var i = 0; i < keys.size(); i++) {
            var z = zones[keys[i]];
            dc.drawRectangle(z[:x], z[:y],
                z[:width], z[:height]);
        }

        showZones = true;
    }

    public function clearZones(dc) as Void {
        if(!showZones){ return; }

        dc.setColor(G.COLOR_BLACK, G.COLOR_TRANSPARENT);
    
        var keys = zones.keys();
        for (var i = 0; i < keys.size(); i++) {
            var z = zones[keys[i]];
            dc.drawRectangle(z[:x], z[:y],
                z[:width], z[:height]);
        }

        showZones = false;
    }

}