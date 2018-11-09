using Toybox.Time;
using Toybox.Time.Gregorian;

class DataFieldDate extends DataFieldBase {

    function initialize(layout_bin, config, justify) {
        DataFieldBase.initialize(layout_bin, config, justify);
    }

    function onUpdate(dc) {
        var date = Time.now();
        var today_short = Gregorian.info(date, Time.FORMAT_SHORT);
        var today = Gregorian.info(date, Time.FORMAT_MEDIUM);

        var date_str = Lang.format("$1$ $2$/$3$", [today.day_of_week, today.day, today_short.month]);

        dc.drawText(self.origin.x, self.origin.y, self.fonts.data, date_str, self.justify);
    }

} // DataFieldDate
