/// @desc A buffer-backed text writer. It may use a given target buffer or its own newly created buffer.
/// @arg {Id.Buffer} [target]               The target buffer to write to.
function StrewtWriter(_target = undefined) constructor {
    if (!is_undefined(_target) && !buffer_exists(_target))
        throw StrewtException.writer_invalid_target(_target);
    
    /// @desc The buffer with the written content.
    /// @returns {Id.Buffer}
    content_buffer = _target ?? buffer_create(1024, buffer_grow, 1);
    
    /// @desc The newline sequence added at the end of each line.
    /// @returns {String}
    newline_sequence = "\n";
    
    /// @desc The indentation unit pushed by default.
    /// @returns {String}
    indent_default_unit = "    ";
    
    /// @desc Indicates whether indentation should be added to blank lines or not.
    /// @returns {Bool}
    indent_blank_lines = false;
    
    /// @ignore
    begins_line = check_begins_line();
    
    /// @desc The current indent.
    /// @returns {String}
    indent = "";
    
    /// @ignore
    indent_segments = [];
    
    // -----
    // Setup
    // -----
    
    /// @desc Configures the writer with the newline sequence to add at the end of lines.
    /// @arg {String} sequence              The newline sequence to add.
    /// @returns {Struct.StrewtWriter}
    static with_newline_sequence = function(_sequence) {
        newline_sequence = _sequence;
        return self;
    }
    
    /// @desc Configures the writer with the default indentation unit.
    /// @arg {String} unit                  The new default indentation unit.
    /// @returns {Struct.StrewtWriter}
    static with_default_indent_unit = function(_unit) {
        indent_default_unit = _unit;
        return self;
    }
    
    /// @desc Configures the writer to add indentation to blank lines.
    /// @returns {Struct.StrewtWriter}
    static indenting_blank_lines = function() {
        indent_blank_lines = true;
        return self;
    }
    
    // ----------
    // Navigation
    // ----------
    
    /// @desc Returns the length of the content written so far. It's identical to the underlying buffer position.
    /// @returns {Real}
    static get_length = function() {
        return buffer_tell(content_buffer);
    }
    
    /// @desc Returns the position of the content written so far. It's identical to the underlying buffer position.
    /// @returns {Real}
    static get_position = function() {
        return buffer_tell(content_buffer);
    }
    
    /// @desc Moves the writer to the given position.
    /// @arg {Real} position                The position to move the writer to.
    static move_to = function(_position) {
        buffer_seek(content_buffer, buffer_seek_start, _position);
        begins_line = check_begins_line();
    }
    
    /// @desc Moves the writer by the given offset.
    /// @arg {Real} offset                  The offset to move the writer by.
    static move_by = function(_offset) {
        buffer_seek(content_buffer, buffer_seek_relative, _offset);
        begins_line = check_begins_line();
    }
    
    // -------
    // Writing
    // -------
    
    /// @desc Writes a given text or value to the content.
    /// @arg {Any} value                    The value to be written.
    static write = function(_value) {
        var _text = string(_value);
        if (_text == "")
            return;
        
        try_write_indent();
        var _result = buffer_write(content_buffer, buffer_text, _text);
        begins_line = check_begins_line();
        return _result;
    }
    
    /// @desc Writes a given text or value (if any) to the content and begins a new line.
    /// @arg {Any} [value]                  The value to be written before beginning the next line.
    static write_line = function(_value = "") {
        write(_value);
        if (indent_blank_lines)
            try_write_indent();
        
        var _result = buffer_write(content_buffer, buffer_text, newline_sequence);
        begins_line = true;
        return _result;
    }
    
    /// @desc Writes a given multiline text or array of values to the content. Indentation is applied separately to each line.
    /// @arg {String,Array} value           The multiline text or the array of values to be written.
    /// @arg {Bool} [lastline]              Whether to begin the new line after the last line or not.
    static write_multiline = function(_value, _lastline = true) {
        static newline_separators = ["\r\n", "\r", "\n"];
        
        if (!is_array(_value)) {
            var _valuetext = string(_value);
            _value = _valuetext != "" ? string_split_ext(_valuetext, newline_separators) : [];
        }
        
        var _result = 0;
        for (var i = 0, _count = array_length(_value); i < _count; i++) {
            if (i < _count - 1 || _lastline)
                _result = write_line(_value[i]);
            else
                _result = write(_value[i]);
        }
        return _result;
    }
    
    /// @desc Writes a given value of a given buffer datatype directly to the content. Indentation is ignored.
    /// @arg {Constant.BufferDataType} datatype     The buffer datatype to write.
    /// @arg {Any} value                            The value to write into the content.
    static write_direct = function(_datatype, _value) {
        var _result = buffer_write(content_buffer, _datatype, _value);
        begins_line = check_begins_line();
        return _result;
    }
    
    // -----------------
    // Indent management
    // -----------------
    
    /// @ignore
    static check_begins_line = function() {
        var _position = buffer_tell(content_buffer);
        if (_position == 0)
            return true;
        
        var _last_byte = buffer_peek(content_buffer, _position - 1, buffer_u8);
        return _last_byte == 10 || _last_byte == 13; // is LF or CR
    }
    
    /// @desc Attempts to write the current indent if the content is at the start of a line, otherwise writes nothing.
    static try_write_indent = function() {
        if (!begins_line || indent == "")
            return;
        
        buffer_write(content_buffer, buffer_text, indent);
        begins_line = false;
    }
    
    /// @desc Adds a segment to the overall indentation. If no segment text is specified, the default indentation unit is used.
    /// @arg {String} [segment]             The segment to add to the indentation.
    static push_indent = function(_segment = undefined) {
        _segment ??= indent_default_unit;
        indent += _segment;
        array_push(indent_segments, _segment);
    }
    
    /// @desc Removes the last segment from the indentation, if any.
    static pop_indent = function() {
        var _segment = array_pop(indent_segments);
        if (is_undefined(_segment))
            return;
        
        var _length = string_length(_segment);
        if (_length == 0)
            return;
        
        indent = string_delete(indent, string_length(indent) + 1 - _length, _length);
    }
    
    // ---------
    // Retrieval
    // ---------
    
    /// @desc Retrieves the written content as a string, up to the current content position.
    /// @returns {String}
    static get_content = function() {
        var _length = buffer_tell(content_buffer);
        if (_length == buffer_get_size(content_buffer))
            return buffer_peek(content_buffer, 0, buffer_string);
        
        var _value_ahead = buffer_peek(content_buffer, _length, buffer_u8);
        if (_value_ahead == 0)
            return buffer_peek(content_buffer, 0, buffer_string);
        
        buffer_poke(content_buffer, _length, buffer_u8, 0);
        var _result = buffer_peek(content_buffer, 0, buffer_string);
        buffer_poke(content_buffer, _length, buffer_u8, _value_ahead);
        return _result;
    }
    
    /// @desc Creates a new buffer with the content bytes, up to the current content position.
    /// @arg {Constant.BufferType} [bufftype]       The type of the newly created buffer.
    /// @returns {Id.Buffer}
    static get_content_bytes = function(_bufftype = buffer_fixed) {
        var _length = buffer_tell(content_buffer);
        var _result = buffer_create(_length, _bufftype, 1);
        buffer_copy(content_buffer, 0, _length, _result, 0);
        return _result;
    }
    
    // -------
    // Cleanup
    // -------
    
    /// @desc Ensures the underlying content buffer has its memory released. The writer can no longer be used after the cleanup.
    static cleanup = function() {
        if (!is_undefined(content_buffer) && buffer_exists(content_buffer))
            buffer_delete(content_buffer);
        
        content_buffer = undefined;
    }
}
