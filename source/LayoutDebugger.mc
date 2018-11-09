using Toybox.Graphics;

/**
Contains methods to visualize and debug generated layout
*/
class LayoutDebugger {

    /**
    Draws bin's edges
    @param dc [Toybox::Graphics::Dc]: Drawing context
    @param layout_bins [Bin]
    */
    function drawBin(dc, bin) {
        dc.drawLine(bin.x1, bin.y1, bin.x2, bin.y1);
        dc.drawLine(bin.x2, bin.y1, bin.x2, bin.y2);
        dc.drawLine(bin.x2, bin.y2, bin.x1, bin.y2);
        dc.drawLine(bin.x1, bin.y2, bin.x1, bin.y1);
    }

    /**
    Draws layout bin's edges
    @param dc [Toybox::Graphics::Dc]: Drawing context
    @param layout_bins [array<LayoutBin>]
    */
    function drawLayoutGrid(dc, layout_bins) {
        for (var i = 0; i < layout_bins.size(); i++) {
            drawBin(dc, layout_bins[i].corners);
        }
    } // drawLayoutGrid

    /**
    Draws the data fields's canvas and origin based on array of data fields
    @param dc [Toybox::Graphics::Dc]: Drawing context
    @param data_fields [array<DataFieldBase>]
    */
    function drawCanvasAndOrigin(dc, data_fields) {
        var o = null;
        for (var i = 0; i < data_fields.size(); i++) {
            o = data_fields[i].getOrigin();
            dc.fillCircle(o.x, o.y, 2);

            drawBin(dc, data_fields[i].getCanvas());
        }
    } // drawCanvasAndOrigin

} // LayoutDebugger
