class DataFieldConnection extends DataFieldBase {

    protected var points = [];

    function initialize(layout_bin, config, justify) {
        DataFieldBase.initialize(layout_bin, config, justify);

        // generate icon
        var s = Math.round(canvas.getHeight() * 0.2);
        var x = self.origin.x;
        var y = self.origin.y;

        // start from upper left and draw symmetrically

        // cross
        self.points.add([new Point(x-s, y-s), new Point(x+s, y+s)]);
        self.points.add([new Point(x-s, y+s), new Point(x+s, y-s)]);

        // straight down
        self.points.add([new Point(x, y-2*s), new Point(x, y+2*s)]);

        // corners
        self.points.add([new Point(x, y-2*s), new Point(x+s, y-s)]);
        self.points.add([new Point(x, y+2*s), new Point(x+s, y+s)]);
    }


    function onUpdate(dc) {
        var settings = System.getDeviceSettings();
        if (settings.phoneConnected) {
            var p0 = null;
            var p1 = null;

            for (var i = 0; i < points.size(); i ++) {
                p0 = points[i][0];
                p1 = points[i][1];

                dc.drawLine(p0.x, p0.y, p1.x, p1.y);
            }
        }
    }

} // DataFieldConnection
