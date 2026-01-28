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
