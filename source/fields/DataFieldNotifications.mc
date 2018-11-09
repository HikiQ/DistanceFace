class DataFieldNotifications extends DataFieldBase {

    protected var x = null;
    protected var y = null;
    protected var w = null;
    protected var h = null;

    protected var points = null;

    function initialize(layout_bin, config, justify) {
        DataFieldBase.initialize(layout_bin, config, justify);

        // icon
        self.w = layout_bin.canvas.getHeight() * 0.3;
        self.h = w * 0.7;

        self.x = origin.x - w;
        self.y = origin.y - h;

        self.points =[[x-0.5*w, y], [x-0.9*w, y + 1.5*h], [x+w, y]];
    }


    function onUpdate(dc) {
        var settings = System.getDeviceSettings();
        var count = settings.notificationCount;

        if (count > 0) {

            var notifications_str = Lang.format("$1$", [count.format("%d")]);
            dc.drawText(self.origin.x - 2*w, self.origin.y, self.fonts.data, notifications_str, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);

            dc.fillEllipse(self.x, self.y, self.w, self.h);
            dc.fillPolygon(self.points);
        }
    }

} // DataFieldNotifications
