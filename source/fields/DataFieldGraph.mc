using Toybox.ActivityMonitor;
using Toybox.Lang;

class DataFieldGraph extends DataFieldBase {

    protected var bin_x1 = null;
    protected var bin_x2 = null;

    protected var x = null;
    protected var y = null;
    protected var w = null;
    protected var h = null;

    protected var bar_margin = null;

    // init data (7 days of history)
    protected var data = new [7];

    // convert from cm to km
    protected var scaler = 100000.0;

    // grid interval in display units
    protected var grid_lines_max = 5;
    protected var grid_spacing = [5, 10, 25, 100, 500, 1000, 5000];

    function initialize(layout_bin, config, justify, is_metric) {
        bin_x1 = layout_bin.corners.x1;
        bin_x2 = layout_bin.corners.x2;

        layout_bin.setMargin(0, 30, 0, 30);
        DataFieldBase.initialize(layout_bin, config, justify);

        x = canvas.x1;
        y = canvas.y1;
        w = canvas.getWidth();
        h = canvas.getHeight();

        bar_margin = 2;

        if ( !is_metric ) {
            scaler = 160934.4;
        }
    }

    function onUpdate(dc) {
        // get last 7 days Toybox::ActivityMonitor::Info
        var activity_history = ActivityMonitor.getHistory();

        // get current Toybox::ActivityMonitor::Info
        var activity_info = ActivityMonitor.getInfo();

        // to scale the bars to fill the graph
        var max_value = 0;

        // clear data
        for (var i = 0; i < data.size(); i++) {
            data[i] = 0.0;
        }

        // add today
        var today = 0.0;
        if (activity_info.distance != null) {
            today = activity_info.distance / self.scaler;
            max_value = today;
        }

        // Add to the data array and find max value
        var day = null;
        var v = null;
        var N = data.size();
        for (var i = 0; i < activity_history.size(); i++) {
            day = activity_history[i];
            if (day != null && day.distance != null) {
                v = day.distance / self.scaler;
                data[N-1-i] = v;

                // find max
                if (v > max_value) {
                    max_value = v;
                }
            }
        }

        // set bar width and base level
        var bar_and_margin_width = Math.floor(w / (N+1));
        var y_base = canvas.y2;

        // scale data to 0-1 and draw. nothing to do if max value == 0
        if (max_value > 0 ) {

            // calculate and draw grid
            var grid = calculateGridSpacing(max_value);
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            drawGrid(dc, y_base, grid);
            dc.setColor(self.colors.foreground, Graphics.COLOR_TRANSPARENT);

            // draw today
            v = today / max_value;
            var y_top = y_base - h*v;

            // today block in open color
            var i = N;
            var x_left = x + i*bar_and_margin_width + bar_margin;
            var x_right = x + (i+1)*bar_and_margin_width - bar_margin;

            // draw open rectange
            drawOpenBar(dc, x_left, x_right, y_base, y_top);

            // draw history
            for (var i = 0; i < N; i++) {
                v = data[i] / max_value;

                y_top = y_base - h*v;
                x_left = x + i*bar_and_margin_width + bar_margin;
                x_right = x + (i+1)*bar_and_margin_width - bar_margin;

                drawFilledBar(dc, x_left, x_right, y_base, y_top);
            }

            // draw max grid line's value
            drawGridMaximum(dc, y_base, bar_and_margin_width, bar_margin, grid);
        }
    }

    /**
    Calculates grid spacing for given max value
    */
    protected function calculateGridSpacing(max_value) {

        // not enough data for grid
        if (max_value <= grid_spacing[0]) {
            return null;
        }

        // calculate how many background lines is needed
        var n_lines = grid_lines_max + 1;
        var spacing = null;
        for (var i = 0; i < grid_spacing.size() && n_lines > grid_lines_max; i++) {
            spacing = grid_spacing[i];
            n_lines = Math.floor(max_value / spacing);
        }

        // just in case user gets more than normal by walking (+30 000 km / day)
        // There is some numerical limit that breaks calculation after  2.1e9 m so don't care
        //if (n_lines > grid_lines_max + 1) {
        //    return null;
        //}

        // pixels / km * km => pixels
        var grid_spacing_pixels = h / max_value * spacing;

        return [n_lines, grid_spacing_pixels, spacing];
    }

    /**

    */
    protected function drawGrid(dc, y_base, grid) {
        if (grid != null) {
            // draw grid
            var y_grid = null;

            for (var i = 1; i <= grid[0]; i++) {
                y_grid = y_base - i*grid[1];
                dc.drawLine(bin_x1, y_grid, bin_x2, y_grid);
            }
        }
    }

    /**
    Draw the value of the largest grid line to the grid line
    */
    protected function drawGridMaximum(dc, y_base, bar_and_margin_width,  bar_margin, grid) {

        if (grid == null) {
            return;
        }

        var x_text = x + (bar_and_margin_width - bar_margin) / 2;
        var y_top_grid_line = y_base - grid[0]*grid[1] -1;

        var top_grid_line_txt = (grid[0]*grid[2]).format("%.0f");

        // draw background colored box behind the text
        var txt_dims = dc.getTextDimensions(top_grid_line_txt, Graphics.FONT_XTINY);
        var box_height = txt_dims[1]*0.8;

        dc.setColor(self.colors.background, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(x_text-txt_dims[0] +1, y_top_grid_line-box_height/2 +2, txt_dims[0], box_height, 1);

        // write
        dc.setColor(self.colors.foreground, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x_text, y_top_grid_line, Graphics.FONT_XTINY, top_grid_line_txt,
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);

    }
    /**

    */
    protected function drawFilledBar(dc, x_left, x_right, y_base, y_top) {
        var p = [[x_left, y_base], [x_left, y_top], [x_right, y_top], [x_right, y_base]];
        dc.fillPolygon(p);
    }

    /**

    */
    protected function drawOpenBar(dc, x_left, x_right, y_base, y_top) {
        if (y_top < y_base) {
            dc.drawLine(x_left, y_base, x_left, y_top);
            dc.drawLine(x_left, y_top, x_right, y_top);
            dc.drawLine(x_right, y_top, x_left, y_top); // try to solve the missing corner by drawing the top twice
            dc.drawLine(x_right, y_base, x_right, y_top);
        }
    }


} // DataFieldGraph
