function StrewtCharset(_input = false) constructor {
    if (!is_array(_input) && !is_bool(_input))
        throw StrewtException.charset_invalid_input(_input);
    
    table = is_array(_input) ? _input : array_create(256, _input);
    table[0] = false; // the terminating character should always be excluded
    
    // -------------
    // Direct values
    // -------------
    
    static with_byte_value = function(_byte, _value) {
        _byte = floor(_byte);
        if (_byte < 0 || _byte >= 256)
            throw StrewtException.charset_invalid_target(_byte);
            
        table[_byte] = _value;
        return self;
    }
    
    static with_value = function(_target, _value) {
        if (is_real(_target))
            return with_byte_value(_target, _value);
        
        if (_target == "")
            return self;
        
        if (is_string(_target)) {
            var _charset = self;
            var _context = { value: _value, charset: _charset };
            string_foreach(_target, method(_context, function(_ch) {
                var _byte = ord(_ch);
                charset.with_byte_value(_byte, value);
            }));
            return self;
        }
        
        if (is_array(_target)) {
            for (var i = 0, _count = array_length(_target); i < _count; i++) {
                with_value(_target[i], _value);
            }
            return self;
        }
        
        throw StrewtException.charset_invalid_target(_target);
    }
    
    static including = function(_chars) {
        return with_value(_chars, true);
    }
    
    static excluding = function(_chars) {
        return with_value(_chars, false);
    }
    
    // ------
    // Ranges
    // ------
    
    static with_range_value = function(_from, _to, _value) {
        static resolve_range_end = function(_end) {
            if (is_string(_end)) {
                if (string_byte_length(_end) != 1)
                    throw StrewtException.charset_invalid_range_end(_end);
                
                _end = ord(_end);
            }
            
            if (is_real(_end)) {
                _end = floor(_end);
                if (_end < 0 || _end >= 256)
                    throw StrewtException.charset_invalid_range_end(_end);
                
                return _end;
            }
            
            throw StrewtException.charset_invalid_range_end(_end);
        }
        
        _from = resolve_range_end(_from);
        _to = resolve_range_end(_to);
        
        if (_to < _from)
            throw StrewtException.charset_invalid_range_order(_from, _to);
        
        for (var i = _from; i <= _to; i++) {
            table[i] = _value;
        }
        return self;
    }
    
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
