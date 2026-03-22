function StrewtStringCharacterEscapePattern(_terminator = "\"", _escape = "\\", _withnewlines = false) : StrewtPattern() constructor {
    terminator_byte = ord(_terminator);
    escape_byte = ord(_escape);
    literal_charset = new StrewtCharset(true)
        .with_byte_value(terminator_byte, false)
        .with_byte_value(escape_byte, false)
        .with_byte_value(ord("\n"), _withnewlines)
        .with_byte_value(ord("\r"), _withnewlines);
    
    escape_mappings = new StrewtChartable(undefined);
    escape_mappings.with_value(terminator_byte, chr(terminator_byte));
    escape_mappings.with_value(escape_byte, chr(escape_byte));
    
    // -----
    // Setup
    // -----
    
    static with_custom_escape = function(_key, _escape) {
        escape_mappings.with_value(_key, _escape);
        return self;
    }
    
    static with_newline_escapes = function() {
        return self
            .with_custom_escape("n", "\n")
            .with_custom_escape("r", "\r");
    }
    
    static with_json_escapes = function() {
        return self
            .with_custom_escape("\"", "\"")
            .with_custom_escape("\\", "\\")
            .with_custom_escape("/", "/")
            .with_custom_escape("b", "\b")
            .with_custom_escape("f", "\f")
            .with_custom_escape("n", "\n")
            .with_custom_escape("r", "\r")
            .with_custom_escape("t", "\t")
            .with_custom_escape("u", read_unicode);
    }
    
    static read_unicode = function(_reader, _target = undefined) {
        static digits_by_char = new StrewtChartable(NaN)
            .with_value("0", 0).with_value("1", 1).with_value("2", 2).with_value("3", 3).with_value("4", 4)
            .with_value("5", 5).with_value("6", 6).with_value("7", 7).with_value("8", 8).with_value("9", 9)
            .with_value("aA", 10).with_value("bB", 11).with_value("cC", 12)
            .with_value("dD", 13).with_value("eE", 14).with_value("fF", 15);
        
        if (_reader.position + 4 > _reader.byte_length)
            return 0;
        
        var _bulk = buffer_read(_reader.content_buffer, buffer_u32);
        _reader.position += 4;
        var _digits = digits_by_char.table;
        
        // due to endianness, the least significant digit of the read 32-bit integer is at the start
        // so e.g. the bytes of "A234" will be read as "432A"
        // also, bytes are summed with "+" rather than "|" so that NaN - indicating invalid hex code - is propagated properly 
        var _codepoint = (_digits[(_bulk >> 24) & 0xff]) + (_digits[(_bulk >> 16) & 0xff] << 4) + (_digits[(_bulk >> 8) & 0xff] << 8) + (_digits[_bulk & 0xff] << 12);
        if (is_nan(_codepoint))
            return 0;
        
        var _character = chr(_codepoint);
        if (!is_undefined(_target))
            buffer_write(_target, buffer_text, _character);
        
        return string_byte_length(_character);
    }
    
    // ----------
    // Processing
    // ----------
    
    static skip = function(_reader) {
        var _position = _reader.position;
        if (!_reader.skip_byte(terminator_byte))
            return 0;
        
        while (true) {
            _reader.skip_charset(literal_charset);
            if (_reader.skip_byte(terminator_byte))
                return _reader.position - _position;
            
            if (!_reader.skip_byte(escape_byte))
                return restore_positions(_reader, _position);
            
            var _escape_mapping = _reader.read_chartable(escape_mappings);
            if (is_method(_escape_mapping)) {
                if (!_escape_mapping(_reader))
                    return restore_positions(_reader, _position);
            } else if (!is_string(_escape_mapping) && !is_undefined(_escape_mapping)) {
                restore_positions(_reader, _position);
                throw StrewtException.invalid_escape(_escape_mapping);
            }
        }
    }
    
    static read_into = function(_reader, _target) {
        var _position = _reader.position;
        if (!_reader.skip_byte(terminator_byte))
            return 0;
        
        var _target_from = buffer_tell(_target);
        
        while (true) {
            _reader.read_charset_into(literal_charset, _target);
            if (_reader.skip_byte(terminator_byte))
                return buffer_tell(_target) - _target_from;
            
            if (!_reader.skip_byte(escape_byte))
                return restore_positions(_reader, _position, _target, _target_from);
            
            var _escape_mapping = _reader.read_chartable(escape_mappings);
            if (is_method(_escape_mapping)) {
                if (!_escape_mapping(_reader, _target))
                    return restore_positions(_reader, _position, _target, _target_from);
            } else if (is_string(_escape_mapping)) {
                buffer_write(_target, buffer_text, _escape_mapping);
            } else if (is_undefined(_escape_mapping)) {
                buffer_write(_target, buffer_u8, buffer_peek(_reader.content_buffer, _reader.position - 1, buffer_u8));
            } else {
                restore_positions(_reader, _position, _target, _target_from);
                throw StrewtException.invalid_escape(_escape_mapping);
            }
        }
    }
}
