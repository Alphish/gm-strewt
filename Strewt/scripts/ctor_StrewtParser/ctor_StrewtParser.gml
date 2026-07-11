/// @desc A base of a parser processing a specific text.
function StrewtParser() constructor {
    content_filename = undefined;
    content = undefined;
    reader = undefined;
    reader_source_name = undefined;
    auto_cleanup = true;
    
    status = 0;
    result = undefined;
    error = undefined;
    error_location = undefined;
    
    // -----
    // Setup
    // -----
    
    static for_file = function(_filename, _assource = true) {
        content_filename = _filename;
        if (_assource)
            reader_source_name ??= filename_name(content_filename);
        
        return self;
    }
    
    static for_content = function(_content) {
        content = _content;
        return self;
    }
    
    static with_source_name = function(_name) {
        reader_source_name = _name;
        return self;
    }
    
    static with_manual_cleanup = function() {
        auto_cleanup = false;
        return self;
    }
    
    // ----------
    // Processing
    // ----------
    
    static init = function() {
        if (is_undefined(content)) {
            if (!is_string(content_filename))
                throw StrewtException.parser_invalid_filename(content_filename);
            
            content = buffer_load(content_filename);
            if (!buffer_exists(content))
                throw StrewtException.parser_invalid_filename(content_filename);
        }
        reader = new StrewtReader(content).with_source_name(reader_source_name);
    }
    
    static process_step = function() {
        throw StrewtException.not_implemented(self, nameof(process_step));
    }
    
    static resolve_result = function() {
        throw StrewtException.not_implemented(self, nameof(resolve_result));
    }
    
    static get_progress = function() {
        return $"{reader.position}/{reader.byte_length}";
    }
    
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
    
    static fail = function(_error, _position = undefined) {
        if (!is_undefined(_position))
            reader.move_to(_position);
        
        status = -1;
        var _in_source = !is_undefined(reader.source_name) ? $" in {reader.source_name}" : "";
        error_location = reader.get_location();
        error = $"Error{_in_source} at {error_location.get_line_column()}: {_error}";
        return undefined;
    }
    
    static is_finished = function() {
        return status != 0;
    }
    
    static cleanup = function(_auto = false) {
        if (_auto && !auto_cleanup)
            return;
        
        if (is_undefined(reader))
            return;
        
        reader.cleanup();
        reader = undefined;
    }
}
