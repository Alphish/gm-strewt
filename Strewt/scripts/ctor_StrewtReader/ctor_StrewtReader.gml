function StrewtReader(_content) constructor {
    if (is_string(_content)) {
        byte_length = string_byte_length(_content);
        content_buffer = buffer_create(byte_length + 1 /* extra byte for terminating character */, buffer_fixed, 1);
        buffer_write(content_buffer, buffer_string, _content);
    } else if (buffer_exists(_content)) {
        content_buffer = _content;
        byte_length = buffer_get_size(content_buffer) - 1;
        
        // ensuring the content buffer ends with a terminating character
        if (buffer_peek(content_buffer, byte_length, buffer_u8) != 0) {
            byte_length += 1;
            buffer_resize(content_buffer, byte_length + 1);
            buffer_poke(content_buffer, byte_length, buffer_u8, 0);
        }
    } else {
        throw StrewtException.reader_invalid_content(_content);
    }
    
    buffer_seek(content_buffer, buffer_seek_start, 0);
    position = 0;
    
    // ----------
    // Navigation
    // ----------
    
    static get_position = function() {
        return position;
    }
    
    static move_to = function(_position) {
        position = _position;
        buffer_seek(content_buffer, buffer_seek_start, position);
    }
    
    static move_by = function(_offset) {
        position += _offset;
        buffer_seek(content_buffer, buffer_seek_relative, _offset);
    }
    
    static is_end_of_string = function() {
        return position >= byte_length;
    }
    
    // ------
    // Ranges
    // ------
    
    static peek_all = function() {
        return buffer_peek(content_buffer, 0, buffer_string);
    }
    
    static peek_substring = function(_from, _to) {
        var _length = _to - _from;
        if (_length == 0)
            return "";
        
        if (_length == 1)
            return chr(buffer_peek(content_buffer, _from, buffer_u8));
    
        var _keep = buffer_peek(content_buffer, _to, buffer_u8);
        buffer_poke(content_buffer, _to, buffer_u8, 0);
        var _result = buffer_peek(content_buffer, _from, buffer_string);
        buffer_poke(content_buffer, _to, buffer_u8, _keep);
        return _result;
    }
    
    // -----
    // Bytes
    // -----
    
    static skip_byte = function() {
        if (position == byte_length)
            return false;
        
        position++;
        buffer_seek(content_buffer, buffer_seek_relative, 1);
        return true;
    }
    
    static peek_byte = function() {
        return buffer_peek(content_buffer, position, buffer_u8);
    }
    
    static read_byte = function() {
        if (position == byte_length)
            return 0;
        
        position++;
        return buffer_read(content_buffer, buffer_u8);
    }
    
    static try_skip_byte = function(_byte) {
        if (buffer_read(content_buffer, buffer_u8) == _byte) {
            position++;
            return true;
        } else {
            buffer_seek(content_buffer, buffer_seek_relative, -1);
            return false;
        }
    }
    
    static peeks_byte = function(_byte) {
        return buffer_peek(content_buffer, position, buffer_u8) == _byte;
    }
    
    static try_skip_byte_sequence = function(_bytes) {
        var _length = array_length(_bytes);
        if (position + _length > byte_length)
            return false;
        
        for (var i = 0; i < _length; i++) {
            if (buffer_read(content_buffer, buffer_u8) != _bytes[i]) {
                buffer_seek(content_buffer, buffer_seek_start, position);
                return false;
            }
        }
        position += _length;
        return true;
    }
    
    static peeks_byte_sequence = function(_bytes) {
        var _length = array_length(_bytes);
        if (position + _length > byte_length)
            return false;
        
        for (var i = 0; i < _length; i++) {
            if (buffer_peek(content_buffer, position + i, buffer_u8) != _bytes[i])
                return false;
        }
        return true;
    }
    
    // ----------
    // Characters
    // ----------
    
    static get_utf8_character_length = function(_byte) {
        static lookup = array_create_ext(256, function(i) {
            if (i == 0)
                return 0;
            else if ((i & 0b11111_000) == 0b11111_000)
                return -1;
            else if ((i & 0b11111_000) == 0b11110_000)
                return 4;
            else if ((i & 0b1111_0000) == 0b1110_0000)
                return 3;
            else if ((i & 0b111_00000) == 0b110_00000)
                return 2;
            else if ((i & 0b11_000000) == 0b10_000000)
                return -1;
            else
                return 1;
        });
        return lookup[_byte];
    }
    
    static get_utf8_character_mask = function(_byte) {
        static lookup = array_create_ext(256, function(i) {
            if (i == 0)
                return 0;
            else if ((i & 0b11111_000) == 0b11111_000)
                return 0;
            else if ((i & 0b11111_000) == 0b11110_000)
                return 0b00000_111;
            else if ((i & 0b1111_0000) == 0b1110_0000)
                return 0b0000_1111;
            else if ((i & 0b111_00000) == 0b110_00000)
                return 0b000_11111;
            else if ((i & 0b11_000000) == 0b10_000000)
                return 0;
            else
                return 0b11111111;
        });
        return lookup[_byte];
    }
    
    static peek_character = function() {
        var _byte = buffer_peek(content_buffer, position, buffer_u8);
        var _length = get_utf8_character_length(_byte);
        if (_length < 0)
            throw StrewtException.reader_invalid_utf8_byte(_byte);
        else if (_length == 0)
            return "";
        
        var _codepoint = _byte & get_utf8_character_mask(_byte);
        for (var i = 1; i < _length; i++) {
            _byte = buffer_peek(content_buffer, position + i, buffer_u8);
            _codepoint = (_codepoint << 6) | (_byte & 0b00111111);
        }
        return chr(_codepoint);
    }
    
    static read_character = function() {
        var _byte = buffer_read(content_buffer, buffer_u8);
        var _length = get_utf8_character_length(_byte);
        if (_length < 0) {
            buffer_seek(content_buffer, buffer_seek_relative, -1);
            throw StrewtException.reader_invalid_utf8_byte(_byte);
        } else if (_length == 0) {
            buffer_seek(content_buffer, buffer_seek_relative, -1);
            return "";
        }
        
        var _codepoint = _byte & get_utf8_character_mask(_byte);
        repeat (_length - 1) {
            _byte = buffer_read(content_buffer, buffer_u8);
            _codepoint = (_codepoint << 6) | (_byte & 0b00111111);
        }
        position += _length;
        return chr(_codepoint);
    }
    
    // -------
    // Strings
    // -------
    
    static try_skip_string = function(_str) {
        var _length = string_byte_length(_str);
        if (position + _length > byte_length)
            return false;
        
        var _result = peek_substring(position, position + _length) == _str;
        if (_result) {
            buffer_seek(content_buffer, buffer_seek_relative, _length);
            position += _length;
        }
        return _result;
    }
    
    static peeks_string = function(_str) {
        var _length = string_byte_length(_str);
        if (position + _length > byte_length)
            return false;
        
        return peek_substring(position, position + _length) == _str;
    }
    
    // --------
    // Charsets
    // --------
    
    static try_skip_charset = function(_charset) {
        var _table = _charset.table;
        if (_table[buffer_read(content_buffer, buffer_u8)]) {
            position += 1;
            return true;
        } else {
            buffer_seek(content_buffer, buffer_seek_relative, -1);
            return false;
        }
    }
    
    static try_peek_charset = function(_charset) {
        var _table = _charset.table;
        var _byte = buffer_peek(content_buffer, position, buffer_u8);
        return _table[_byte] ? _byte : 0;
    }
    
    static try_read_charset = function(_charset) {
        var _table = _charset.table;
        var _byte = buffer_read(content_buffer, buffer_u8);
        if (_table[_byte]) {
            position += 1;
            return _byte;
        } else {
            buffer_seek(content_buffer, buffer_seek_relative, -1);
            return 0;
        }
    }
    
    static skip_charset_string = function(_charset) {
        var _table = _charset.table;
        while (_table[buffer_read(content_buffer, buffer_u8)]) {
            position += 1;
        }
        buffer_seek(content_buffer, buffer_seek_relative, -1);
    }
    
    static peek_charset_string = function(_charset) {
        var _table = _charset.table;
        var _to = position;
        while (_table[buffer_read(content_buffer, buffer_u8)]) {
            _to += 1;
        }
        buffer_seek(content_buffer, buffer_seek_start, position);
        return peek_substring(position, _to);
    }
    
    static read_charset_string = function(_charset) {
        var _table = _charset.table;
        var _from = position;
        while (_table[buffer_read(content_buffer, buffer_u8)]) {
            position += 1;
        }
        buffer_seek(content_buffer, buffer_seek_relative, -1);
        return peek_substring(_from, position);
    }
    
    // -------
    // Cleanup
    // -------
    
    static cleanup = function() {
        buffer_delete(content_buffer);
    }
}
