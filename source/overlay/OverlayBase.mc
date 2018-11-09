class OverlayBase {

    protected var config = null;
    protected var fonts = null;
    protected var colors = null;

    /**
    Initializes overlay common data
    @param fonts [Fonts]: reference to the global fonts instance
    @param colors [Colors]: reference to the global colors instance
    */
    function initialize(config) {
        self.config = config;
        self.fonts = config.fonts;
        self.colors = config.colors;
    }

    /**
    Can be used to set layout with dc
    @param dc [Toybox::Graphics::Dc]: Drawing context
    */
    function onLayout(dc) {
    }

    /**
    @param dc [Toybox::Graphics::Dc]: Drawing context
    */
    function onUpdate(dc) {
        throw new NotImplementedException();
    }
}
