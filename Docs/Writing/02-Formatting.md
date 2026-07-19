[Home](/README.md) >> [Writing overview](00-Overview.md)

**Previous:** [Writer](01-Writer.md)

# Formatting

While the writer exposes functionality of writing individual values and lines, the formatter coordinates the process of writing the input representation in the given format.

While Strewt doesn't implement a formatter for any particular format, it provides the **StrewtFormatter** base that can be used for building custom formatters. It implements the **TaskProcessor** interface as described in this page: [CIMPLI - Workers](https://github.com/Alphish/gm-cimpli/blob/main/Docs/05-Workers.md). As such, it can be used for gradual processing across multiple frames; in particular, it can be put into a *CimpliTask* to be handled by *CimpliWorker*.

## Creation and configuration

The **StrewtFormatter** on its own doesn't have any constructor arguments, though derived constructors may add theirs. The following configurations are available:

- `with_newline_sequence(sequence: String) -> StrewtFormatter` - configures the underlying writer to use the given newline sequence for writing new lines
- `with_default_indent_unit(unit: String) -> StrewtFormatter` - configures the underlying writer to use the given default indentation unit
- `indenting_blank_lines() -> StrewtFormatter` - configures the underlying writer to write indentation even for lines with no additional content
- `with_manual_cleanup() -> StrewtFormatter` - prevents automatic cleanup upon completion, whether caused by CimpliTask processing or *format_all* method; the user will need to directly call the *cleanup* method instead

## Processing methods

The **StrewtFormatter** base constructor implements the **TaskProcessor** interface in the following way:

- `status` - set to 0 when processing has not finished, 1 when it's successful, -1 when it has failed
- `result` - set to the text written by the underlying writer (as retrieved with `get_content`)
- `error` - set to the error message upon failure
- `init` - creates and configures the underlying writer
- `process_step` - **not implemented, must be overridden in the derived formatter constructor**; represents a single formatting step
- `get_progress` - **not implemented**, may be optionally overriden; with the diversity of applicable inputs to format, it's up to the derived constructor to determine the most fitting progress-counting method
- `is_finished` - returns whether the *status* is different from 0
- `cleanup` - cleans up the underlying writer, if it's not cleaned up already

Additionally, the following properties methods are available:

- `complete() -> Bool` - marks formatting as completed and prepares the result; returns *true* to be returned by `process_step`
- `complete_when([condition]: Bool) -> Bool` - checks if the given condition is met and if so, completes the formatting; the condition result is returned for `process_step`
- `fail(message: String) -> Bool` - fails the formatting with the given message; returns *true* to be returned by `process_step`
- `format_all() -> String` - immediately processes the remaining input and returns the formatting result; also performs the initialisation and automatic cleanup if needed

## Example

Below is an example of a CSV formatter that retrieves keys of the first entry as a header and then writes rows for each entry. The expected input is an array of structs, and each of item struct entries must be either a string, a number or an undefined value.

As can be seen from the example, a typical formatter is likely to include:

- **process_step** and **get_progress** implementations
- methods for formatting more specific bits of input
- some kind of state for navigation through the formatted input (whether as simple as iterating through an array or exploring nested structures)

```gml
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
```
