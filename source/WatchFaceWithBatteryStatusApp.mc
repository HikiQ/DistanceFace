using Toybox.Application as App;

class WatchFaceWithBatteryStatusApp extends App.AppBase {

    // contains the view with time etc
    protected var main_view = null;

    function initialize() {
        AppBase.initialize();
        main_view = new WatchFaceWithBatteryStatusView();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // when settings are changes from connectIQ
    function onSettingsChanged() {
        main_view.onSettingsChanged();
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ main_view ];
    }

}