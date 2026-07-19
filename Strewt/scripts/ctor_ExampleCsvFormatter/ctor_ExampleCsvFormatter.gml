function ExampleCsvFormatter(_input) : StrewtFormatter(_input) constructor {
    current_row = 0;
    total_rows = undefined;
    header = undefined;
    
    static init = function() {
        method(self, StrewtFormatter.init)();
        
        if (!is_array(input))
            return fail("The input data must be an array of structs.");
        
        total_rows = array_length(input);
        if (total_rows == 0)
            return fail("At least one entry is required.");
    }
    
    static process_step = function() {
        if (status != 0)
            return;
        
        if (current_row == 0)
            write_header();
        
        write_row();
        current_row += 1;
        return complete_when(status != 0 || current_row >= total_rows);
    }
    
    static write_header = function() {
        header = struct_get_names(input[0]);
        for (var i = 0, _count = array_length(header); i < _count; i++) {
            if (i > 0)
                writer.write(", ");
            
            writer.write(header[i]);
        }
        writer.write_line();
    }
    
    static write_row = function() {
        var _entry = input[current_row];
        if (!is_struct(_entry))
            return fail($"Error in row #{current_row + 1}: The item is not a struct.");
        
        for (var i = 0, _count = array_length(header); i < _count; i++) {
            if (i > 0)
                writer.write(", ");
            
            var _key = header[i];
            var _value = _entry[$ _key];
            if (!is_string(_value) && !is_numeric(_value) && !is_undefined(_value))
                return fail($"Error in row #{current_row + 1}, entry '{_key}': Only string, numeric and undefined values are acceptable in individual items.");
            
            write_cell_value(_value);
        }
        writer.write_line();
    }
    
    static write_cell_value = function(_value) {
        if (is_undefined(_value)) {
            // do nothing
        } else if (is_string(_value)) {
            writer.write("\"" + string_replace(_value, "\"", "\"\"") + "\"");
        } else if (is_numeric(_value)) {
            writer.write(_value);
        }
    }
    
    static get_progress = function() {
        return $"{current_row}/{total_rows}";
    }
}
