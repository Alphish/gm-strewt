/// @desc Creates a new Strewt writer for writing content. A target buffer may be optionally given.
/// @arg {Id.Buffer} [target]               The target buffer to write to.
/// @returns {Struct.StrewtWriter}
function strewt_writer_create(_target = undefined) {
    return new StrewtWriter(_target);
}

/// @desc Frees up resources held by the given Strewt writer. The writer won't be usable afterwards.
/// @arg {Struct.StrewtWriter} writer       The writer to free the resources of.
function strewt_writer_destroy(_writer) {
    _writer.cleanup();
}
