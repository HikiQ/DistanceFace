using Toybox.Lang;
using Toybox.Math;
using Toybox.Graphics;

/**
Polar to cartesian coordinate conversion
@param origin [Array[x-coordinate, y-coordinate]]: origin for the coordinate transform in cartesian
@param degs [number]: rotation around polar origin
@param r [number]: radius from polar origin
*/
function polarToCartesian(origin, degs, r) {
    var rads = Math.toRadians(degs);
    var vx = r * Math.cos(rads);
    var vy = r * Math.sin(rads);

    return [origin[0] + vx, origin[1] + vy];
}

/**
Not implemented exception for abstract methods etc
*/
class NotImplementedException extends Lang.Exception {
    function initialize() {
        Exception.initialize();
    }
}

/**
Returns a color corresponding to a given index
*/
class ColorMapper {
    var color_map = null;

    function initialize() {
        color_map = {
            0 => Graphics.COLOR_TRANSPARENT,
            1 => Graphics.COLOR_WHITE,
            2 => Graphics.COLOR_LT_GRAY,
            3 => Graphics.COLOR_DK_GRAY,
            4 => Graphics.COLOR_BLACK,
            5 => Graphics.COLOR_RED,
            6 => Graphics.COLOR_DK_RED,
            7 => Graphics.COLOR_ORANGE,
            8 => Graphics.COLOR_YELLOW,
            9 => Graphics.COLOR_GREEN,
            10 => Graphics.COLOR_DK_GREEN,
            11 => Graphics.COLOR_BLUE,
            12 => Graphics.COLOR_DK_BLUE,
            13 => Graphics.COLOR_PURPLE,
            14 => Graphics.COLOR_PINK
        };
    }

    /**
    Get the color for a given index
    @param idx [Number/String]: the color index corresponding to the color_map
    */
    function getColor(idx) {
        if( idx instanceof Lang.String ){
            idx = idx.toNumber();
        }
        if ( color_map.hasKey(idx) ) {
            return color_map[idx];
        } else {
            return Graphics.COLOR_RED;
        }
    }
}


