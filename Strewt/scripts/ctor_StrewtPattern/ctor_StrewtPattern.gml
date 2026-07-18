/// @desc A base for a pattern matching the text content.
function StrewtPattern() constructor {
    /// @desc Returns the length of the match at the given reader's position, if any.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @returns {Real}
    static span = function(_reader) {
        var _length = skip(_reader);
        _reader.move_by(-_length);
        return _length;
    }
    
    /// @desc Skips the match at the given reader's position (if any) and returns its length.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @returns {Real}
    static skip = function(_reader) {
        throw StrewtException.not_implemented(self, nameof(skip));
    }
    
    /// @desc Returns the raw content of the match at the given reader's position, if any.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @returns {Real}
    static peek_raw = function(_reader) {
        var _length = skip(_reader);
        _reader.move_by(-_length);
        return _reader.peek_substring(_reader.position, _reader.position + _length);
    }
    
    /// @desc Skips the match at the given reader's position (if any) and returns its raw content.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @returns {Real}
    static read_raw = function(_reader) {
        var _length = skip(_reader);
        return _reader.peek_substring(_reader.position - _length, _reader.position);
    }
    
    /// @desc Returns the interpreted content of the match at the given reader's position, if any.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @returns {Real}
    static peek = function(_reader) {
        var _position = _reader.position;
        var _target = buffer_create(64, buffer_grow, 1);
        read_into(_reader, _target);
        buffer_write(_target, buffer_u8, 0);
        _reader.move_to(_position);
        var _result = buffer_peek(_target, 0, buffer_string);
        buffer_delete(_target);
        return _result;
    }
    
    /// @desc Skips the match at the given reader's position (if any) and returns its interpreted content.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @returns {Real}
    static read = function(_reader) {
        var _target = buffer_create(64, buffer_grow, 1);
        read_into(_reader, _target);
        buffer_write(_target, buffer_u8, 0);
        var _result = buffer_peek(_target, 0, buffer_string);
        buffer_delete(_target);
        return _result;
    }
    
    /// @desc Skips the match at the given reader's position (if any), writes its interpreted content to the target buffer and returns the read length.
    /// @arg {Struct.StrewtReader} reader       The reader to match against.
    /// @arg {Id.Buffer} target                 The target to write the match into.
    /// @returns {Real}
    static read_into = function(_reader, _target) {
        var _length = skip(_reader);
        var _target_from = buffer_tell(_target);
        buffer_copy(_reader.content_buffer, _reader.position - _length, _length, _target, _target_from);
        buffer_seek(_target, buffer_seek_relative, _length);
        return _length;
    }
    
    /// @desc Restores the reader's and the writing target's (if any) original positions. Typically used upon finding a mismatch.
    /// @arg {Struct.StrewtReader} reader       The reader to restore the position of.
    /// @arg {Real} readerfrom                  The reader's original position.
    /// @arg {Id.Buffer} [target]               The target to restore the position of (if any).
    /// @arg {Real} [targetfrom]                The target's original position (if any).
    static restore_positions = function(_reader, _readerfrom, _target = undefined, _targetfrom = undefined) {
        _reader.move_to(_readerfrom);
        if (!is_undefined(_target)) {
            buffer_poke(_target, _targetfrom, buffer_u8, 0);
            buffer_seek(_target, buffer_seek_start, _targetfrom);
        }
        return 0;
    }
}
