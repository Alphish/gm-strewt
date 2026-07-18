/// @desc The pattern matching a string literal with delimiter pair escapes.
/// @arg {String} delimiter                     The character marking the beginning and the end of the string literal.
function StrewtStringPairEscapePattern(_delimiter = "\"") : StrewtPattern() constructor {
    /// @desc The byte marking the beginning and the end of the string literal.
    /// @returns {Real}
    delimiter_byte = strewt_byte(_delimiter);
    
    /// @desc The charset for raw string literal contents.
    /// @returns {Struct.StrewtCharset}
    content_charset = new StrewtCharset(true).excluding(_delimiter);
    
    /// @desc Skips the match at the given reader's position (if any) and returns its length.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @returns {Real}
    static skip = function(_reader) {
        var _position = _reader.position;
        while (_reader.skip_byte(delimiter_byte)) {
            _reader.skip_charset(content_charset);
            if (!_reader.skip_byte(delimiter_byte))
                return restore_positions(_reader, _position);
        }
        return _reader.position - _position;
    }
    
    /// @desc Skips the match at the given reader's position (if any), writes its interpreted content to the target buffer and returns the written length.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @arg {Id.Buffer} target                 The target to write the match into.
    /// @returns {Real}
    static read_into = function(_reader, _target) {
        var _position = _reader.position;
        var _target_from = buffer_tell(_target);
        
        if (!_reader.skip_byte(delimiter_byte))
            return 0;
        
        _reader.read_charset_into(content_charset, _target);
        if (!_reader.skip_byte(delimiter_byte))
            return restore_positions(_reader, _position, _target, _target_from);
        
        while (_reader.read_byte_into(delimiter_byte, _target)) {
            _reader.read_charset_into(content_charset, _target);
            if (!_reader.skip_byte(delimiter_byte))
                return restore_positions(_reader, _position, _target, _target_from);
        }
        
        return buffer_tell(_target) - _target_from;
    }
}
