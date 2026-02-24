using Toybox.Application.Properties as PR;

class Settings{

    private static var _instance;

    static function get() {
        if (_instance == null) {
            _instance = new Settings();
        }
        return _instance;
    }

    var clickDeb;
    var clearBirth;
    var zonesDebug;

    function initialize(){
        readSettings();
    }

    function readSettings() {
        clickDeb   = PR.getValue("TouchZones");
        clearBirth = PR.getValue("ClearBirth");
        zonesDebug = PR.getValue("ZonesDebug");
    }
}