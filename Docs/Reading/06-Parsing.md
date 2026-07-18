[Home](/README.md) >> [Reading overview](00-Overview.md)

**Previous:** [Built-in patterns](05-PatternsBuiltin.md)

# Parsing

While the reader exposes functionality of reading individual text units, the parser coordinates the entire reading process - when to read which text unit, how to process extracted text and what result to produce.

While Strewt doesn't implement a parser for any particular format, it provides the **StrewtParser** base that can be used for building custom parsers. It implements the **TaskProcessor** interface as described in this page: [CIMPLI - Workers](https://github.com/Alphish/gm-cimpli/blob/main/Docs/05-Workers.md). As such, it can be used for gradual processing across multiple frames; in particular, it can be put into a *CimpliTask* to be handled by *CimpliWorker*.

## Creation and configuration

The **StrewtParser** on its own doesn't have any constructor arguments, though derived constructors may add theirs. However, the parser must be configured with the content or its file path, using one of the following methods:

- `for_content(content: String OR Buffer) -> StrewtParser` - directly prepares the content to be processed with the parser
- `for_file(path: String, [assource: Bool]) -> StrewtParser` - links the path of the content file to be loaded later; *assource* indicates whether the filename should be used to describe the underlying reader source (true by default)

When preparing many parsing tasks at once, it may be preferable to use *for_file* configuration when possible, so as not to clutter the memory with content buffers awaiting the processing.

Additionally, the following configurations are available:

- `with_source_name(name: String) -> StrewtParser` - describes the underlying reader source with the given name; it takes precedence over name set with *for_file* whether it's called earlier or later in the configuration chain
- `with_manual_cleanup() -> StrewtParser` - prevents automatic cleanup upon completion, whether caused by CimpliTask processing or *parse_all* method; the user will need to directly call the *cleanup* method instead

## Processing methods

The **StrewtParser** base constructor implements the **TaskProcessor** interface in the following way:

- `status` - set to 0 when processing has not finished, 1 when it's successful, -1 when it has failed
- `result` - set to the value returned by *resolve_result* method upon completion
- `error` - set to the error message upon failure
- `init` - loads the content from a file if not given directly, then prepares the reader for processing
- `process_step` - **not implemented, must be overridden in the derived parser constructor**; represents a single parsing step
- `get_progress` - returns the progress string based on the reader position in the format of "position/length"
- `is_finished` - returns whether the *status* is different from 0
- `cleanup` - cleans up the underlying reader, if it's not cleaned up already

Additionally, the following properties methods are available:

- `error_location: StrewtLocation` - the location of the parsing error, if any
- `resolve_result() -> Any` - **not implemented, must be overriden in the derived parser constructor**; produces the final result object upon completion
- `parse_all() -> Any` - immediately processes the remaining content and returns the parsing result; also performs the initialisation and automatic cleanup if needed
- `try_complete() -> Undefined` - attempts to complete the processing and produces the result; it will fail if called before the reader reaches the end of content
- `fail(message: String, [position]: Real)` - reports a failure with a given message as well as the failure location

## Example

Below is an example of a CSV parser that interprets the first row as a header and then creates structs using corresponding header text as struct variables.

Each entry may be given as a bare text or as a CSV-style string. The bare text is the content between two boundaries (comma, newline, start of text, end of text), with initial and trailing space trimmed. The string is enclosed in double quotes; a double quote itself can be escaped as a pair. If a given row is shorter than a header, the remaining entries are empty strings. If a given row is longer than headers, the parsing fails.

As can be seen from the example, a typical parser is likely to include:

- **process_step** and **resolve_result** implementations
- various text unit definitions (bytes, multigraphs, charsets, patterns etc.) used in the given format
- methods for parsing more specific bits of text
    - when at the given parsing stage multiple kinds of text can be processed (e.g. string, number, bracketed expression), chartables may help with choosing the most applicable method
- some kind of state gradually built over the course of parsing
    - for more complex formats, extracting the parsed state and its operations to a separate constructor may keep the parser logic cleaner

```gml
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
        reader.skip_byte(comma_byte);
        init_row();
        current_column_index += 1;
        current_column_filled = false;
        
        if (header_read && current_column_index >= array_length(result_header))
            fail($"Adding column #{current_column_index + 1} to the row when only {array_length(result_header)} columns are specified.");
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
```
