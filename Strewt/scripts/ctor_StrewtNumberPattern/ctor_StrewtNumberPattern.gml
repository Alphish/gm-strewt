/// @desc The pattern matching a number representation - an optional sign, the mandatory integer part, an optional fractional part and an optional exponent part.
function StrewtNumberPattern() : StrewtPattern() constructor {
    /// @ignore
    static sign_charset = new StrewtCharset(false).including("-+");
    /// @ignore
    static digits_charset = new StrewtCharset(false).including("0123456789");
    /// @ignore
    static decimal_byte = ord(".");
    /// @ignore
    static exponent_charset = new StrewtCharset(false).including("eE");
    
    /// @desc Skips the match at the given reader's position (if any) and returns its length.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @returns {Real}
    static skip = function(_reader) {
        var _position = _reader.position;
        
        _reader.skip_charset(sign_charset); // handle sign
        
        // handle integer part
        if (_reader.skip_charset(digits_charset) == 0)
            return restore_positions(_reader, 0);
        
        // handle fractional part
        if (_reader.skip_byte(decimal_byte)) {
            if (_reader.skip_charset(digits_charset) == 0) {
                _reader.move_by(-1);
                return _reader.position - _position;
            }
        }
        
        // handle exponent part
        if (_reader.skip_charset(exponent_charset)) {
            var _sign_length = _reader.skip_charset(sign_charset);
            if (_reader.skip_charset(digits_charset) == 0) {
                _reader.move_by(-1 - _sign_length);
                return _reader.position - _position;
            }
        }
        
        // return skipped length if all segments were processed without interruption
        return _reader.position - _position;
    }
}
