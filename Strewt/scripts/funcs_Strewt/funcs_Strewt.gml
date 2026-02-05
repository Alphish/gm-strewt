function strewt_digraph(_str) {
    if (!is_string(_str))
        throw StrewtException.multigraph_invalid_type("digraph", _str);
    
    var _length = string_byte_length(_str);
    if (_length != 2)
        throw StrewtException.multigraph_invalid_length("digraph", 2, _str);
    
    var _buffer = buffer_create(2, buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _str);
    var _result = buffer_peek(_buffer, 0, buffer_u16);
    buffer_delete(_buffer);
    return _result;
}

function strewt_trigraph(_str) {
    if (!is_string(_str))
        throw StrewtException.multigraph_invalid_type("trigraph", _str);
    
    var _length = string_byte_length(_str);
    if (_length != 3)
        throw StrewtException.multigraph_invalid_length("trigraph", 3, _str);
    
    var _buffer = buffer_create(4, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, _str);
    var _result = buffer_peek(_buffer, 0, buffer_u32);
    buffer_delete(_buffer);
    return _result;
}

function strewt_tetragraph(_str) {
    if (!is_string(_str))
        throw StrewtException.multigraph_invalid_type("tetragraph", _str);
    
    var _length = string_byte_length(_str);
    if (_length != 4)
        throw StrewtException.multigraph_invalid_length("tetragraph", 4, _str);
    
    var _buffer = buffer_create(4, buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _str);
    var _result = buffer_peek(_buffer, 0, buffer_u32);
    buffer_delete(_buffer);
    return _result;
}
