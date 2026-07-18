[Home](/README.md) >> [Reading overview](00-Overview.md)

# Reader

The reader functionality is available through the **StrewtReader** constructor. It exposes methods for easily scanning through various text fragments - individual bytes or sequences thereof, fixed strings, whole lines and continuous sequences of specific character category (so-called charset).

The aforementioned building blocks may be used to create more complex reusable patterns. Finally, the reader functionality can be wrapped in a parser, that controls the flow of the text processing. Patterns and parsers will be described in more detail in the later chapters.

## Setup

The reader can be created with its constructor or using the `strewt_reader_create` function. Both the constructor and the `strewt_reader_create` function the following argument:

- `content: String OR Id.Buffer` - the content for the reader to process; the content may be given as a string to turn into a new buffer, or as an existing buffer to use

Example of creating the reader from the string:

```gml
script_reader = new StrewtReader("x = 2 + 2 * 2;");
```

Additionally, the following configuration method is available (the method returns the configured reader):

- `with_source_name(name: String)` - the name specifying the source of the read content; can be useful e.g. for easily identifying which file the reader was created for

Example use:

```gml
var _filename = "bob.txt";
var _script_buffer = buffer_load($"dialogue/{_filename}");
script_reader = strewt_reader_create(_script_buffer).with_source_name(_filename);
```

## Cleanup

After the reader is no longer used, its resources should be freed using the reader's `cleanup` instance method, like so:

```gml
script_reader.cleanup();
```

Alternatively, you may use `strewt_reader_destroy` function, like so:

```gml
strewt_reader_destroy(script_reader);
```

## Navigation

You can inspect and manipulate the reader position using following methods:

- `get_position() -> Real` - gets the current reader position (in bytes)
- `is_end_of_content() -> Bool` - indicates whether the reader position reached the end or not
- `move_to(position: Real) -> Undefined` - moves the reader to the given position
- `move_by(offset: Real) -> Undefined` - moves the reader position by the given offset

Additionally, you can retrieve the reader location using one of the following methods:

- `get_location() -> Struct.StrewtLocation` - creates a new location struct by counting lines/columns from the very start
- `update_location(target: Struct.StrewtLocation) -> Struct.StrewtLocation` - updates an existing location struct by counting lines/columns relative to the previous position; will count from the start when backtracking

Both methods will return a **Strewt location struct** with **line** (1-indexed), **column** (1-indexed) and **position** (0-indexed) variables.

Because `get_location` method scans the entire content up to the current position to calculate its line and column, it should only be used when location needs to be accessed infrequently. An example would be diagnosing text processing errors - a basic parser will stop immedaitely upon failure, and thus for each individual reader an error and its location will be reported at most once.

If the location needs to be accessed many times throughout text processing, it's recommended to create a reusable location struct and update it with `update_location` instead. For example:

```gml
var _location = new StrewtLocation();
while (!reader.is_end_of_content()) {
    // do text processing step
    reader.update_location(_location);
    show_debug_message(_location);
}
```

If multiple location instances are needed, you can use the location's `clone` method to get a separate instance with same coordinates:

```gml
var _location = new StrewtLocation();
var _found_locations = [_location];
while (!reader.is_end_of_content()) {
    // do text processing step
    _location = reader.update_location(_location.clone());
    array_push(_found_locations, _location);
}
show_debug_message(_found_locations);
```

## Content sections

Strewt reader exposes the following methods for accessing and applying content sections:

- `peek_all() -> String` - returns the entire content text
- `peek_substring(from: Real, to: Real) -> String` returns the subsection of the content between given bytes
- `read_substring_into(from: Real, span: Real, target: Id.Buffer) -> Real` - copies into the target buffer a content section starting from the *from* position and with the length of *span*

## Reading

The core of the Strewt reader is, of course, its reading/processing methods. There are various text units supported, and their methods will involve matching these units against the content at the current reader position.

Most text units can be processed by some or all of the following method types:

