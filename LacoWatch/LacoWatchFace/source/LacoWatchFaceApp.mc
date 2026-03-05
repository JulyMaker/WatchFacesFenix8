import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class LacoWatchFaceApp extends Application.AppBase {

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
        var view = new LacoWatchFaceView();
        var delegate = new LacoDelegate(view);
        return [view, delegate];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

}

function getApp() as LacoWatchFaceApp {
    return Application.getApp() as LacoWatchFaceApp;
}