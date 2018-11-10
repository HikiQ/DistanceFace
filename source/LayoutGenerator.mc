/**
Wraps layout generation functions
*/
class LayoutGenerator {

    /*
    Splits given layout_bin vertically to heights.size() layout_bins
    @param layout_bin [LayoutBin]: contains bin to split
    @param heights [Array<double>]: Contains the bin size definition

    size:
        <= 0: no definition
        < 1: fraction of the full width
        >= 1: in pixels
    */
    function splitVertically(layout_bin, heights) {
        var height = layout_bin.corners.getHeight();
        var new_edges = split(layout_bin.corners.y1, layout_bin.corners.y2, height, heights);

        // generate new bins
        var new_bins = [];
        var b = null;
        for (var i = 0; i < new_edges.size(); i++) {
            b = new LayoutBin(layout_bin.corners.x1, new_edges[i][0], layout_bin.corners.x2, new_edges[i][1]);
            if (layout_bin.margin != null) {
                b.setMargin(layout_bin.margin.top, layout_bin.margin.right, layout_bin.margin.bottom, layout_bin.margin.left);
            }
            new_bins.add(b);
        }
        return new_bins;
    }

    /*
    Splits given layout_bin horizontally to widths.size() layout_bins
    @param layout_bin [LayoutBin]: contains bin to split
    @param widths [Array<double>]: Contains the bin size definition

    size:
        <= 0: no definition
        < 1: fraction of the full width
        >= 1: in pixels
    */
    function splitHorizontally(layout_bin, widths) {
        var width = layout_bin.corners.getWidth();
        var new_edges = split(layout_bin.corners.x1, layout_bin.corners.x2, width, widths);

        // generate new bins
        var new_bins = [];
        var b = null;
        for (var i = 0; i < new_edges.size(); i++) {
            b = new LayoutBin(new_edges[i][0], layout_bin.corners.y1, new_edges[i][1], layout_bin.corners.y2);
            if (layout_bin.margin != null) {
                b.setMargin(layout_bin.margin.top, layout_bin.margin.right, layout_bin.margin.bottom, layout_bin.margin.left);
            }
            new_bins.add(b);
        }
        return new_bins;
    }

    /**
    Splitter worker
    @param x1: Start corner (x or y)
    @param x2: End corner (x or y)
    @param bin_size: Size of the given bin in pixels (width or height)
    @param sizes [Array<double>]: Contains the bin size definition
    */
    protected function split(x1, x2, bin_size, sizes) {

        // trivial cases are handled without error
        if (sizes.size() <= 1) {
            return [[x1, x2]];
        }

        var calculated_sizes = new [sizes.size()];
        var not_defined = [];
        var used_space = 0;

        // check what kind of sizes we got
        var s = null;
        for (var i = 0; i < sizes.size(); i++) {
            s = sizes[i];
            if (s <= 0) {
                not_defined.add(i);
            } else if (s < 1) {
                s *= bin_size;
                calculated_sizes[i] = s;
                used_space += s;
            } else {
                calculated_sizes[i] = s;
                used_space += s;
            }
        }

        // calculate undefined size from space left
        var n_not_defined = not_defined.size();
        if (n_not_defined > 0) {
            s = (bin_size - used_space) / n_not_defined;
            for (var i = 0; i < n_not_defined; i++) {
                calculated_sizes[not_defined[i]] = s;
                used_space += s;
            }
        }

        // check that we have not used too much space
        if (used_space > bin_size + 0.1) {
            System.println("split::Combined size is too large");
            throw new Lang.Exception();
        }

        // calculate new edges
        var edges = [];
        var x = x1;
        var e = null;
        for (var i = 0; i < calculated_sizes.size(); i++) {
            s = calculated_sizes[i];
            e = x + s - 1;
            edges.add([x, e]);
            x = e + 1;
        }

        return edges;
    } // split

} // LayoutGenerator

