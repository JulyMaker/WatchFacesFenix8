import Toybox.WatchUi;
import Toybox.Lang;

class DrawableCache{

    private static var _instance as DrawableCache? = null;

    private var _cache as Dictionary<Symbol, Text>;
    private var _groups as Dictionary<Symbol, Array<Symbol>>;

    // Constructor
    function initialize(){
        _cache = {};
        _groups = {};
    }

    static function getInstance() as DrawableCache {
        if (_instance == null) {
            _instance = new DrawableCache();
            _instance.initialize();
        }
        return _instance;
    }

    function register(view as WatchUi.View, id as Symbol, st as String) {
        var d = _cache[id];
        if (d == null) {
            d = view.findDrawableById(st) as Text;
            _cache[id] = d;
        }
        return d;
    }

    function icon(id as Symbol)as Text {
        var d = _cache[id];
        if (d == null) {
            return _cache[:steps];
        }
        return d;
    }

    function registerGroup(group as Symbol, ids as Array<Symbol>) {
        _groups[group] = ids;
    }

    function getGroup(group as Symbol) as Array<Symbol> {
        return _groups[group] != null ? _groups[group] : [] as Array<Symbol>;
    }

    function clearGroup(group as Symbol) {
        var arr = _groups[group];
        if (arr == null) {return;}

        for (var i = 0; i < arr.size(); i++) {
            _cache.remove(arr[i]);
        }
    }

    function clearAll() {
        var keys = _cache.keys();
        for (var i = 0; i < keys.size(); i++) {
            _cache.remove(keys[i]);
        }

        keys = _groups.keys();
        for (var i = 0; i < keys.size(); i++) {
            _groups.remove(keys[i]);
        }
    }
}
