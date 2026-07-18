/// @desc Creates a new Strewt reader for processing given text or buffer context.
/// @arg {String,Id.Buffer} content         The content to process.
/// @returns {Struct.StrewtReader}
function strewt_reader_create(_content) {
    return new StrewtReader(_content);
}

/// @desc Frees up resources held by the given Strewt reader. The reader won't be usable afterwards.
/// @arg {Struct.StrewtReader} reader       The reader to free the resources of.
function strewt_reader_destroy(_reader) {
    _reader.cleanup();
}

/// @desc Creates a new Strewt chartable matching bytes to their corresponding values.
/// @arg {Any,Array} [input]                The default value or the array of chartable values.
/// @arg {Any} [blank]                      The value corresponding to the zero byte.
/// @returns {Struct.StrewtChartable}
function strewt_chartable_create(_input = undefined, _blank = undefined) {
    return new StrewtChartable(_input, _blank);
}

/// @desc Creates a new Strewt charset indicating which bytes are included, and which aren't.
/// @arg {Bool,Array<Bool>} [input]         The default byte inclusion/exclusion or the array of inclusions/exclusions.
/// @returns {Struct.StrewtCharset}
function strewt_charset_create(_input = false) {
    return new StrewtCharset(_input);
}

/// @desc Creates a new Strewt charset including or excluding characters from the given string.
/// @arg {String} chars                     The string of characters to include/exclude.
/// @arg {Bool} [including]                 Whether the charset should only include given characters (true), or include all but the given characters (false).
/// @returns {Struct.StrewtCharset}
function strewt_charset_from_string(_chars, _including = true) {
    if (!is_string(_chars))
        throw StrewtException.invalid_type("a string", _chars);
    
    return new StrewtCharset(!_including).with_value(_chars, _including);
}
