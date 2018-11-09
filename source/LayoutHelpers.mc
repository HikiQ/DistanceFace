using Toybox.Math;

/**
Holds one x-y pair
*/
class Point {
    var x = null;
    var y = null;

    function initialize(x, y) {
        self.x = x;
        self.y = y;
    }
}

/**
Holds one x1, y1, x2, y2 tuple
*/
class Bin {
    var x1 = null;
    var y1 = null;
    var x2 = null;
    var y2 = null;

    /**
    Generator function to deep copy a bin
    */
    static function copy(other) {
        var new_bin = new Bin();

        new_bin.x1 = other.x1;
        new_bin.y1 = other.y1;
        new_bin.x2 = other.x2;
        new_bin.y2 = other.y2;

        return new_bin;
    }

    /**
    Returns bin width
    */
    function getWidth() {
        return self.x2 - self.x1 + 1;
    }

    /**
    Returns bin height
    */
    function getHeight() {
        return self.y2 - self.y1 + 1;
    }
}

/**
Layout bins can contain margins inside the bin
*/
class Margin {
    var top = 0;
    var right = 0;
    var bottom = 0;
    var left = 0;

    function initialize(top, right, bottom, left) {
        self.top = Math.round(top);
        self.right = Math.round(right);
        self.bottom = Math.round(bottom);
        self.left = Math.round(left);
    }
}


/**
Contains one layout bin
*/
class LayoutBin {
    var corners = new Bin();
    var canvas = null;
    var margin = null;

    /**
    Stores rounded number
    */
    function initialize(x1, y1, x2, y2) {
        self.corners.x1 = Math.round(x1);
        self.corners.y1 = Math.round(y1);
        self.corners.x2 = Math.round(x2);
        self.corners.y2 = Math.round(y2);

        // copy bin to canvas
        self.canvas = Bin.copy(self.corners);
    }

    /**
    Sets new margin values.
    */
    function setMargin(top, right, bottom, left) {
        self.margin = new Margin(top, right, bottom, left);

        self.canvas.x1 = self.corners.x1 + self.margin.left;
        self.canvas.y1 = self.corners.y1 + self.margin.top;
        self.canvas.x2 = self.corners.x2 - self.margin.right;
        self.canvas.y2 = self.corners.y2 - self.margin.bottom;
    }
}

/**
Stores all layout field positions
*/
class Layout {

    // hold positions in array and think its faster than dict
    var bins = null;

    // field indexes: FIELD_row_column
    enum {
        FIELD_1_1 = 0,
        FIELD_1_2,
        FIELD_1_3,
        FIELD_2_1,
        FIELD_2_2,
        FIELD_2_3,
        FIELD_3_1,
        FIELD_4_1,

        FIELD_ARRAY_SIZE,
    }

    /**
    Initialize positions with nulls
    */
    function initialize() {
        self.bins = new [FIELD_ARRAY_SIZE];
        for (var i = FIELD_1_1; i < FIELD_ARRAY_SIZE; i++) {
            self.bins[i] = null;
        }
    }
}