- **span_\*** - return the match length without changing the reader position
- **skip_\*** - return the match length and move the reader past the match
- **peek_\*** - return the match content without changing the reader position
- **read_\*** - return the match content and move the reader past the match
- **read_\*_into** (with target buffer) - return the match length, move the reader past the match and copy matched content bytes into the given target buffer

If the given text unit is not matched at the current position, the returned match length is 0 and the returned match content is an applicable blank value (0 for bytes, empty string for text). No text unit is matched at the end of content.

The following table shows available methods in more detail:

| Text unit | Span | Skip | Peek | Read | Read into |
| ---- | ---- | ---- | ---- | ---- | ---- |
| **Next byte**  | `span_next` | `skip_next` | `peek_next` | `read_next` | `read_next_into` |
| **Exact byte** | `span_byte` | `skip_byte` | N/A | N/A | `read_byte_into` |
| **Byte sequence** | `span_byte_sequence` | `skip_byte_sequence` | N/A | N/A | `read_byte_sequence_into` |
| **Digraph** | `span_digraph` | `skip_digraph` | N/A | N/A | `read_digraph_into` |
| **Trigraph** | `span_trigraph` | `skip_trigraph` | N/A | N/A | `read_trigraph_into` |
| **Tetragraph** | `span_tetragraph` | `skip_tetragraph` | N/A | N/A | `read_tetragraph_into` |
| **Character** | `span_character` | N/A | `peek_character` | `read_character` | N/A |
| **Exact string** | `span_string` | `skip_string` | N/A | N/A | `read_string_into` |
| **Line** | `span_line` | `skip_line` | `peek_line` | `read_line` | `read_line_into` |
| **Charset byte** | `span_charset_byte` | `skip_charset_byte` | `peek_charset_byte` | `read_charset_byte` | `read_charset_byte_into` |
| **Charset string** | `span_charset` | `skip_charset` | `peek_charset` | `read_charset` | `read_charset_into` |
| **Chartable value** | N/A | N/A | `peek_chartable` | `read_chartable` | N/A |
| **Pattern<sup>1</sup>** | `span_pattern` | `skip_pattern` | `peek_pattern` | `read_pattern` | `read_pattern_into` |

Most reading methods require an argument narrowing down the text unit in question, e.g. the expected byte for the "Exact byte" unit. The parameter used to specify the unit is consistent across nearly all of its methods. `read_into_*` method is an exception in that it has an additional *target* argument, providing the target buffer to copy found content into. In this method, the *target* parameter will be placed after the unit's own parameter if it's required, or before the unit's own parameter if it's optional.

Specific text units are described in more detail in this chapter: [Text Units](02-TextUnits.md)

Additionally, Strewt reader exposes the following methods for direct reading:

- `peek_direct(datatype: Constant.BufferDataType) -> Any` - previews a value directly from the content buffer at the current position
- `read_direct(datatype: Constant.BufferDataType) -> Any` - reads a value directly from the content buffer and advances the reader position

<sup>1</sup>Patterns additionally have `peek_pattern_raw` and `read_pattern_raw` methods, which is related to interpreting the pattern content. You can read more about it on the [Patterns](04-Patterns.md) page.

## Limitations

The Strewt reader is primarily designed for processing ASCII-based formats, with each ASCII character taking 1 byte in the UTF-8 encoding. The reader can scan through non-ASCII characters and it's relatively straightforward when all of these characters serve the same role in the given format. However, Strewt reader may struggle when specific non-ASCII characters or character groups need to be handled separately from other non-ASCII characters/groups.

For example, reading non-ASCII characters wholesale within an apostrophe-delimited string is easily handled. Using rightwards double arrow (⇒) as a logical implication operator is trickier to handle.

Additionally, it's assumed the content processed by Strewt reader doesn't have null characters (with byte value of 0) except at the end. It's similar to the way [null-terminated strings](https://en.wikipedia.org/wiki/Null-terminated_string) work, and also how GameMaker writes text to buffers using `buffer_string` data type. Based on this assumption, zero is returned as a "non-value" when the reader reached the end of content. Processing content with null characters may still be doable, but retrieving relevant content substrings may return incorrect results if the substring contains a null character.

**Next:** [Text units](02-TextUnits.md)
