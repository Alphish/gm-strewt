[Home](/README.md) >> [Reading overview](00-Overview.md)

**Previous:** [Reader](01-Reader.md)

# Text units

The Strewt Reader allows processing various kinds of text units, with its span/skip/peek/read/read_into operations. Below are described text units recognised by the reader, how they're matched and what methods are available to them.

For a quick reference:

- **span_\*** methods return the match length without changing the reader position
- **skip_\*** methods return the match length and move the reader past the match
- **peek_\*** methods return the match value without changing the reader position
- **read_\*** methods return the match value and move the reader past the match
- **read_\*_into** methods return the match length, move the reader past the match and copy matched content bytes into the given target buffer
- the match is always checked at the current reader position
- no match can be found at the end of content position
- if no match is found, the returned match length is 0 and the returned match value is an applicable blank value (0 for bytes, empty string for text)

Also, most text units will require passing a specifier into their methods. Additionally, *read_into* methods will have a target argument after the specifier, but before any applicable optional arguments.
## Byte text units

### Next byte

- **Methods:** `span_next`, `skip_next`, `peek_next`, `read_next`, `read_next_into`
- **Specifier:** N/A
- **Matches:** Any byte
- **Returned span:** 1
- **Returned match value:** Current byte value

### Exact byte

You can create the byte specifier from a single-byte string using the `strewt_byte` function. It'll throw an error if the length is invalid.

- **Methods:** `span_byte`, `skip_byte`, `read_byte_into`
- **Specifier:** `byte: Real` - the expected byte value 
- **Matches:** Byte equal to the expected byte
- **Returned span:** 1
- **Returned match value:** N/A

### Byte sequence

- **Methods:** `span_byte_sequence`, `skip_byte_sequence`, `read_byte_sequence_into`
- **Specifier:** `bytes: Array<Real>` - the expected bytes to be matched at the given position 
- **Matches:** Sequence of content bytes same as expected bytes
- **Returned span:** Expected sequence length
- **Returned match value:** N/A

## Multigraph text units

Multigraphs represent short byte sequences (2/3/4) with integer values. They can be compared to *buffer_u16* and *buffer_u32* datatypes, making matching slightly more efficient than byte sequences of same length. Also, multigraph numeric representations can be created from strings of the matching byte length.

### Digraph

You can create the digraph numeric representation from a 2-byte string using the `strewt_digraph` function. It'll throw an error if the length is invalid.

- **Methods:** `span_digraph`, `skip_digraph`, `read_digraph_into`
- **Specifier:** `value: Real` - the expected digraph value
- **Matches:** 16-bit unsigned integer equal to the digraph value
- **Returned span:** 2
- **Returned match value:** N/A

### Trigraph

You can create the trigraph numeric representation from a 3-byte string using the `strewt_trigraph` function. It'll throw an error if the length is invalid.

- **Methods:** `span_trigraph`, `skip_trigraph`, `read_trigraph_into`
- **Specifier:** `value: Real` - the expected trigraph value
- **Matches:** 32-bit unsigned integer whose first three bytes are equal to the trigraph value
- **Returned span:** 3
- **Returned match value:** N/A

### Tetragraph

You can create the tetragraph numeric representation from a 4-byte string using the `strewt_tetragraph` function. It'll throw an error if the length is invalid.

- **Methods:** `span_trigraph`, `skip_trigraph`, `read_trigraph_into`
- **Specifier:** `value: Real` - the expected trigraph value
- **Matches:** 32-bit unsigned integer equal to the tetragraph value
- **Returned span:** 4
- **Returned match value:** N/A

## Character-based text units

### Character

- **Methods:** `span_character`, `peek_character`, `read_character`
- **Specifier:** N/A
- **Matches:** Any valid UTF-8 character binary representation
- **Returned span:** 1-4
- **Returned match value:** Match text

Note: Because the Strewt reader is primarily focused on processing ASCII characters, it doesn't implement *skip* and *read_into* methods for UTF-8 characters.

### Exact string

