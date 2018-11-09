using Toybox.System;
using Toybox.Graphics;

class DataFieldAlarm extends DataFieldBase {

    var x = null;
    function initialize(layout_bin, config, justify) {
        DataFieldBase.initialize(layout_bin, config, justify);
        self.x = origin.x - 5;
    }

    function onUpdate(dc) {
        var settings = System.getDeviceSettings();
        var count = settings.alarmCount;
        if (count > 0) {
            dc.fillCircle(x, origin.y, 2);
            dc.drawArc(x, origin.y, 6, Graphics.ARC_CLOCKWISE, 45, 315);
            dc.drawArc(x, origin.y, 10, Graphics.ARC_CLOCKWISE, 45, 315);
        }
    }

} // DataFieldAlarm
