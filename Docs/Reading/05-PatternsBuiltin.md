[Home](/README.md) >> [Reading overview](00-Overview.md)

**Previous:** [Patterns](04-Patterns.md)

# Built-in patterns

Certain kinds of patterns are so useful, they're available in Strewt out of the box.

### Number

The number pattern can be created with **StrewtNumberPattern** constructor. It doesn't have any configuration.

The pattern matches the following:

- an optional +/- sign
- a mandatory string of digits
- an optional fractional part, consisting of a decimal point followed by one or more digits
- an optional exponent, consisting of a letter e/E followed by an optional +/- sign and one or more digits

Both the raw and the interpreted text are the same.

### Pair escape string

The pair escape string pattern can be created with **StrewtStringPairEscapePattern** constructor. The constructor accepts the following argument:

- `delimiter: String` - the delimiter character marking the beginning and end of the string

The pattern matches arbitrary text between two delimiter characters. The delimiter character can be escaped as two delimiter characters in a row. It matches a convention seen e.g. in CSV files.

The interpreted text consists of the inner text (without delimiters); delimiter pair escapes are treated as a single delimiter character.

### Character escape string

The character escape string pattern can be created with **StrewtStringCharacterEscapePattern** constructor. The constructor accepts the following arguments:

- `delimiter: String` - the delimiter character marking the beginning and the end of the string (double quote by default)
- `escape: String` - the character used for escape sequences (backslash by default)
- `withnewlines: Bool` - whether newline characters are allowed verbatim in the string or not (false by default)

Additionally, the pattern can be configured with the following methods:

- `with_custom_escape(key: Real OR String, escape: String OR Function) -> StrewtStringCharsetEscapePattern` - configures the given escape sequence character with a replacement string or a resolver methods
- `with_newline_escapes() -> StrewtStringCharsetEscapePattern` - maps `?n` and `?r` escape sequences onto LF and CR characters, respectively (the `?` is the escape starting character)
- `with_json_escapes() -> StrewtStringCharsetEscapePattern` - configures the pattern to use standard JSON escapes, including `\uXXXX` Unicode escape sequences

The pattern matches text between two arbitrary characters; direct newlines may or may not be allowed within the pattern, depending on how they were configured.

The interpreted text consists of the inner text (without delimiters); escape sequences are replaced with their corresponding replacement string or the result of the resolver method.

**Next:** [Parsing](06-Parsing.md)
