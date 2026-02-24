import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class JulyWatchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new JulyWatchView();
        var delegate = new WFDelegate(view);
        return [view, delegate];
        //return [ new JulyWatchView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        var view = WatchUi.getCurrentView() as JulyWatchView;
        if (view != null) {
            view[0].reloadSettings();
        }
        WatchUi.requestUpdate();
    }

}

function getApp() as JulyWatchApp {
    return Application.getApp() as JulyWatchApp;
}