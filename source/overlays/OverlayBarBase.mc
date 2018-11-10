using Toybox.ActivityMonitor;
using Toybox.Graphics;
using Toybox.Math;

class OverlayBarBase extends OverlayBase {

    protected var thickness_fg = 2;
    protected var thickness_bg = 3;

    protected var degrees = 45.0;

    protected var base = 0.0;
    protected var bar_direction = Graphics.ARC_COUNTER_CLOCKWISE;
    protected var color_limits = null;
    protected var color_bar = null;

    protected var origin = null;
    protected var radius = null;

    protected var bounds = [];

    function initialize(config) {
        OverlayBase.initialize(config);
        self.color_limits = self.colors.foreground;
        self.color_bar = self.colors.grid;
    }

    /**
    Can be used to set layout with dc
    @param dc [Toybox::Graphics::Dc]: Drawing context
    */
    function onLayout(dc) {
        self.origin = [dc.getWidth()/2.0, dc.getHeight()/2.0];
        self.radius = origin[0] - thickness_fg/2.0;
        self.base = unwrapAngle(base);

        self.bounds.add(polarToCartesian(origin, base, radius));
        self.bounds.add(polarToCartesian(origin, base + degrees, radius));
    }

    /**
    @param dc [Toybox::Graphics::Dc]: Drawing context
    */
    function onUpdate(dc) {
        throw new NotImplementedException();
    }

    /**
    draws the bar
    */
    protected function draw_bar(dc, level) {
        if (level > 1) {
            level = 1.0;
        }

        // foreground
        dc.setPenWidth(thickness_fg);
        dc.setColor(color_bar, Graphics.COLOR_TRANSPARENT);

        var bar = degrees * level;
        if (bar.abs() >= 0.6) {
            // for some reason could not draw arcs smaller than 0.5 degrees
            dc.drawArc(self.origin[0], self.origin[1], self.radius, bar_direction, base, unwrapAngle(base + bar));
        }

        // background
        dc.setPenWidth(1);
        dc.setColor(color_limits, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(bounds[0][0], bounds[0][1], thickness_bg);
        dc.fillCircle(bounds[1][0], bounds[1][1], thickness_bg);

        dc.setColor(self.colors.foreground, Graphics.COLOR_TRANSPARENT);
    }

    /**
    Unwrap angles to 0-360
    Works only within -360 -- 719

    This is to debug arc drawing
    */
    protected function unwrapAngle(degs) {
        if (degs < 0) {
            return 360 + degs;
        }
        else if (degs >= 360) {
            return degs - 360;
        }
        return degs;
    }


} // OverlayBarBase