- **Methods:** `span_string`, `skip_string`, `read_string_into`
- **Specifier:** `str: String` - the expected string
- **Matches:** Sequence of content bytes same as the string bytes
- **Returned span:** Expected string length
- **Returned match value:** Match text

### Line

- **Methods:** `span_line`, `skip_line`, `peek_line`, `read_line`, `read_line_into`
- **Specifier:** N/A
- **Option:** `withend: Bool` - indicates whether the newline sequence at the end should be included in returned span/content or not (false by default)
- **Matches:** Content bytes up to the nearest newline sequence (CR/LF/CRLF) or end of content
- **Returned span:** Number of bytes before the next newline sequence (when *withend* is false) or up to and including the next newline sequence (when *withend* is true)
- **Returned match value:** Content text before the next newline sequence (when *withend* is false) or up to and including the next newline sequence (when *withend* is true)

Note: While *withend* option affects returned value, the resulting reader and target buffer state remains the same. More specifically:

- *skip_line*/*read_line*/*read_line_into* methods will always move the reader position after the newline sequence
- the *read_line_into* method will always copy line contents up to and including the newline sequence to the target buffer

## Charsets and chartables

As a broad overview:

- chartable, represented with the **StrewtChartable** struct, assigns any kind of values to character bytes
- charset, represented with the **StrewtCharset** struct, is a special kind of chartable that assigns true or false value to each byte; the true value represents inclusion, and the false value represents exclusion

The more detailed explanation of chartables and charsets can be found in this chapter: [Chartables and charsets](03-ChartablesCharsets.md)

### Charset byte

- **Methods:** `span_charset_byte`, `skip_charset_byte`, `peek_charset_byte`, `read_charset_byte`, `read_charset_byte_into`
- **Specifier:** `charset: StrewtCharset` - the charset the byte should belong to
- **Matches:** Any byte included in the given charset
- **Returned span:** 1
- **Returned match value:** Current byte value

### Charset string

- **Methods:** `span_charset`, `skip_charset`, `peek_charset`, `read_charset`, `read_charset_into`
- **Specifier:** `charset: StrewtCharset` - the charset to read the continuous sequence of
- **Matches:** An unbroken sequence of bytes belonging to the given charset
- **Returned span:** Number of bytes in the matched bytes sequence
- **Returned match value:** Content text of the matched bytes sequence

### Chartable value

- **Methods:** `peek_chartable`, `read_chartable`
- **Specifier:** `chartable: StrewtChartable` - the chartable to retrieve the value of
- **Matches:** Any byte
- **Returned span:** N/A
- **Returned match value:** Chartable value assigned to the current byte

The chartable only has peek/read methods, because the only reason one would want to use chartable functions is to get the value corresponding to the current byte.

## Patterns

Patterns are a special text unit that typically combines various other text units under the hood. You can read more about them in this chapter: [Patterns](04-Patterns.md)

Patterns can be additionally intepreted throughout the pattern processing. For example, a string pattern with a backslash-based escape would be interpreted as the inner string content with escape sequences converted to their corresponding characters. In contrast, the raw content would include the string delimiters and escape sequences intact. Such a string pattern could match the raw content of `"This is in \"quotation marks\""` and the interpreted value of `This is in "quotation marks"`.

Because of the difference between raw and interpreted content, patterns have additional `peek_pattern_raw` and `read_pattern_raw` methods. The usual `peek_pattern` and `read_pattern` methods return the interpreted value.

`read_pattern_into` writes the interpreted content value into the target buffer, but still returns the length of the matched pattern.

- **Methods:** `span_pattern`, `skip_pattern`, `peek_pattern_raw`, `read_pattern_raw`, `peek_pattern`, `read_pattern`, `read_pattern_into`
- **Specifier:** `pattern: StrewtPattern` - the pattern to match against the current reader content
- **Matches:** Varies by pattern
- **Returned span:** The length of the raw pattern match
- **Returned match value:** Interpreted pattern value (for *peek_pattern* and *read_pattern*) or raw match content (for *peek_pattern_raw* and *read_pattern_raw*)

**Next:** [Chartables and charsets](03-ChartablesCharsets.md)
