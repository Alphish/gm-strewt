/// @desc A reader for scanning through a buffer-based text.
/// @arg {String,Id.Buffer} content         The content to process, given as a string or a buffer of text bytes.
function StrewtReader(_content) constructor {
    
    /// @desc The length of the content in bytes.
    /// @returns {Real}
    byte_length = 0;
    
    /// @desc The buffer of the content to be processed.
    /// @returns {Id.Buffer}
    content_buffer = undefined;
    
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
    
    /// @desc The current position in the processed content.
    /// @returns {Real}
    position = 0;
    
    /// @desc The name specifying the source of the processed content, such as a filename.
    /// @returns {String}
    source_name = undefined;
    
    // -----
    // Setup
    // -----
    
    /// @desc Configures the reader with the given source name.
    /// @arg {String} name                  The name of the source the content comes from.
    /// @returns {Struct.StrewtReader}
    static with_source_name = function(_name) {
        source_name = _name;
        return self;
    }
    
    // ----------
    // Navigation
    // ----------
    
    /// @desc Gets the current reader position (in bytes) within the processed content.
    /// @returns {Real}
    static get_position = function() {
        return position;
    }
    
    /// @desc Moves the reader position to the given byte.
    /// @arg {Real} position                The reader position to move to.
    static move_to = function(_position) {
        position = _position;
        buffer_seek(content_buffer, buffer_seek_start, position);
    }
    
    /// @desc Moves the reader position by the given number of bytes.
    /// @arg {Real} offset                  The number of bytes to move the reader position by.
    static move_by = function(_offset) {
        position += _offset;
        buffer_seek(content_buffer, buffer_seek_relative, _offset);
    }
    
    /// @desc Checks whether the reader is at the end of content.
    /// @returns {Bool}
    static is_end_of_content = function() {
        return position >= byte_length;
    }
    
    /// @desc Gets the current reader location struct (line, column, position).
    /// @returns {Struct.StrewtLocation}
    static get_location = function() {
        return update_location(new StrewtLocation());
    }
    
    /// @ignore
    static update_location = function(_target) {
        static continuation_mask = 0b1100_0000;
        static continuation_pattern = 0b1000_0000;
        
        if (_target.position == position)
            return _target;
        
        var _position = position;
        var _start = _target.position < _position ? _target.position : 0;
        buffer_seek(content_buffer, buffer_seek_start, _start);
        
        var _line = _start > 0  ? _target.line : 1;
        var _column = _start > 0 ? _target.column : 1;
        var _last_cr = false;
        repeat (_position - _start) {
            var _byte = buffer_read(content_buffer, buffer_u8);
            if ((_byte & continuation_mask) == continuation_pattern)
                continue;
            
            if (_byte == 10) {
                _line += 1;
                _column = 0;
            } else if (_last_cr) {
                _line += 1;
                _column = 1;
            }
            _column += 1;
            _last_cr = _byte == 13;
        }
        
        if (_last_cr && buffer_peek(content_buffer, position, buffer_u8) != 10) {
            _line += 1;
            _column = 1;
        }
        
        _target.line = _line;
        _target.column = _column;
        _target.position = position;
        return _target;
    }
    
    // ------
    // Ranges
    // ------
    
    /// @desc Returns the entirety of the processed content text.
    /// @returns {String}
    static peek_all = function() {
        return buffer_peek(content_buffer, 0, buffer_string);
    }
    
    /// @desc Returns the section of the processed content text.
    /// @arg {Real} from                    The start of the cointent section (in bytes).
    /// @arg {Real} to                      The end of the content section (in bytes).
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
    
    /// @desc Copies a given span of the processed content text to a given target buffer.
    /// @arg {Real} from                    The start of the content to copy.
    /// @arg {Real} span                    The length of the content to copy.
    /// @arg {Id.Buffer} target             The target buffer to write the copy into.
    static read_into = function(_from, _span, _target) {
        if (_span <= 0)
            return 0;
        
        buffer_copy(content_buffer, _from, _span, _target, buffer_tell(_target));
        buffer_seek(_target, buffer_seek_relative, _span);
        return _span;
    }
    
    // -----
    // Bytes
    // -----
    
    /// @desc Returns the length of the next byte - 1 if there's a byte remaining or 0 otherwise.
    /// @returns {Real}
    static span_next = function() {
        return position < byte_length ? 1 : 0;
    }
    
    /// @desc Skips the next byte, if any remains. Returns the number of bytes skipped (0 or 1).
    /// @returns {Real}
    static skip_next = function() {
        if (position >= byte_length)
            return 0;
        
        position++;
        buffer_seek(content_buffer, buffer_seek_relative, 1);
        return 1;
    }
    
    /// @desc Returns the next byte value. If the reader is at the end of content, 0 will be returned.
    /// @returns {Real}
    static peek_next = function() {
        return buffer_peek(content_buffer, position, buffer_u8);
    }
    
    /// @desc Skips the next byte (if any) and returns its value. If the reader is at the end of content, 0 will be returned.
    /// @returns {Real}
    static read_next = function() {
        if (position >= byte_length)
            return 0;
        
        position++;
        return buffer_read(content_buffer, buffer_u8);
    }
    
    /// @desc Skips the next byte (if any), writes it to the target buffer and returns its length (1). If the reader is at the end of content, 0 will be returned.
    /// @arg {Id.Buffer} target             The target buffer to write the byte into.
    /// @returns {Real}
    static read_next_into = function(_target) {
        if (position >= byte_length)
            return 0;
        
        position++;
        buffer_write(_target, buffer_u8, buffer_read(content_buffer, buffer_u8));
        return 1;
    }
    
    /// @desc Returns the given byte length (1) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} byte                    The matched byte value.
    /// @returns {Real}
    static span_byte = function(_byte) {
        return buffer_peek(content_buffer, position, buffer_u8) == _byte ? 1 : 0;
    }
    
    /// @desc Skips the given byte and returns its length (1) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} byte                    The matched byte value.
    /// @returns {Real}
    static skip_byte = function(_byte) {
        if (buffer_read(content_buffer, buffer_u8) == _byte) {
            position++;
            return 1;
        } else {
            buffer_seek(content_buffer, buffer_seek_relative, -1);
            return 0;
        }
    }
    
    /// @desc Skips the given byte, writes it to the target buffer and returns its length (1) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} byte                    The matched byte value.
    /// @arg {Id.Buffer} target             The target buffer to write the byte into.
    /// @returns {Real}
    static read_byte_into = function(_byte, _target) {
        if (!skip_byte(_byte))
            return 0;
        
        buffer_write(_target, buffer_u8, _byte);
        return 1;
    }
    
    /// @desc Returns the given byte sequence length if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Array<Real>} bytes            The matched bytes sequence.
    /// @returns {Real}
    static span_byte_sequence = function(_bytes) {
        var _length = array_length(_bytes);
        if (position + _length > byte_length)
            return 0;
        
        for (var i = 0; i < _length; i++) {
            if (buffer_peek(content_buffer, position + i, buffer_u8) != _bytes[i])
                return 0;
        }
        return _length;
    }
    
    /// @desc Skips the given byte sequence and returns its length if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Array<Real>} bytes            The matched bytes sequence.
    /// @returns {Real}
    static skip_byte_sequence = function(_bytes) {
        var _length = array_length(_bytes);
        if (position + _length > byte_length)
            return 0;
        
        for (var i = 0; i < _length; i++) {
            if (buffer_read(content_buffer, buffer_u8) != _bytes[i]) {
                buffer_seek(content_buffer, buffer_seek_start, position);
                return 0;
            }
        }
        position += _length;
        return _length;
    }
    
    /// @desc Skips the given bytes sequence, writes it to the target buffer and returns its length if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Array<Real>} bytes            The matched bytes sequence.
    /// @arg {Id.Buffer} target             The target buffer to write the bytes sequence into.
    /// @returns {Real}
    static read_byte_sequence_into = function(_bytes, _target) {
        var _position = position;
        return read_into(_position, skip_byte_sequence(_bytes), _target);
    }
    
    // ----------
    // Characters
    // ----------
    
    /// @desc Gets the expected UTF-8 character length based on its first byte.
    /// @arg {Real} byte                    The first byte of the given UTF-8 character.
    /// @returns {Real}
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
    
    /// @desc Gets the mask of significant UTF-8 bits for the given byte.
    /// @arg {Real} byte                    The UTF-8 byte to get the bitmask of.
    /// @returns {Real}
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
    
    /// @desc Previews the UTF-8 character at the current reader position, given as a string.
    /// @returns {String}
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
    
    /// @desc Reads past the UTF-8 character at the current reader position and returns its string.
    /// @returns {String}
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
    
    // -----------
    // Multigraphs
    // -----------
    
    /// @desc Returns the given digraph length (2) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} value                   The numeric value of the digraph.
    /// @returns {Real}
    static span_digraph = function(_value) {
        if (position + 2 > byte_length)
            return 0;
        
        return buffer_peek(content_buffer, position, buffer_u16) == _value ? 2 : 0;
    }
    
    /// @desc Skips the given digraph and returns its length (2) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} value                   The numeric value of the digraph.
    /// @returns {Real}
    static skip_digraph = function(_value) {
        if (position + 2 > byte_length)
            return 0;
        
        if (buffer_peek(content_buffer, position, buffer_u16) != _value)
            return 0;
        
        buffer_seek(content_buffer, buffer_seek_relative, 2);
        position += 2;
        return 2;
    }
    
    /// @desc Skips the given digraph, writes it to the target buffer and returns its length (2) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} value                   The numeric value of the digraph.
    /// @arg {Id.Buffer} target             The target buffer to write the digraph into.
    /// @returns {Real}
    static read_digraph_into = function(_value, _target) {
        if (!skip_digraph(_value))
            return 0;
        
        buffer_write(_target, buffer_u16, _value);
        return 2;
    }
    
    /// @desc Returns the given trigraph length (3) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} value                   The numeric value of the trigraph.
    /// @returns {Real}
    static span_trigraph = function(_value) {
        if (position + 3 > byte_length)
            return 0;
        
        return (buffer_peek(content_buffer, position, buffer_u32) & 0x00ffffff) == _value ? 3 : 0;
    }
    
    /// @desc Skips the given trigraph and returns its length (3) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} value                   The numeric value of the trigraph.
    /// @returns {Real}
    static skip_trigraph = function(_value) {
        if (position + 3 > byte_length)
            return 0;
        
        if ((buffer_peek(content_buffer, position, buffer_u32) & 0x00ffffff) != _value)
            return 0;
        
        buffer_seek(content_buffer, buffer_seek_relative, 3);
        position += 3;
        return 3;
    }
    
    /// @desc Skips the given trigraph, writes it to the target buffer and returns its length (3) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} value                   The numeric value of the trigraph.
    /// @arg {Id.Buffer} target             The target buffer to write the trigraph into.
    /// @returns {Real}
    static read_trigraph_into = function(_value, _target) {
        if (!skip_trigraph(_value))
            return 0;
        
        buffer_write(_target, buffer_u32, _value);
        buffer_seek(_target, buffer_seek_relative, -1);
        return 3;
    }
    
    /// @desc Returns the given tetragraph length (4) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} value                   The numeric value of the tetragraph.
    /// @returns {Real}
    static span_tetragraph = function(_value) {
        if (position + 4 > byte_length)
            return 0;
        
        return buffer_peek(content_buffer, position, buffer_u32) == _value ? 4 : 0;
    }
    
    /// @desc Skips the given tetragraph and returns its length (4) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} value                   The numeric value of the tetragraph.
    /// @returns {Real}
    static skip_tetragraph = function(_value) {
        if (position + 4 > byte_length)
            return 0;
        
        if (buffer_peek(content_buffer, position, buffer_u32) != _value)
            return 0;
        
        buffer_seek(content_buffer, buffer_seek_relative, 4);
        position += 4;
        return 4;
    }
    
    /// @desc Skips the given tetragraph, writes it to the target buffer and returns its length (4) if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Real} value                   The numeric value of the tetragraph.
    /// @arg {Id.Buffer} target             The target buffer to write the tetragraph into.
    /// @returns {Real}
    static read_tetragraph_into = function(_value, _target) {
        if (!skip_tetragraph(_value))
            return 0;
        
        buffer_write(_target, buffer_u32, _value);
        return 4;
    }
    
    // -------
    // Strings
    // -------
    
    /// @desc Returns the given string length if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Array<Real>} bytes            The matched string.
    /// @returns {Real}
    static span_string = function(_str) {
        var _length = string_byte_length(_str);
        if (position + _length > byte_length)
            return 0;
        
        return peek_substring(position, position + _length) == _str ? _length : 0;
    }
    
    /// @desc Skips the given string and returns its length if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Array<Real>} bytes            The matched string.
    /// @returns {Real}
    static skip_string = function(_str) {
        var _length = string_byte_length(_str);
        if (position + _length > byte_length)
            return 0;
        
        var _string_found = peek_substring(position, position + _length) == _str;
        if (_string_found) {
            buffer_seek(content_buffer, buffer_seek_relative, _length);
            position += _length;
        }
        return _string_found ? _length : 0;
    }
    
    /// @desc Skips the given string, writes it to the target buffer and returns its length if matched at the current reader position. Returns 0 otherwise.
    /// @arg {Array<Real>} bytes            The matched string.
    /// @arg {Id.Buffer} target             The target buffer to write the string into.
    /// @returns {Real}
    static read_string_into = function(_str, _target) {
        var _position = position;
        return read_into(_position, skip_string(_str), _target);
    }
    
    // -----
    // Lines
    // -----
    
    /// @desc Returns the remaining line length at the current position, with or without the line terminating sequence.
    /// @arg {Bool} [withend]               Whether to include the length of the line terminator.
    /// @returns {Real}
    static span_line = function(_withend = false) {
        var _byte = buffer_read(content_buffer, buffer_u8);
        while (_byte != 10 /* Line feed */ && _byte != 13 /* Carriage return */ && _byte != 0 /* String end */) {
            _byte = buffer_read(content_buffer, buffer_u8);
        }
        var _newpos = buffer_tell(content_buffer);
        if (!_withend || _byte == 0)
            _newpos -= 1;
        else if (_byte == 13 && buffer_read(content_buffer, buffer_u8) == 10 /* CRLF sequence */)
            _newpos += 1;
        
        buffer_seek(content_buffer, buffer_seek_start, position);
        return _newpos - position;
    }
    
    /// @desc Skips to the next line and returns the remaining length of the skipped line. The line terminating sequence may or may not be included, but it's always skipped.
    /// @arg {Bool} [withend]               Whether to include the length of the line terminator.
    /// @returns {Real}
    static skip_line = function(_withend = false) {
        var _byte = buffer_read(content_buffer, buffer_u8);
        while (_byte != 10 /* Line feed */ && _byte != 13 /* Carriage return */ && _byte != 0 /* String end */) {
            _byte = buffer_read(content_buffer, buffer_u8);
        }
        var _newpos = buffer_tell(content_buffer);
        if (_byte == 0) {
            _newpos -= 1;
            buffer_seek(content_buffer, buffer_seek_relative, -1);
            var _result = _newpos - position;
            position = _newpos;
            return _result;
        } else if (_byte != 13) {
            var _result = (_withend ? _newpos : _newpos - 1) - position;
            position = _newpos;
            return _result;
        } else if (buffer_read(content_buffer, buffer_u8) == 10 /* CRLF sequence */) {
            var _result = (_withend ? _newpos + 1 : _newpos - 1) - position;
            position = _newpos + 1;
            return _result;
        } else {
            buffer_seek(content_buffer, buffer_seek_relative, -1);
            var _result = (_withend ? _newpos : _newpos - 1) - position;
            position = _newpos;
            return _result;
        }
    }
    
    /// @desc Returns the remaining line content at the current position, with or without the line terminating sequence.
    /// @arg {Bool} [withend]               Whether to include the line terminator in the result.
    /// @returns {String}
    static peek_line = function(_withend = false) {
        var _span = span_line(_withend);
        return peek_substring(position, position + _span);
    }
    
    /// @desc Skips to the next line and returns the remaining line content at the current position. The line terminating sequence may or may not be included, but it's always skipped.
    /// @arg {Bool} [withend]               Whether to include the line terminator in the result.
    /// @returns {String}
    static read_line = function(_withend = false) {
        var _position = position;
        var _span = skip_line(_withend);
        return peek_substring(_position, _position + _span);
    }
    
    /// @desc Skips to the next line, writes the remaining line content to the target buffer and returns its length. The line terminating sequence may or may not be included in the written output and length, but it's always skipped.
    /// @arg {Id.Buffer} target             The target buffer to write the line content into.
    /// @arg {Bool} [withend]               Whether to include the line terminator in the written output.
    /// @returns {Real}
    static read_line_into = function(_target, _withend = false) {
        var _position = position;
        return read_into(_position, skip_line(_withend), _target);
    }
    
    // --------
    // Charsets
    // --------
    
    // Individual bytes
    
    /// @desc Returns the current byte length (1) if it's in the given charset. Returns 0 otherwise.
    /// @arg {Struct.StrewtCharset} charset     The charset of valid bytes.
    /// @returns {Real}
    static span_charset_byte = function(_charset) {
        var _table = _charset.table;
        var _byte = buffer_peek(content_buffer, position, buffer_u8);
        return _table[_byte] ? 1 : 0;
    }
    
    /// @desc Skips the current byte and returns its length (1) if it's in the given charset. Returns 0 otherwise.
    /// @arg {Struct.StrewtCharset} charset     The charset of valid bytes.
    /// @returns {Real}
    static skip_charset_byte = function(_charset) {
        var _table = _charset.table;
        if (_table[buffer_read(content_buffer, buffer_u8)]) {
            position += 1;
            return 1;
        } else {
            buffer_seek(content_buffer, buffer_seek_relative, -1);
            return 0;
        }
    }
    
    /// @desc Returns the current byte value if it's in the given charset. Returns 0 otherwise.
    /// @arg {Struct.StrewtCharset} charset     The charset of valid bytes.
    /// @returns {Real}
    static peek_charset_byte = function(_charset) {
        var _table = _charset.table;
        var _byte = buffer_peek(content_buffer, position, buffer_u8);
        return _table[_byte] ? _byte : 0;
    }
    
    /// @desc Skips the current byte and returns its value if it's in the given charset. Returns 0 otherwise.
    /// @arg {Struct.StrewtCharset} charset     The charset of valid bytes.
    /// @returns {Real}
    static read_charset_byte = function(_charset) {
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
    
    /// @desc Skips the current byte, writes it to the target buffer and returns its length (1) if it's in the given charset. Returns 0 otherwise.
    /// @arg {Struct.StrewtCharset} charset     The charset of valid bytes.
    /// @arg {Id.Buffer} target                 The target buffer to write the byte into.
    /// @returns {Real}
    static read_charset_byte_into = function(_charset, _target) {
        var _byte = read_charset_byte(_charset);
        if (_byte == 0)
            return 0;
        
        buffer_write(_target, buffer_u8, _byte);
        return 1;
    }
    
    // Charset strings
    
    /// @desc Returns the length of a sequence matching the given charset at the current position (0 or more bytes).
    /// @arg {Struct.StrewtCharset} charset     The charset to match.
    /// @returns {Real}
    static span_charset = function(_charset) {
        var _table = _charset.table;
        var _to = position;
        while (_table[buffer_read(content_buffer, buffer_u8)]) {
            _to += 1;
        }
        buffer_seek(content_buffer, buffer_seek_start, position);
        return _to - position;
    }
    
    /// @desc Skips the sequence matching the given charset at the current position and returns its length (0 or more bytes).
    /// @arg {Struct.StrewtCharset} charset     The charset to match.
    /// @returns {Real}
    static skip_charset = function(_charset) {
        var _table = _charset.table;
        var _from = position;
        while (_table[buffer_read(content_buffer, buffer_u8)]) {
            position += 1;
        }
        buffer_seek(content_buffer, buffer_seek_relative, -1);
        return position - _from;
    }
    
    /// @desc Returns the content of a sequence matching the given charset at the current position.
    /// @arg {Struct.StrewtCharset} charset     The charset to match.
    /// @returns {Real}
    static peek_charset = function(_charset) {
        var _span = span_charset(_charset);
        return peek_substring(position, position + _span);
    }
    
    /// @desc Skips the sequence matching the given charset at the current position and returns its content.
    /// @arg {Struct.StrewtCharset} charset     The charset to match.
    /// @returns {Real}
    static read_charset = function(_charset) {
        var _span = skip_charset(_charset);
        return peek_substring(position - _span, position);
    }
    
    /// @desc Skips the sequence matching the given charset at the current position, writes its content to the target buffer and returns its length (0 or more bytes).
    /// @arg {Struct.StrewtCharset} charset     The charset to match.
    /// @arg {Id.Buffer} target                 The target buffer to write the sequence into.
    /// @returns {Real}
    static read_charset_into = function(_charset, _target) {
        var _position = position;
        return read_into(_position, skip_charset(_charset), _target);
    }
    
    // ----------
    // Chartables
    // ----------
    
    /// @desc Returns the given chartable's value corresponding to the next byte.
    /// @arg {Struct.StrewtChartable} chartable     The chartable to get the value of.
    /// @returns {Any}
    static peek_chartable = function(_chartable) {
        var _byte = buffer_peek(content_buffer, position, buffer_u8);
        return _chartable.table[_byte];
    }
    
    /// @desc Returns the given chartable's value corresponding to the next byte and skips the byte (if any).
    /// @arg {Struct.StrewtChartable} chartable     The chartable to get the value of.
    /// @returns {Any}
    static read_chartable = function(_chartable) {
        if (position >= byte_length)
            return _chartable.table[0];
        
        var _byte = buffer_read(content_buffer, buffer_u8);
        position += 1;
        return _chartable.table[_byte];
    }
    
    // --------
    // Patterns
    // --------
    
    /// @desc Returns the length of a given pattern's match at the current position, if any.
    /// @arg {Struct.StrewtPattern} pattern     The pattern to match.
    /// @returns {Real}
    static span_pattern = function(_pattern) {
        return _pattern.span(self);
    }
    
    /// @desc Skips the given pattern's match at the current position (if any) and returns its length.
    /// @arg {Struct.StrewtPattern} pattern     The pattern to match.
    /// @returns {Real}
    static skip_pattern = function(_pattern) {
        return _pattern.skip(self);
    }
    
    /// @desc Returns the raw content of a given pattern's match at the current position, if any.
    /// @arg {Struct.StrewtPattern} pattern     The pattern to match.
    /// @returns {Real}
    static peek_pattern_raw = function(_pattern) {
        return _pattern.peek_raw(self);
    }
    
    /// @desc Skips the given pattern's match at the current position (if any) and returns its raw content.
    /// @arg {Struct.StrewtPattern} pattern     The pattern to match.
    /// @returns {Real}
    static read_pattern_raw = function(_pattern) {
        return _pattern.read_raw(self);
    }
    
    /// @desc Returns the interpreted content of a given pattern's match at the current position, if any.
    /// @arg {Struct.StrewtPattern} pattern     The pattern to match.
    /// @returns {Real}
    static peek_pattern = function(_pattern) {
        return _pattern.peek(self);
    }
    
    /// @desc Skips the given pattern's match at the current position (if any) and returns its interpreted content.
    /// @arg {Struct.StrewtPattern} pattern     The pattern to match.
    /// @returns {Real}
    static read_pattern = function(_pattern) {
        return _pattern.read(self);
    }
    
    /// @desc Skips the given pattern's match at the current position (if any), writes its interpreted content to the target buffer and returns the written length.
    /// @arg {Struct.StrewtPattern} pattern     The pattern to match.
    /// @arg {Id.Buffer} target                 The target buffer to write the match into.
    /// @returns {Real}
    static read_pattern_into = function(_pattern, _target) {
        return _pattern.read_into(self, _target);
    }
    
    // -------
    // Cleanup
    // -------
    
    /// @desc Cleans up the content buffer when it's no longer needed.
    static cleanup = function() {
        if (!is_undefined(content_buffer) && buffer_exists(content_buffer))
            buffer_delete(content_buffer);
        
        content_buffer = undefined;
    }
}
