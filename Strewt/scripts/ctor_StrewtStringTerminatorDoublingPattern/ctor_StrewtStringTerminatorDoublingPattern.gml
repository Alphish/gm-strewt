function StrewtStringTerminatorDoublingPattern(_terminator = "\"") : StrewtPattern() constructor {
    terminator_byte = ord(_terminator);
    nonterminator_charset = new StrewtCharset(true).excluding(_terminator);
    
    static skip = function(_reader) {
        var _position = _reader.position;
        while (_reader.skip_byte(terminator_byte)) {
            _reader.skip_charset(nonterminator_charset);
            if (!_reader.skip_byte(terminator_byte))
                return restore_positions(_reader, _position);
        }
        return _reader.position - _position;
    }
    
    static read_into = function(_reader, _target) {
        var _position = _reader.position;
        var _target_from = buffer_tell(_target);
        
        if (!_reader.skip_byte(terminator_byte))
            return 0;
        
        _reader.read_charset_into(nonterminator_charset, _target);
        if (!_reader.skip_byte(terminator_byte))
            return restore_positions(_reader, _position, _target, _target_from);
        
        while (_reader.read_byte_into(terminator_byte, _target)) {
            _reader.read_charset_into(nonterminator_charset, _target);
            if (!_reader.skip_byte(terminator_byte))
                return restore_positions(_reader, _position, _target, _target_from);
        }
        
        return buffer_tell(_target) - _target_from;
    }
}
