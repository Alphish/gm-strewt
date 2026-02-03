function StrewtCharset(_input = false) : StrewtChartable(_input, false) constructor {
    if (!is_array(_input) && !is_bool(_input))
        throw StrewtException.charset_invalid_input(_input);
    
    // -------------
    // Direct values
    // -------------
    
    static including = function(_chars) {
        return with_value(_chars, true);
    }
    
    static excluding = function(_chars) {
        return with_value(_chars, false);
    }
    
    // ------
    // Ranges
    // ------
    
    static including_range = function(_from, _to) {
        return with_range_value(_from, _to, true);
    }
    
    static excluding_range = function(_from, _to) {
        return with_range_value(_from, _to, false);
    }
    
    // ----------------
    // Derived charsets
    // ----------------
    
    static clone = function() {
        var _input = array_create_ext(256, function(i) { return table[i]; });
        return new StrewtCharset(_input);
    }
    
    static inverse = function() {
        var _input = array_create_ext(256, function(i) { return !table[i]; });
        return new StrewtCharset(_input);
    }
}
