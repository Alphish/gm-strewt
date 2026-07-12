/// @desc Converts the given character to its numeric representation. A numeric input is returned as-is.
/// @arg {String,Real} input            The character/number to get the numeric representation of.
/// @returns {Real}
function strewt_byte(_input) {
    if (is_numeric(_input))
        return _input;
    
    if (!is_string(_input))
        throw StrewtException.multigraph_invalid_type("byte", _input);
    
    var _length = string_byte_length(_input);
    if (_length != 1)
        throw StrewtException.multigraph_invalid_length("byte", 1, _input);
    
    return string_byte_at(_input, 1);
}

/// @desc Converts the given digraph (2-byte string) to its numeric representation. A numeric input is returned as-is.
/// @arg {String,Real} input            The digraph/number to get the numeric representation of.
/// @returns {Real}
function strewt_digraph(_input) {
    if (is_numeric(_input))
        return _input;
    
    if (!is_string(_input))
        throw StrewtException.multigraph_invalid_type("digraph", _input);
    
    var _length = string_byte_length(_input);
    if (_length != 2)
        throw StrewtException.multigraph_invalid_length("digraph", 2, _input);
    
    var _buffer = buffer_create(2, buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _input);
    var _result = buffer_peek(_buffer, 0, buffer_u16);
    buffer_delete(_buffer);
    return _result;
}

/// @desc Converts the given trigraph (3-byte string) to its numeric representation. A numeric input is returned as-is.
/// @arg {String,Real} input            The trigraph/number to get the numeric representation of.
/// @returns {Real}
function strewt_trigraph(_input) {
    if (is_numeric(_input))
        return _input;
    
    if (!is_string(_input))
        throw StrewtException.multigraph_invalid_type("trigraph", _input);
    
    var _length = string_byte_length(_input);
    if (_length != 3)
        throw StrewtException.multigraph_invalid_length("trigraph", 3, _input);
    
    var _buffer = buffer_create(4, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, _input);
    var _result = buffer_peek(_buffer, 0, buffer_u32);
    buffer_delete(_buffer);
    return _result;
}

/// @desc Converts the given tetragraph (4-byte string) to its numeric representation. A numeric input is returned as-is.
/// @arg {String,Real} input            The tetragraph/number to get the numeric representation of.
/// @returns {Real}
function strewt_tetragraph(_input) {
    if (is_numeric(_input))
        return _input;
    
    if (!is_string(_input))
        throw StrewtException.multigraph_invalid_type("tetragraph", _input);
    
    var _length = string_byte_length(_input);
    if (_length != 4)
        throw StrewtException.multigraph_invalid_length("tetragraph", 4, _input);
    
    var _buffer = buffer_create(4, buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _input);
    var _result = buffer_peek(_buffer, 0, buffer_u32);
    buffer_delete(_buffer);
    return _result;
}
