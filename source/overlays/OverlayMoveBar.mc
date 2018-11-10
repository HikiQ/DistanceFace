using Toybox.ActivityMonitor;
using Toybox.Graphics;

class OverlayMoveBar extends OverlayBarBase {

    function initialize(config) {
        OverlayBarBase.initialize(config);

        base = 180 + (degrees / 2.0);

        degrees = -degrees;
        bar_direction = Graphics.ARC_CLOCKWISE;

        color_limits = Graphics.COLOR_DK_RED;
    }

    /**
    @param dc [Toybox::Graphics::Dc]: Drawing context
    */
    function onUpdate(dc) {
        var info = ActivityMonitor.getInfo();
        var level = info.moveBarLevel.toFloat();

        level = (level - ActivityMonitor.MOVE_BAR_LEVEL_MIN)
            / (ActivityMonitor.MOVE_BAR_LEVEL_MAX - ActivityMonitor.MOVE_BAR_LEVEL_MIN);

        draw_bar(dc, level);
    }

} // OverlayMoveBar
