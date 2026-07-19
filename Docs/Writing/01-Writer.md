[Home](/README.md) >> [Writing overview](00-Overview.md)

# Writer

The writer functionality is available through the **StrewtWriter** constructor. It exposes methods for writing individual values and spans of text, entire lines and even multiline blocks of text. Also, it has indentation management, as it's often relevant for various data or coding formats.

Strewt writer is backed by a buffer. Buffer-based writing should be more efficient the more text is written - each string concatenation (adding two or more strings together) requires reserving memory for a new string every time, which causes slowdowns if there are many strings added every frame. In contrast, writing to a buffer requires new memory only when the current buffer capacity can't contain the added text.

The writer functionality can be wrapped in a formatter, which controls the flow of text writing and allows spreading the writing operation across many frames. Formatting will be described in more detail in the next chapter.

## Creation and configuration

The writer can be created with its constructor or using the `strewt_writer_create` function. Both the constructor and the `strewt_writer_create` function accept the following optional argument:

- `[target]: Buffer` - the target buffer to write the text to; if not given, the writer will create its own buffer

Additionally, the following configuration methods are available (methods return the configured writer):

- `with_newline_sequence(sequence: String)` - configures the writer to add the given newline sequence when end of line is required (the default newline is `\n`, i.e. a single feed character)
- `with_default_indent_unit(unit: String)` - configures the writer to push the given indentation unit by default (when indent is pushed0
- `indenting_blank_lines()` - configures the writer to apply indentation even in lines where nothing was written

## Navigation

You can inspect and manipulate the reader position using following methods:

- `get_position() -> Real` - gets the current reader position (in bytes)
- `get_length() -> Real` - gets the current written content length (in bytes); in practice, it's the same as the position
- `move_to(position: Real) -> Undefined` - moves the reader to the given position
- `move_by(offset: Real) -> Undefined` - moves the reader position by the given offset

## Writer

The writer exposes the following methods for writing content:

- `write(value: Any) -> BufferErrorType` - writes the given text value or a string representation of a non-text value
- `write_line([value]: Any) -> BufferErrorType` - writes the given value followed by a newline sequence (the one the writer is configured with); if no value is given, only the newline sequence is appended
- `write_multiline(value: String OR Array, [lastline]: Bool) -> BufferErrorType` - writes each line in the value as a separate line; for a multiline string, the lines are determined by splitting the text by all of CRLF/CR/LF newline sequences; for a multiline array each entry is treated as its own line; the *lastline* argument indicates whether the newline sequence should be written after the last line or not (true by default)

Additionally, Strewt reader exposes the following method for direct buffer writing:

- `write_direct(datatype: BufferDataType, value: Any) -> Any` - writes a value of the given data type directly to the target buffer

## Indentation

The writer automatically adds the applicable indentation whenever it's about to write a new value to the given line. It has the following methods for managing indentations:

- `push_indent([segment]: String) -> Undefined` - adds a segment to the current indentation; when no segment is specified, the default indentation unit is used
- `pop_indent() -> Undefined` - removes the last segment from the current indentation, if any
- `try_write_indent() -> Undefined` - checks if the writer is at the start of line, and if so, writes the current indentation

The Strewt writer can be configured to use a given default indentation unit and to include indentation even if nothing else is written to the given line. For example, given the following code:

```gml
var _writer = strewt_writer_create().with_default_indent_unit("....").indenting_blank_lines();
_writer.write_line("open");
_writer.push_indent();
_writer.write_line("some content");
_writer.write_line();
_writer.write_line("other content");
_writer.pop_indent();
_writer.write_line("close");

show_debug_message(_writer.get_content());
strewt_writer_destroy(_writer);
```

The following output will be produced:
```
open
....some content
....
....other content
close
```

In contrast, if the `indenting_blank_lines()` call is removed, the output will be the following instead:

```
open
....some content

....other content
close
```

Also, when a multiline string/array is written, the indent applies to each contained line individually:

```gml
var _writer = strewt_writer_create().with_default_indent_unit("....");
_writer.write_line("open");
_writer.push_indent();
_writer.write_multiline("Lorem\nIpsum\nDolor");
_writer.pop_indent();
_writer.write_line("close");

show_debug_message(_writer.get_content());
strewt_writer_destroy(_writer);
```

The output will be written like so:

```gml
open
....Lorem
....Ipsum
....Dolor
close
```

## Result retrieval

The Strewt writer exposes the following methods to retrieve its results:

- `get_content() -> String` - reads the target buffer up to the current position as a string and returns the result
- `get_content_bytes([bufftype]: BufferDataType) -> Buffer` - creates a new buffer with the given data type and a copy of the target buffer contents; the user should make sure to clean up this buffer separately so as not to cause a memory leak

## Cleanup

After the writer is no longer used, its resources should be freed using the writer's `cleanup` instance method, like so:

```gml
test_writer.cleanup();
```

Alternatively, you may use `strewt_writer_destroy` function, like so:

```gml
strewt_writer_destroy(test_writer);
```

**Next:** [Formatting](02-Formatting.md)
