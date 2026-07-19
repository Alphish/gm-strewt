function ExampleCsvParser() : StrewtParser() constructor {
    // relevant text units
    space_charset = strewt_charset_from_string(" \t");
    plaintext_charset = strewt_charset_from_string(",\r\n", /* including */ false);
    comma_byte = strewt_byte(",");
    string_pattern = new StrewtStringPairEscapePattern("\"");
    
    // chartable for picking the fitting action based on the character ahead
    action_chartable = strewt_chartable_create(parse_plain_item, /* complete upon reaching null terminator */ complete_file)
        .with_value("\"", parse_string_item)
        .with_value(",", complete_column)
        .with_value("\r\n", complete_line);
    
    // parsing state
    result_header = undefined;
    header_read = false;
    result_rows = [];
    current_row = undefined;
    current_column_index = 0;
    current_column_filled = false;
    
    // ---------------------
    // Parser implementation
    // ---------------------
    
    // the methods below are used in the base parser logic, but aren't originally implemented
    // generally speaking, every parser needs to implement these
    
    static process_step = function() {
        if (status != 0)
            return;
        
        // skip insignificant whitespace
        reader.skip_charset(space_charset);
        
        // choose and execute the appropriate action
        var _action = reader.peek_chartable(action_chartable);
        _action();
        
        return status != 0;
    }
    
    static resolve_result = function() {
        if (!header_read)
            fail($"No header was given, let alone data entries.");
        
        return result_rows;
    }
    
    // ---------------------------
    // Specific parsing operations
    // ---------------------------
    
    // these methods handle all kinds of text encountered in the CSV format
    
    static parse_plain_item = function() {
        var _entry = string_trim_end(reader.read_charset(plaintext_charset));
        add_entry(_entry);
    }
    
    static parse_string_item = function() {
        var _entry = reader.read_pattern(string_pattern);
        add_entry(_entry);
    }
    
    static complete_column = function() {
        var _precomma_position = reader.position;
        reader.skip_byte(comma_byte);
        init_row();
        current_column_index += 1;
        current_column_filled = false;
        
        if (header_read && current_column_index >= array_length(result_header))
            fail($"Adding column #{current_column_index + 1} to the row when only {array_length(result_header)} columns are specified.", _precomma_position);
    }
    
    static complete_line = function() {
        reader.skip_line();
        if (!header_read) {
            if (!is_undefined(result_header)) // mark header as completed only when it has actual items
                header_read = true; 
        } else if (!is_undefined(current_row)) {
            array_push(result_rows, current_row);
        }
        
        current_row = undefined;
        current_column_index = 0;
        current_column_filled = false;
    }

    static complete_file = function() {
        complete_line();
        try_complete();
    }
    
    // ----------------
    // State management
    // ----------------
    
    static add_entry = function(_entry) {
        if (!header_read) {
            result_header ??= [];
            array_push(result_header, _entry);
        } else if (current_column_filled) {
            fail($"Adding another entry '{_entry}' to the column with an entry already found.");
        } else {
            init_row();
            var _column_header = result_header[current_column_index];
            current_row[$ _column_header] = _entry;
        }
        current_column_filled = true;
    }
    
    static init_row = function() {
        if (!is_undefined(current_row))
            return;
        
        current_row = {};
        array_foreach(result_header, function(_header) {
            current_row[$ _header] = "";
        });
    }
}
