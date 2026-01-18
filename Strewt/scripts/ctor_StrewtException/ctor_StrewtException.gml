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

StrewtException.invalid_content = function(_content) {
    return new StrewtException(
        nameof(invalid_content),
        $"Expected a buffer or a string, but got {typeof(_content)} '{_content}' instead."
        );
}
