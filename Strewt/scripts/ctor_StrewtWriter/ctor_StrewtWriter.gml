function StrewtWriter(_target = undefined) constructor {
    if (!is_undefined(_target) && !buffer_exists(_target))
        throw StrewtException.writer_invalid_target(_target);
    
    content_buffer = _target ?? buffer_create(1024, buffer_grow, 1);
    newline_sequence = "\n";
    indent_default_unit = "    ";
    indent_blank_lines = false;
    
    begins_line = check_begins_line();
    indent = "";
    indent_segments = [];
    
    // -----
    // Setup
    // -----
    
    static with_newline_sequence = function(_sequence) {
        newline_sequence = _sequence;
        return self;
    }
    
    static with_default_indent_unit = function(_unit) {
        indent_default_unit = _unit;
        return self;
    }
    
    static indenting_blank_lines = function() {
        indent_blank_lines = true;
        return self;
    }
    
    // ----------
    // Navigation
    // ----------
    
    static get_length = function() {
        return buffer_tell(content_buffer);
    }
    
    static get_position = function() {
        return buffer_tell(content_buffer);
    }
    
    static move_to = function(_position) {
        buffer_seek(content_buffer, buffer_seek_start, _position);
        begins_line = check_begins_line();
    }
    
    static move_by = function(_offset) {
        buffer_seek(content_buffer, buffer_seek_relative, _offset);
        begins_line = check_begins_line();
    }
    
    // -------
    // Writing
    // -------
    
    static write = function(_value) {
        var _text = string(_value);
        if (_text == "")
            return;
        
        try_apply_indents();
        var _result = buffer_write(content_buffer, buffer_text, _text);
        begins_line = check_begins_line();
        return _result;
    }
    
    static write_line = function(_value = "") {
        write(_value);
        if (indent_blank_lines)
            try_apply_indents();
        
        var _result = buffer_write(content_buffer, buffer_text, newline_sequence);
        begins_line = true;
        return _result;
    }
    
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
    
    static write_direct = function(_datatype, _value) {
        var _result = buffer_write(content_buffer, _datatype, _value);
        begins_line = check_begins_line();
        return _result;
    }
    
    // -----------------
    // Indent management
    // -----------------
    
    static check_begins_line = function() {
        var _position = buffer_tell(content_buffer);
        if (_position == 0)
            return true;
        
        var _last_byte = buffer_peek(content_buffer, _position - 1, buffer_u8);
        return _last_byte == 10 || _last_byte == 13; // is LF or CR
    }
    
    static try_apply_indents = function() {
        if (!begins_line || indent == "")
            return;
        
        buffer_write(content_buffer, buffer_text, indent);
        begins_line = false;
    }
    
    static push_indent = function(_segment = undefined) {
        _segment ??= indent_default_unit;
        indent += _segment;
        array_push(indent_segments, _segment);
    }
    
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
    
    static get_content_bytes = function(_bufftype = buffer_fixed) {
        var _length = buffer_tell(content_buffer);
        var _result = buffer_create(_length, _bufftype, 1);
        buffer_copy(content_buffer, 0, _length, _result, 0);
        return _result;
    }
    
    // -------
    // Cleanup
    // -------
    
    static cleanup = function() {
        if (!is_undefined(content_buffer) && buffer_exists(content_buffer))
            buffer_delete(content_buffer);
        
        content_buffer = undefined;
    }
}
