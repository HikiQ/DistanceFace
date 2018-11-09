using Toybox.System;

class DataFieldTimeGenerator {
    static function generate(layout_bin, config, justify, is_24_hour) {
        if (is_24_hour) {
            return new DataFieldTime24h(layout_bin, config, justify);
        } else {
            return new DataFieldTime12h(layout_bin, config, justify);
        }
    }
} // DataFieldTimeGenerator

class DataFieldTime24h extends DataFieldBase {
    var offset = 0;

    function initialize(layout_bin, config, justify) {
        DataFieldBase.initialize(layout_bin, config, justify);
    }

    function onLayout(dc) {
        offset = dc.getFontHeight(fonts.data) / 2 -1;
    }

    /**
    Draws time in 24h format
    */
    function onUpdate(dc) {
        var clock_time = System.getClockTime();
        var time_str = Lang.format("$1$:$2$", [clock_time.hour, clock_time.min.format("%02d")]);
        dc.drawText(origin.x, origin.y, self.fonts.time, time_str, self.justify );
    }

} // DataFieldTime24h


class DataFieldTime12h extends DataFieldBase {
    var offset = 0;

    function initialize(layout_bin, config, justify) {
        DataFieldBase.initialize(layout_bin, config, justify);
    }

    function onLayout(dc) {
        offset = dc.getFontHeight(fonts.data) / 2 -1;
    }

    /**
    Draws time in 12h format
    */
    function onUpdate(dc) {
        var time_in_24 = System.getClockTime();

        var hour = time_in_24.hour;
        var am_pm = "";

        if ( hour < 1 ) {
            hour += 12;
            am_pm = "A";
        }
        else if ( hour < 12 ) {
            am_pm = "A";
        }
        else if ( hour < 13 ) {
            am_pm = "P";
        }
        else {
            hour -= 12;
            am_pm = "P";
        }

        var time_str = Lang.format("$1$:$2$", [hour.format("%d"),  time_in_24.min.format("%02d")]);
        dc.drawText(origin.x, origin.y, self.fonts.time, time_str, self.justify );
        dc.drawText(canvas.x2 - offset - 2, origin.y - offset, self.fonts.data, am_pm, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
        dc.drawText(canvas.x2 - offset - 2, origin.y + offset, self.fonts.data, "M", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
    }
} // DataFieldTime
