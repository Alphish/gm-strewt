[Home](/README.md) >> [Reading overview](00-Overview.md)

**Previous:** [Chartables and charsets](03-ChartablesCharsets.md)

# Patterns

Strewt patterns represent combinations of more basic text units, avoiding repetitive reader calls. Additionally, their content can be interpreted alongside reading - for example, a string pattern may have its escape sequences resolved immediately, as opposed to first retrieving the matched text and then performing additional processing to get a more useful value. Because of that, patterns - unlike other text units - have a distinction between the *raw content* and the *interpreted content*.

## Basic structure

There is no single all-encompassing pattern type that can be configured to match any combination of text units. Instead, there is a **StrewtPattern** base constructor, from which more specific patterns and their matching logic can be defined.

Each pattern has the following methods, as defined in the base pattern:

- `span(reader: StrewtReader) -> Real` - returns the match length without advancing
- `skip(reader: StrewtReader) -> Real` - advances past the match and returns its length
- `peek_raw(reader: StrewtReader) -> Real` - returns the match raw text without advancing
- `read_raw(reader: StrewtReader) -> Real` - advances past the match and returns its raw text
- `peek(reader: StrewtReader) -> Real` - returns the match interpreted text without advancing
- `read(reader: StrewtReader) -> Real` - advances past the match and returns its interpreted text
- `read_into(reader: StrewtReader) -> Real` - writes the interpreted match to the target buffer, advances past the match and returns the byte length of the raw match
- `restore_positions(reader: StrewtReader, readerfrom: Real, [target]: Id.Buffer, [targetfrom]: Real) -> Real` - restores the reader and optionally target buffer to given positions; mostly used for restoring pre-matching state after only partially matching the pattern

Most of these methods rely on one or two other methods to have implemented the matching logic. Here are default behaviours of pattern methods, as defined in **StrewtPattern** constructor:

- `skip` has no default implementation; **it must be overriden in the pattern child type/instance**
- `span` performs the skip, and then moves the reader back to the original position
- `peek_raw` performs the skip, moves the reader back and then extracts the content text matching the previewed length
- `read_raw` performs the skip, then extracts the content text matching the read length
- `read_into` performs the skip and copies the match content verbaatim to the target buffer; **it must be overriden in patterns whose interpreted content is different from raw content**
- `peek` prepares a throwaway target buffer, writes the interpreted content with `read_into`, returns the interpreted text and finally moves the reader back to the original position
- `read` prepares a throwaway target buffer, writes the interpreted content with `read_into` and returns the interpreted text

## Basic example

Suppose the text format you need to support has binary number literals, such as `0b00111010`. Such a literal can be split into two text units:

- the digraph `0b`
- the charset string consisting of 0s and 1s

The literal doesn't require any specific interpretation. Thus, the binary literal pattern needs to implement only the *skip* method. Here's an example implementation:

```gml
function BinaryLiteralPattern() : StrewtPattern() constructor {
    static prefix = strewt_digraph("0b");
    static bits_charset = strewt_charset_from_string("01");
    
    static skip = function(_reader) {
        if (!_reader.skip_digraph(prefix))
            return 0;
        
        var _original_position = _reader.get_position();
        var _bits_length = _reader.skip_charset(bits_charset);
        if (_bits_length == 0)
            return restore_positions(_reader, _original_position);
        else
            return 2 + _bits_length; // 2 from the prefix
    }
}
```

The pattern can be tested with the following code:

```gml
var _pattern = new BinaryLiteralPattern();

var _reader1 = strewt_reader_create("No binary");
show_debug_message($"RESULT 1: '{_reader1.read_pattern(_pattern)}'"); // no result - doesn't even begin with 0b
strewt_reader_destroy(_reader1);

var _reader2 = strewt_reader_create("0b5632");
show_debug_message($"RESULT 2: '{_reader2.read_pattern(_pattern)}'"); // no result - bits don't follow after 0b
strewt_reader_destroy(_reader2);

var _reader3 = strewt_reader_create("0b00111010 and no more");
show_debug_message($"RESULT 3: '{_reader3.read_pattern(_pattern)}'"); // a proper pattern string is found
strewt_reader_destroy(_reader3);
```

The output should be the following:

```
RESULT 1: ''
RESULT 2: ''
RESULT 3: '0b00111010'
```

## Interpreted pattern example

Suppose the text format you need to support has line comments, such as `// TODO: improve performance`. Additionally, the pattern should be interpreted as the comment content without the prefix, immediately following spaces and the newline characters. Such a comment can be split into three text units:

- the initial comment prefix `//`
- the charset of spaces and tabs (to skip after the prefix)
- the rest of the line

Because the comment needs to be interpreted, both the *skip* and *read_into* methods need to be implemented. Here's the implementation:

```
function LineCommentPattern() : StrewtPattern() constructor {
    static prefix = strewt_digraph("//");
    static spaces_charset = strewt_charset_from_string(" \t");
    
    static skip = function(_reader) {
        if (!_reader.skip_digraph(prefix))
            return 0;
        
        // once the prefix is read, the pattern is matched even if only end of file follows
        // the returned span includes the newline sequence
        // so that other span-dependent methods correctly match content between the original and the current position
        return 2 + _reader.skip_line(/* with end */ true);
    }
    
    static read_into = function(_reader, _target) {
        var _readfrom = _reader.position;
        if (!_reader.skip_digraph(prefix))
            return 0;
        
        _reader.skip_charset(spaces_charset);
        
        // using read_substring_into rather than read_line_into
        // because read_line_into would include the newline sequence, if any
        var _copyfrom = _reader.position;
        var _copyspan = _reader.skip_line(/* withend */ false); // the copied text should not include the newlines
        _reader.read_substring_into(_copyfrom, _copyspan, _target);
        
        return _reader.position - _readfrom;
    }
}
```

It should be noted how *spaces_charset* is only used in the *read_into* method. That's because prefix-following spaces become relevant only for interpretation - when only skipping is needed, spaces are already included in the remaining line content.

The raw and interpreted output can be tested with the following code:

```gml
var _pattern = new LineCommentPattern();

var _reader = strewt_reader_create("// this requires optimisation\narray_bogosort(all_people);");
show_debug_message($"RAW: '{_reader.peek_pattern_raw(_pattern)}'");
show_debug_message($"INTERPRETED: '{_reader.peek_pattern(_pattern)}'");
strewt_reader_destroy(_reader);
```

It should produce the following output:

```
RAW: '// this requires optimisation
'
INTERPRETED: 'this requires optimisation'
```

**Next:** [Built-in patterns](05-PatternsBuiltin.md)
