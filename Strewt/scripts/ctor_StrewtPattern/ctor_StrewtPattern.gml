function StrewtPattern() constructor {
    static span = function(_reader) {
        var _length = skip(_reader);
        _reader.move_by(-_length);
        return _length;
    }
    
    static skip = function(_reader) {
        throw StrewtException.not_implemented(self, nameof(skip));
    }
    
    static peek_raw = function(_reader) {
        var _length = skip(_reader);
        _reader.move_by(-_length);
        return _reader.peek_substring(_reader.position, _reader.position + _length);
    }
    
    static read_raw = function(_reader) {
        var _length = skip(_reader);
        return _reader.peek_substring(_reader.position - _length, _reader.position);
    }
    
    static peek = function(_reader) {
        var _position = _reader.position;
        var _target = buffer_create(64, buffer_grow, 1);
        var _length = read_into(_reader, _target);
        _reader.move_to(_position);
        var _result = buffer_peek(_target, 0, buffer_string);
        buffer_delete(_target);
        return _result;
    }
    
    static read = function(_reader) {
        var _target = buffer_create(64, buffer_grow, 1);
        read_into(_reader, _target);
        var _result = buffer_peek(_target, 0, buffer_string);
        buffer_delete(_target);
        return _result;
    }
    
    static peek_into = function(_reader, _target) {
        var _position = _reader.position;
        var _length = read_into(_reader, _target);
        _reader.move_to(_position);
        return _length;
    }
    
    static read_into = function(_reader, _target) {
        var _length = skip(_reader);
        var _target_from = buffer_tell(_target);
        buffer_copy(_reader.content_buffer, _reader.position - _length, _length, _target, _target_from);
        buffer_poke(_target, _target_from + _length, buffer_u8, 0);
        buffer_seek(_target, buffer_seek_relative, _length);
        return _length;
    }
}
