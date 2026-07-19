/// @desc A base for a formatter writing a specific input.
/// @arg {Any} input                        The input to format.
function StrewtFormatter(_input) constructor {
    // Formatting setup
    
    /// @desc The input to format.
    /// @returns {Any}
    input = _input;
    
    /// @desc The writer used for writing the formatted text.
    /// @returns {Struct.StrewtWriter}
    writer = undefined;
    
    /// @desc The newline sequence to configure the writer with.
    /// @returns {String}
    writer_newline_sequence = undefined;
    
    /// @desc The default indent unit to configure the writer with.
    /// @returns {String}
    writer_default_indent = undefined;
    
    /// @desc The blank lines indentation status to configure the writer with.
    /// @returns {Bool}
    writer_indent_blank_lines = false;
    
    /// @desc Whether to clean up the reader and its content after completing parsing or not.
    /// @returns {Bool}
    auto_cleanup = true;
    
    // Task state
    
    /// @desc The location at which the parsing error occurred.
    /// @returns {Struct.StrewtLocation}
    error_location = undefined;
    
    /// @desc Indicates the parsing status; 0 when in progress, positive when completed, negative when failed.
    /// @returns {Real}
    status = 0;
    
    /// @desc The formatting result.
    /// @returns {Any}
    result = undefined;
    
    /// @ignore
    error = undefined;
    
    // -----
    // Setup
    // -----
    
    /// @desc Configures the formatter to use the given newline sequence.
    /// @arg {String} sequence              The writer newline sequence.
    /// @returns {Struct.StrewtWriter}
    static with_newline_sequence = function(_sequence) {
        writer_newline_sequence = _sequence;
        return self;
    }
    
    /// @desc Configures the formatter to use the given default indentation unit.
    /// @arg {String} unit                  The new default indentation unit.
    /// @returns {Struct.StrewtWriter}
    static with_default_indent_unit = function(_unit) {
        writer_default_indent = _unit;
        return self;
    }
    
    /// @desc Configures the formatter to indent blank lines.
    /// @returns {Struct.StrewtWriter}
    static indenting_blank_lines = function() {
        writer_indent_blank_lines = true;
        return self;
    }
    
    /// @desc Configures the formatter to disable automatic cleanup after completion.
    /// @returns {Struct.StrewtParser}
    static with_manual_cleanup = function() {
        auto_cleanup = false;
        return self;
    }
    
    // ----------
    // Processing
    // ----------
    
    /// @desc Prepares the writer for formatting content.
    static init = function() {
        writer = new StrewtWriter();
        
        if (!is_undefined(writer_newline_sequence))
            writer.with_newline_sequence(writer_newline_sequence);
        
        if (!is_undefined(writer_default_indent))
            writer.with_default_indent_unit(writer_default_indent);
        
        if (writer_indent_blank_lines)
            writer.indenting_blank_lines();
    }
    
    /// @desc Performs the next formatting.
    /// @returns {Bool}
    static process_step = function() {
        throw StrewtException.not_implemented(self, nameof(process_step));
    }
    
    /// @desc Retrieves the current formatting progress.
    /// @returns {Any}
    static get_progress = function() {
        return undefined;
    }
    
    /// @desc Completes the formatting, collects the result and returns "true" for process_step purposes.
    /// @returns {Bool}
    static complete = function() {
        result = writer.get_content();
        status = 1;
        return true;
    }
    
    /// @desc Completes the formatting and collects the result if a given condition is met; returns the condition outcome.
    /// @returns {Bool}
    static complete_when = function(_condition) {
        return _condition ? complete() : false;
    }
    
    /// @desc Fails the formatting process with the given failure and returns "true" for process_step purposes.
    /// @returns {Bool}
    static fail = function(_failure) {
        error = _failure;
        status = -1;
        return true;
    }
    
    /// @desc Immediately performs all the remaining formatting and returns the formatted text.
    /// @returns {String}
    static format_all = function() {
        if (status != 0)
            return result;
        
        if (is_undefined(writer))
            init();
        
        while (!process_step()) {}
        cleanup(/* auto */ true);
        
        return result;
    }
    
    /// @desc Indicates whether the formatting has finished or not.
    /// @returns {Bool}
    static is_finished = function() {
        return status != 0;
    }
    
    /// @desc Attempts to clean up the formatter resources.
    /// @arg {Bool} [auto]                  Indicates whether cleanup was requested from a broader, standard process.
    static cleanup = function(_auto = false) {
        if (_auto && !auto_cleanup)
            return;
        
        if (is_undefined(writer))
            return;
        
        writer.cleanup();
        writer = undefined;
    }
}
