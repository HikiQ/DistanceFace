using Toybox.Time;
using Toybox.Lang;
using Toybox.WatchUi;

class DataFieldBattery extends DataFieldBase {

    protected var h = null;
    protected var w = null;
    protected var x = null;
    protected var y = null;
    protected var button_height_half = null;

    protected var battery_color_limit = 25;

    // charging symbol
    protected var lightning_diffs = [[-1, 3], [1.75, -0.5], [-0.75, 3.5], [2, -4.5], [-1.5, 0.5], [1, -2]];
    protected var lightning_polygon = [];
    protected var lightning_scale = 3.0;

    // battery bubble gum -->
    protected var is_charging = null;
    protected var is_charging_comparison_delay = 30;
    protected var previous_battery_check = null;
    protected var previous_battery_value = null;
    protected var delayed_battery_value = null;
    // <--

    function initialize(layout_bin, config, justify) {
        DataFieldBase.initialize(layout_bin, config, justify);

        h = canvas.getHeight();
        w = h * 2;
        button_height_half = Math.round(h / 5);

        x = self.origin.x;
        y = self.origin.y - Math.round(h/2);

        lightning_polygon = generateLightingPolygon();
        initChargingChecks();
    }

    function onUpdate(dc) {
        var stats = System.getSystemStats();
        var battery = stats.battery;

        var battery_str = Lang.format("$1$%", [battery.format("%d")]);

        if (battery > self.battery_color_limit){
            dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        }
        else {
            dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
        }

        var wb = w * (battery / 100);
        dc.fillRectangle(x, y, wb, h);

        dc.setColor(self.colors.foreground, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, w, h);
        dc.fillRectangle(x+w, origin.y-button_height_half, 2, 2*button_height_half+1);

        dc.drawText(x + w/2, origin.y-1, self.fonts.data, battery_str,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // draw charging icon
        checkIsCharging(battery);
        if (is_charging) {
            dc.fillPolygon(self.lightning_polygon);
        }
    }

    /**
    Generates lighting polygon based on lighting differentials
    */
    protected function generateLightingPolygon() {
        var poly = [];

        // calculate lightning polygon coordinates
        poly.add([x+w*1.3, y]);

        var xy = null;
        var diff = null;

        for (var i = 0; i < lightning_diffs.size(); i++) {
            xy = poly[i];
            diff = lightning_diffs[i];

            poly.add([xy[0]+lightning_scale*diff[0], xy[1]+lightning_scale*diff[1]]);
        }

        return poly;
    }

    /**
    Initialize array for charging checks
    */
    protected function initChargingChecks() {
        var stats = System.getSystemStats();

        is_charging = false;
        is_charging_comparison_delay = new Time.Duration(is_charging_comparison_delay);
        previous_battery_check = Time.now();
        previous_battery_value = stats.battery;
        delayed_battery_value = stats.battery;
    }

    /**
    FR235 does not implement stats.charging.
    This function monitors battery charge and if its raising tells that the device is charging.
    This is called every time screen updates but does anything only every N seconds
    */
    protected function checkIsCharging(battery) {
        self.is_charging = battery > (previous_battery_value + 0.1);

        var now = Time.now();
        var elapsed = now.subtract(previous_battery_check);
        if ( elapsed.greaterThan(is_charging_comparison_delay) ) {
            previous_battery_check = now;
            previous_battery_value = delayed_battery_value;
            delayed_battery_value = battery;
        }
    }

} // DataFieldBattery

