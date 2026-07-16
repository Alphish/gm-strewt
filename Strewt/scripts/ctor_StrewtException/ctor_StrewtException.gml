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

/// @desc Creates a Strewt method not implemented exception, thrown from base methods to be implemented in derived type.
/// @arg {Struct} context               The instance whose method was not implemented.
/// @arg {String} method                The name of method that requires implementation in the derived type.
/// @returns {Struct.StrewtException}
StrewtException.not_implemented = function(_context, _method) {
    return new StrewtException(
        nameof(not_implemented),
        $"{instanceof(_context)}.{_method} was not implemented."
        );
}

/// @desc Creates a Strewt invalid type exception, thrown when receiving a value of an invalid type.
/// @arg {String} expected              The description of the expected entity.
/// @arg {Any} actual                   The received entity.
/// @returns {Struct.StrewtException}
StrewtException.invalid_type = function(_expected, _actual) {
    return new StrewtException(
        nameof(invalid_type),
        $"Expected {_expected}, but got {typeof(_actual)} '{_actual}' instead."
        );
}

/// @desc Creates a Strewt reader invalid UTF-8 byte exception, thrown when attempting to read a UTF-8 character when at a byte that cannot begin a character.
/// @arg {Real} byte                    The invalid UTF-8 starting byte.
/// @returns {Struct.StrewtException}
StrewtException.reader_invalid_utf8_byte = function(_byte) {
    return new StrewtException(
        nameof(reader_invalid_utf8_byte),
        $"Attempting to read a UTF-8 character, but {_byte} is not a valid starting byte."
        );
}

/// @desc Creates a Strewt invalid multigraph length exception, thrown when attempting to create a multigraph with a string of invalid byte length.
/// @arg {String} type                  The description of the multigraph.
/// @arg {Real} length                  The expected multigraph length.
/// @arg {String} str                   The string used for creating the multigraph.
/// @returns {Struct.StrewtException}
StrewtException.multigraph_invalid_length = function(_type, _length, _str) {
    return new StrewtException(
        nameof(multigraph_invalid_length),
        $"The string '{_str}' to use as a {_type} should be {_length} bytes long, but is {string_byte_length(_str)} bytes long instead."
        );
}


/// @desc Creates a Strewt invalid chartable range order exception, thrown when attempting to assign a value to a range where the end value is less than the start value.
/// @arg {Real} from                    The description of the multigraph.
/// @arg {Real} to                      The expected multigraph length.
/// @returns {Struct.StrewtException}
StrewtException.chartable_invalid_range_order = function(_from, _to) {
    return new StrewtException(
        nameof(chartable_invalid_range_order),
        $"The range start must be less than the range end, but got a range from {_from} to {_to} instead."
        );
}

/// @desc Creates a Strewt invalid content path exception, thrown when attempting to load content from a non-readable file path.
/// @arg {String} path                  The path the content is being loaded from.
/// @returns {Struct.StrewtException}
StrewtException.invalid_content_path = function(_path) {
    return new StrewtException(
        nameof(invalid_content_path),
        $"Could not read content from the '{_path}' file. The given path must be a string pointing to a readable file."
    );
}
