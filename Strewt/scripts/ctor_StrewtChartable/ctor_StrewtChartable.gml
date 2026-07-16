/// @desc A character table matching bytes to their corresponding values.
/// @arg {Any,Array} [input]                The default value or the array of chartable values.
/// @arg {Any} [blank]                      The value corresponding to the zero byte.
function StrewtChartable(_input = undefined, _blank = undefined) constructor {
    /// @desc The array matching bytes to chartable values.
    /// @returns {Array}
    table = is_array(_input) ? _input : array_create(256, _input);
    table[0] = _blank; // the terminating character should always be undefined unless specifically stated otherwise
    
    // -------------
    // Direct values
    // -------------
    
    /// @desc Configures the chartable with the given byte-value match.
    /// @arg {Real} byte                    The byte to assign the value to.
    /// @arg {Any} value                    The value to assign.
    /// @returns {Strewt.Chartable}
    static with_byte_value = function(_byte, _value) {
        _byte = floor(_byte);
        if (_byte < 1 || _byte >= 256)
            throw StrewtException.invalid_type("a string or a number in 1-255 range", _byte);
            
        table[_byte] = _value;
        return self;
    }
    
    /// @desc Configures the chartable to match the given value to the given byte, all bytes in the given array or all characters in the given string.
    /// @arg {Real,Array<Real>,String} target   The bytes/characters to match to the given value.
    /// @arg {Any} value                        The value to match.
    /// @returns {Strewt.Chartable}
    static with_value = function(_target, _value) {
        if (is_numeric(_target))
            return with_byte_value(_target, _value);
        
        if (_target == "")
            return self;
        
        if (is_string(_target)) {
            var _chartable = self;
            var _context = { value: _value, chartable: _chartable };
            string_foreach(_target, method(_context, function(_ch) {
                var _byte = strewt_byte(_ch);
                chartable.with_byte_value(_byte, value);
            }));
            return self;
        }
        
        if (is_array(_target)) {
            for (var i = 0, _count = array_length(_target); i < _count; i++) {
                with_value(_target[i], _value);
            }
            return self;
        }
        
        throw StrewtException.invalid_type("a string or a number in 1-255 range", _target);
    }
    
    // ------
    // Ranges
    // ------
    
    /// @desc Configures the chartable to match the given value to the given bytes/characters range.
    /// @arg {Real} from                    The byte/character starting the matched range.
    /// @arg {Real} to                      The byte/character ending the matched range.
    /// @returns {Strewt.Chartable}
    static with_range_value = function(_from, _to, _value) {
        static resolve_range_end = function(_end) {
            if (is_string(_end))
                _end = strewt_byte(_end);
            
            if (is_numeric(_end)) {
                _end = floor(_end);
                if (_end < 1 || _end >= 256)
                    throw StrewtException.invalid_type("a single-byte character or a number in 1-255 range", _end);
                
                return _end;
            }
            
            throw StrewtException.invalid_type("a single-byte character or a number in 1-255 range", _end);
        }
        
        _from = resolve_range_end(_from);
        _to = resolve_range_end(_to);
        
        if (_to < _from)
            throw StrewtException.chartable_invalid_range_order(_from, _to);
        
        for (var i = _from; i <= _to; i++) {
            table[i] = _value;
        }
        return self;
    }
    
    // ------------------
    // Derived chartables
    // ------------------
    
    /// @desc Creates a separate chartable with identical values.
    /// @returns {Strewt.Chartable}
    static clone = function() {
        var _input = array_create(array_length(table));
        array_copy(_input, 0, table, 0, array_length(table));
        return new StrewtChartable(_input, _input[0]);
    }
}
