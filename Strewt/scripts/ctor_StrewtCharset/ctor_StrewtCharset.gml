/// @desc A charset indicating which bytes are included, and which aren't.
/// @arg {Bool,Array<Bool>} [input]             The default byte inclusion/exclusion or the array of inclusions/exclusions.
function StrewtCharset(_input = false) : StrewtChartable(_input, false) constructor {
    if (!is_array(_input) && !is_bool(_input))
        throw StrewtException.invalid_type("an array or a bool", _input);
    
    // -------------
    // Direct values
    // -------------
    
    /// @desc Configures the charset to include the given byte, all bytes in the given array or all characters in the given string.
    /// @arg {Real,Array<Real>,String} target   The value(s) to include.
    /// @returns {Struct.StrewtCharset}
    static including = function(_target) {
        return with_value(_target, true);
    }
    
    /// @desc Configures the charset to exclude the given byte, all bytes in the given array or all characters in the given string.
    /// @arg {Real,Array<Real>,String} target   The value(s) to exclude.
    /// @returns {Struct.StrewtCharset}
    static excluding = function(_target) {
        return with_value(_target, false);
    }
    
    // ------
    // Ranges
    // ------
    
    /// @desc Configures the charset to include the given bytes/characters range.
    /// @arg {Real} from                    The byte/character starting the included range.
    /// @arg {Real} to                      The byte/character ending the included range.
    /// @returns {Strewt.Chartable}
    static including_range = function(_from, _to) {
        return with_range_value(_from, _to, true);
    }
    
    /// @desc Configures the charset to exclude the given value to the given bytes/characters range.
    /// @arg {Real} from                    The byte/character starting the excluded range.
    /// @arg {Real} to                      The byte/character ending the excluded range.
    /// @returns {Strewt.Chartable}
    static excluding_range = function(_from, _to) {
        return with_range_value(_from, _to, false);
    }
    
    // ----------------
    // Derived charsets
    // ----------------
    
    /// @desc Creates a separate charset with identical values.
    /// @returns {Strewt.Chartable}
    static clone = function() {
        var _input = array_create(array_length(table));
        array_copy(_input, 0, table, 0, array_length(table));
        return new StrewtCharset(_input);
    }
    
    /// @desc Creates a separate charset with inclusions/exclusions flipped (except zero byte which is always excluded).
    /// @returns {Strewt.Chartable}
    static inverse = function() {
        var _input = array_create_ext(256, function(i) { return !table[i]; });
        return new StrewtCharset(_input);
    }
}
