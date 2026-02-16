function StrewtNumberPattern() : StrewtPattern() constructor {
    static sign_charset = new StrewtCharset(false).including("-+");
    static digits_charset = new StrewtCharset(false).including("0123456789");
    static decimal_byte = ord(".");
    static exponent_charset = new StrewtCharset(false).including("eE");
    
    static skip = function(_reader) {
        var _position = _reader.position;
        
        _reader.try_skip_charset(sign_charset); // handle sign
        
        // handle integer part
        if (_reader.skip_charset_string(digits_charset) == 0) {
            _reader.move_to(_position);
            return 0;
        }
        
        // handle fractional part
        if (_reader.try_skip_byte(decimal_byte)) {
            if (_reader.skip_charset_string(digits_charset) == 0) {
                _reader.move_to(_position);
                return 0;
            }
        }
        
        // handle exponent part
        if (_reader.try_skip_charset(exponent_charset)) {
            _reader.try_skip_charset(sign_charset);
            if (_reader.skip_charset_string(digits_charset) == 0) {
                _reader.move_to(_position);
                return 0;
            }
        }
        
        // return skipped length if all steps succeeded
        return _reader.position - _position;
    }
}
