function StringQuoteDoublingPattern() : StrewtPattern() constructor {
    static quote_byte = ord("\"");
    static nonquote_charset = new StrewtCharset(true).excluding("\"");
    
    static skip = function(_reader) {
        var _position = _reader.position;
        while (_reader.try_skip_byte(quote_byte)) {
            _reader.skip_charset_string(nonquote_charset);
            if (!_reader.try_skip_byte(quote_byte)) {
                _reader.move_to(_position);
                return 0;
            }
        }
        return _reader.position - _position;
    }
    
    static read_into = function(_reader, _target) {
        var _position = _reader.position;
        var _target_from = buffer_tell(_target);
        var _target_to = _target_from;
        
        while (_reader.try_skip_byte(quote_byte)) {
            var _count = _reader.skip_charset_string(nonquote_charset);
            buffer_copy(_reader.content_buffer, _reader.position - _count, _count, _target, _target_to);
            _target_to += _count;
            
            if (!_reader.try_skip_byte(quote_byte)) {
                _reader.move_to(_position);
                buffer_poke(_target, _target_from, buffer_u8, 0);
                buffer_seek(_target, buffer_seek_start, _target_from);
                return 0;
            }
            
            // using seek + write rather than poke
            // so that the buffer expands if needed
            buffer_seek(_target, buffer_seek_start, _target_to);
            buffer_write(_target, buffer_u8, quote_byte);
            _target_to += 1;
        }
        
        // not even one quote has been read
        if (_target_to == _target_from) {
            buffer_poke(_target, _target_from, buffer_u8, 0);
            return 0;
        }
        
        _target_to -= 1;
        buffer_poke(_target, _target_to, buffer_u8, 0);
        buffer_seek(_target, buffer_seek_start, _target_to);
        
        return _target_to - _target_from;
    }
}
