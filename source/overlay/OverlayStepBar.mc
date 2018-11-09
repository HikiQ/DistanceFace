using Toybox.ActivityMonitor;
using Toybox.Graphics;

class OverlayStepBar extends OverlayBarBase {

    function initialize(config) {
        OverlayBarBase.initialize(config);

        base = 360 - (degrees / 2.0);
        bar_direction = Graphics.ARC_COUNTER_CLOCKWISE;

        color_limits = Graphics.COLOR_DK_GREEN;
    }

    /**
    @param dc [Toybox::Graphics::Dc]: Drawing context
    */
    function onUpdate(dc) {
        var info = ActivityMonitor.getInfo();
        var level = info.steps;
        var goal = info.stepGoal;

        if (goal > 1) {
            level = level.toFloat() / goal;
        } else {
            level = 0.0;
        }

        draw_bar(dc, level);
    }

} // OverlayStepBar
