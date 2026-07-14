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
