using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

using Toybox.ActivityMonitor;

/**
Defines all the fonts used (given to all the DataFields as a ref)
*/
class Fonts {
    var data = Graphics.FONT_TINY;
    var data_height = null;
    var time = Graphics.FONT_SYSTEM_NUMBER_THAI_HOT;
    var time_height = null;
}

/**
All the colors used (given to all the DataFields as a ref)
*/
class Colors {
    var foreground = Graphics.COLOR_WHITE;
    var background = Graphics.COLOR_BLACK;
    var grid = Graphics.COLOR_DK_GRAY;
}

/**
Wraps all the configs given to data fields and overlays
*/
class Config {
    var fonts = new Fonts();
    var colors = new Colors();
}

class WatchFaceWithBatteryStatusView extends Ui.WatchFace {

    //! global font, color, etc definition
    protected var config = null;

    //! holds all content positions
    protected var layout = null;

    //! holds all the data field updaters [Array<DataField>]
    protected var fields = null;

    //! holds all the overlay updaters [Array<Overlay>]. Could be in fields but overlays are drawn after fields
    protected var overlays = null;

    function initialize() {
        WatchFace.initialize();
        init();
    }

    protected function init() {
        config = new Config();
        layout = new Layout();
        fields = [];
        overlays = [];
    }

    protected function loadResources() {
        var app = Application.getApp();
        var mapper = new ColorMapper();

        config.colors.foreground = mapper.getColor(app.getProperty("colorForeground"));
        config.colors.background = mapper.getColor(app.getProperty("colorBackground"));
        config.colors.grid = mapper.getColor(app.getProperty("colorGrid"));
    }

    // Load your resources here
    function onLayout(dc) {
        loadResources();
        var ref = Graphics.COLOR_BLACK;

        config.fonts.time_height = dc.getFontHeight(config.fonts.time);
        config.fonts.data_height = dc.getFontHeight(config.fonts.data);

        var layout_generator = new LayoutGenerator();
        var canvas = new LayoutBin(0, 0, dc.getWidth()-1, dc.getHeight()-1);
        canvas = layout_generator.splitVertically(canvas, [-1, config.fonts.time_height - 10, -1]);

        // time
        layout.bins[layout.FIELD_3_1] = canvas[1];

        // graph
        layout.bins[layout.FIELD_4_1] = canvas[2];

        // use the upper part for data fields
        canvas = layout_generator.splitVertically(canvas[0], [-1, -1]);
        var center_column = 25;

        // 1st row
        canvas[0].setMargin(5, 0, 0, 0);
        var row_1 = layout_generator.splitHorizontally(canvas[0], [-1, center_column, -1]);
        layout.bins[layout.FIELD_1_1] = row_1[0];
        layout.bins[layout.FIELD_1_2] = row_1[1];
        layout.bins[layout.FIELD_1_3] = row_1[2];

        // 2nd row
        canvas[1].setMargin(2, 0, 0, 0);
        var row_2 = layout_generator.splitHorizontally(canvas[1], [-1, center_column, -1]);
        layout.bins[layout.FIELD_2_1] = row_2[0];
        layout.bins[layout.FIELD_2_2] = row_2[1];
        layout.bins[layout.FIELD_2_3] = row_2[2];

        // add fields and call onLayout for all fields
        addFields();
        for (var i = 0; i < fields.size(); i++) {
            fields[i].onLayout(dc);
        }

        // add overlays and call onLayout for all overlays
        addOverlays();
        for (var i = 0; i < overlays.size(); i++) {
            overlays[i].onLayout(dc);
        }
    }

    /**
    Add all the field updaters
    */
    protected function addFields() {
        var settings = System.getDeviceSettings();
        var is_24h = settings.is24Hour;
        var is_metric = settings.distanceUnits != System.UNIT_STATUTE;

        fields.add(new DataFieldNotifications(layout.bins[layout.FIELD_1_1], config, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER));
        fields.add(new DataFieldConnection(layout.bins[layout.FIELD_1_2], config, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
        fields.add(new DataFieldBattery(layout.bins[layout.FIELD_1_3], config, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER));

        fields.add(new DataFieldDate(layout.bins[layout.FIELD_2_1], config, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER));
        fields.add(new DataFieldAlarm(layout.bins[layout.FIELD_2_2], config, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
        fields.add(new DataFieldDistance(layout.bins[layout.FIELD_2_3], config, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER, is_metric));

        fields.add(DataFieldTimeGenerator.generate(layout.bins[layout.FIELD_3_1], config, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, is_24h));

        fields.add(new DataFieldGraph(layout.bins[layout.FIELD_4_1], config, Graphics.TEXT_JUSTIFY_LEFT, is_metric));
    }

    /**
    Add all the overlay updaters
    */
    protected function addOverlays() {
        overlays.add(new OverlayMoveBar(config));
        overlays.add(new OverlayStepBar(config));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // clear canvas
        dc.setColor(config.colors.background, config.colors.background);
        dc.clear();
        dc.setColor(config.colors.foreground, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);

        // to debug the grid
        //var layout_debugger = new LayoutDebugger();
        //layout_debugger.drawLayoutGrid(dc, layout.bins);
        //layout_debugger.drawCanvasAndOrigin(dc, fields);

        // update all fields and overlays
        for (var i = 0; i < fields.size(); i++) {
            fields[i].onUpdate(dc);
        }
        for (var i = 0; i < overlays.size(); i++) {
            overlays[i].onUpdate(dc);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
        for (var i = 0; i < fields.size(); i++) {
            fields[i].onExitSleep();
        }
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        for (var i = 0; i < fields.size(); i++) {
            fields[i].onEnterSleep();
        }
    }

}
