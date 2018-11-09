using Toybox.ActivityMonitor;

class DataFieldDistance extends DataFieldBase {

    protected var base_str = "$1$/$2$ km";
    protected var scaler = 100000.0; // convert from cm to km

    function initialize(layout_bin, config, justify, is_metric) {
        DataFieldBase.initialize(layout_bin, config, justify);

        if ( !is_metric ) {
            base_str = "$1$/$2$ mi";
            scaler = 160934.4;
        }
    }

    function onUpdate(dc) {
        var activity_history = ActivityMonitor.getHistory();
        var activity_info = ActivityMonitor.getInfo();

        // current distance
        var distance = 0.0;
        if (activity_info.distance != null) {
            distance = activity_info.distance / self.scaler; // convert from cm to selected unit
        }

        // max history
        var max_distance = 0.0;
        var total_distance = 0.0;
        for (var i = 0; i < activity_history.size(); i++) {
            if (activity_history[i].distance != null) {
                total_distance += activity_history[i].distance;

                if (activity_history[i].distance > max_distance) {
                    max_distance = activity_history[i].distance;
                }
            }
        }

        max_distance /= self.scaler;
        total_distance /= self.scaler;
        total_distance += distance;

        var str = Lang.format(base_str, [distance.format("%.0f"), total_distance.format("%.0f")]);
        dc.drawText(self.origin.x, self.origin.y, self.fonts.data, str, self.justify );
    }

} // DataFieldDistance
