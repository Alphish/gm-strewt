/// @desc An exception to be thrown due to invalid Strewt usage.
/// @arg {String} code              The code of the exception to differentiate between different exception causes.
/// @arg {String} description       A detailed description explaining the exception.
function StrewtException(_code, _description) constructor {
    /// @desc The code of the exception to differentiate between different exception causes.
    /// @type {String}
    code = _code;
    
    /// @desc A detailed description explaining the exception.
    /// @type {String}
    description = _description;
    
    toString = function() {
        return $"Strewt.{code}: {description}";
    }
}

StrewtException.reader_invalid_content = function(_content) {
    return new StrewtException(
        nameof(reader_invalid_content),
        $"Expected a buffer or a string, but got {typeof(_content)} '{_content}' instead."
        );
}

StrewtException.reader_invalid_utf8_byte = function(_byte) {
    return new StrewtException(
        nameof(reader_invalid_utf8_byte),
        $"Attempting to read a UTF-8 character, but {_byte} is not a valid starting byte."
        );
}

StrewtException.charset_invalid_input = function(_input) {
    return new StrewtException(
        nameof(charset_invalid_input),
        $"Expected an array or a bool, but got {typeof(_input)} '{_input}' instead."
        );
}

StrewtException.charset_invalid_target = function(_target) {
    return new StrewtException(
        nameof(charset_invalid_target),
        $"Expected a string or a number in range 0-255, but got {typeof(_target)} '{_target}' instead."
        );
}

StrewtException.charset_invalid_range_end = function(_end) {
    return new StrewtException(
        nameof(charset_invalid_range_end),
        $"Expected a single-byte string or a number in range 0-255, but got {typeof(_end)} '{_end}' instead."
        );
}

StrewtException.charset_invalid_range_order = function(_from, _to) {
    return new StrewtException(
        nameof(charset_invalid_range_order),
        $"The range start must be less than the range end, but got a range from {_from} to {_to} instead."
        );
}
