/// @desc A base for a parser processing a specific text.
function StrewtParser() constructor {
    // Parsing setup
    
    /// @desc The path of the content to read.
    /// @returns {String}
    content_path = undefined;
    
    /// @desc The content string or buffer to read.
    /// @returns {String,Id.Buffer}
    content = undefined;
    
    /// @desc The underlying reader processing the content.
    /// @returns {Struct.StrewtReader}
    reader = undefined;
    
    /// @desc The name of the reader content source.
    /// @returns {String}
    reader_source_name = undefined;
    
    /// @desc Whether to clean up the reader and its content after completing parsing or not.
    /// @returns {Bool}
    auto_cleanup = true;
    
    // Task state
    
    /// @desc Indicates the parsing status; 0 when in progress, positive when completed, negative when failed.
    /// @returns {Real}
    status = 0;
    
    /// @desc The parsing result.
    /// @returns {Any}
    result = undefined;
    
    /// @desc The parsing error description.
    /// @returns {String}
    error = undefined;
    
    /// @desc The location at which the parsing error occurred.
    /// @returns {Struct.StrewtLocation}
    error_location = undefined;
    
    // -----
    // Setup
    // -----
    
    /// @desc Configures the parser to parse the given content.
    /// @arg {String,Id.Buffer} content     The content to process.
    /// @returns {Struct.StrewtParser}
    static for_content = function(_content) {
        content = _content;
        return self;
    }
    
    /// @desc Configures the parser to retrieve parsed content from the given file.
    /// @arg {String} path                  The path to the content file.
    /// @arg {Bool} [assource]              Whether to use the filename as reader content source description or not.
    /// @returns {Struct.StrewtParser}
    static for_file = function(_path, _assource = true) {
        content_path = _path;
        if (_assource)
            reader_source_name ??= filename_name(content_path);
        
        return self;
    }
    
    /// @desc Configures the parser with the given parsed content source description.
    /// @arg {String} name                  The name used to describe parsed content source.
    /// @returns {Struct.StrewtParser}
    static with_source_name = function(_name) {
        reader_source_name = _name;
        return self;
    }
    
    /// @desc Configures the parser to disable automatic cleanup after completion.
    /// @returns {Struct.StrewtParser}
    static with_manual_cleanup = function() {
        auto_cleanup = false;
        return self;
    }
    
    // ----------
    // Processing
    // ----------
    
    /// @desc Prepares the content to parse and the reader.
    static init = function() {
        if (is_undefined(content)) {
            if (!is_string(content_path))
                throw StrewtException.invalid_content_path(content_path);
            
            content = buffer_load(content_path);
            if (!buffer_exists(content))
                throw StrewtException.invalid_content_path(content_path);
        }
        reader = new StrewtReader(content).with_source_name(reader_source_name);
    }
    
    /// @desc Performs the next parsing step.
    /// @returns {Bool}
    static process_step = function() {
        throw StrewtException.not_implemented(self, nameof(process_step));
    }
    
    /// @desc Resolves the parsing result upon completion.
    /// @returns {Any}
    static resolve_result = function() {
        throw StrewtException.not_implemented(self, nameof(resolve_result));
    }
    
    /// @desc Retrieves the current parsing progress.
    /// @returns {Any}
    static get_progress = function() {
        return $"{reader.position}/{reader.byte_length}";
    }
    
    /// @desc Immediately parses the remaining content and returns the result, if any.
    /// @returns {Any}
    static parse_all = function() {
        if (status != 0)
            return result;
        
        if (is_undefined(reader))
            init();
        
        while (!process_step()) {}
        cleanup(/* auto */ true);
        
        return result;
    }
    
    // ---------
    // Finishing
    // ---------
    
    /// @desc Attempts to finish parsing and produce the result. The attempt will fail if the reader hasn't reached the end yet.
    static try_complete = function() {
        if (!is_undefined(error))
            return undefined;
        
        if (!reader.is_end_of_content())
            return fail("Attempting to complete parsing before the whole text was processed.");
        
        result = resolve_result();
        
        // performing an additional check, in case a failure happened when resolving the result
        if (is_undefined(error))
            status = 1;
        
        return undefined;
    }
    
    /// @desc Reports the parsing failure with the given error message. The error position may be specified if it differs from the current reader position.
    /// @arg {String} error                 The error message explaining the problem.
    /// @arg {Real} [position]              The position where the error cause can be found.
    static fail = function(_error, _position = undefined) {
        if (!is_undefined(_position))
            reader.move_to(_position);
        
        status = -1;
        var _in_source = !is_undefined(reader.source_name) ? $" in {reader.source_name}" : "";
        error_location = reader.get_location();
        error = $"Error{_in_source} at {error_location.get_line_column()}: {_error}";
        return undefined;
    }
    
    /// @desc Indicates whether the parsing has finished or not.
    /// @returns {Bool}
    static is_finished = function() {
        return status != 0;
    }
    
    // -------
    // Cleanup
    // -------
    
    /// @desc Attempts to clean up the parser resources.
    /// @arg {Bool} [auto]                  Indicates whether cleanup was requested from a broader, standard process.
    static cleanup = function(_auto = false) {
        if (_auto && !auto_cleanup)
            return;
        
        if (is_undefined(reader))
            return;
        
        reader.cleanup();
        reader = undefined;
    }
}
