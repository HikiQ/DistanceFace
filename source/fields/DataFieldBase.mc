using Toybox.Graphics;
using Toybox.Lang;

class DataFieldBase {

    protected var canvas = null;
    protected var config = null;
    protected var fonts = null;
    protected var colors = null;
    protected var justify = null;
    protected var origin = null;

    /**
    Initializes data bin with field coordinates and unit system
    @param layout_bin [LayoutBin]: location on screen
    @param fonts [Fonts]: reference to the global fonts instance
    @param colors [Colors]: reference to the global colors instance
    @param justify [Toybox::Graphics.TEXT_JUSTIFY_*]: The content justification
    @param is_metric [bool]: if metric or imperial is used
    */
    function initialize(layout_bin, config, justify) {
        self.canvas = layout_bin.canvas;
        self.config = config;
        self.fonts = config.fonts;
        self.colors = config.colors;
        self.justify = justify;
        self.origin = self.calculateOrigin(justify);
    }

    /**
    Calculates the origin based on the justification
    @param justify [Toybox::Graphics.TEXT_JUSTIFY_*]: The content justification
    */
    protected function calculateOrigin(justify) {
        var x = null;
        var y = null;

        // check if right, center or left justify
        if ( justify & 3 == Graphics.TEXT_JUSTIFY_RIGHT) {
            x = self.canvas.x2;
        } else if ( justify & Graphics.TEXT_JUSTIFY_CENTER == Graphics.TEXT_JUSTIFY_CENTER ) {
            x = self.canvas.x1 + (self.canvas.x2 - self.canvas.x1) / 2;
        } else if ( justify & Graphics.TEXT_JUSTIFY_LEFT == Graphics.TEXT_JUSTIFY_LEFT) {
            x = self.canvas.x1;
        } else {
            throw new Lang.Exception();
        }

        // check if vertical center
        if (justify & Graphics.TEXT_JUSTIFY_VCENTER == Graphics.TEXT_JUSTIFY_VCENTER) {
            y = self.canvas.y1 + (self.canvas.y2 - self.canvas.y1) / 2;
        } else {
            y = self.canvas.y1;
        }

        return new Point(Math.round(x), Math.round(y));
    }

    /**
    Can be used to set layout with dc
    @param dc [Toybox::Graphics::Dc]: Drawing context
    */
    function onLayout(dc) {
    }

    /**
    The user has just looked at their watch.
    Timers and animations may be started here.
    */
    function onExitSleep() {
    }

    /**
    Terminate any active timers and prepare for slow updates.
    */
    function onEnterSleep() {
    }

    /**
    @param dc [Toybox::Graphics::Dc]: Drawing context
    */
    function onUpdate(dc) {
        throw new NotImplementedException();
    }

    /**
    Get canvas
    */
    function getCanvas() {
        return self.canvas;
    }

    /**
    Get origin
    */
    function getOrigin() {
        return self.origin;
    }
}
