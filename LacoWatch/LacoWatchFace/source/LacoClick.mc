using Toybox.System as S;
using Toybox.WatchUi;
using Toybox.Graphics as G;

class LacoDelegate extends WatchUi.WatchFaceDelegate  {

    private var _parentView as LacoWatchFaceView;

    function initialize( view as LacoWatchFaceView) {
        WatchFaceDelegate .initialize();
        _parentView = view;
    }

    var zoneActions = {
        :calendar => Complications.COMPLICATION_TYPE_CALENDAR_EVENTS
    };

    function pointInRect(p){
        var lay = _parentView.lay;

        return  lay.left <= p[0] &&
                lay.left + lay.boxWidth >= p[0] &&
                lay.top <= p[1] &&
                lay.top + lay.boxHeight >= p[1];
    }

    function onPress(evt as WatchUi.ClickEvent){
        var p = evt.getCoordinates();
        
        if (pointInRect(p)) {
            try {
                Complications.exitTo(
                    new Complications.Id(zoneActions[:calendar])
                );
                return true;
            } catch (e) {
                System.println(e);
            }
        }
    
        return false;
    }

    public function drawZones(dc) as Void {

        dc.setColor(G.COLOR_DK_RED, G.COLOR_TRANSPARENT);
        var lay = _parentView.lay;

        dc.drawRectangle(lay.left, lay.top, lay.boxWidth, lay.boxHeight);

    }
}