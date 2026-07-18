[Home](/README.md) >> [Reading overview](00-Overview.md)

**Previous:** [Text units](02-TextUnits.md)

# Chartables and charsets

## Chartables

A chartable assigns a value to each possible character byte (256 in total), which can be quickly accessed through the underlying array. An example application would be choosing a different parsing route depending on which character is next, as shown in the example below:

```gml
// parse_variable, parse_number and parse_string are methods to apply depending on which character is ahead
parsing_routes = strewt_chartable_create()
    .with_value("_", parse_variable)
    .with_value_range("A", "Z", parse_variable)
    .with_value_range("a", "z", parse_variable)
    .with_value_range("0", "9", parse_number)
    .with_value("+-", parse_number)
    .with_value("'\"", parse_string);
```

The underlying chartable values can be accessed via its internal `table` array. That said, it's expected these values will be accessed indirectly via `peek_chartable` or `read_chartable` Strewt reader methods most of the time.

#### Creation

Chartable can be created with the **StrewtChartable** constructor or `strewt_chartable_create` function. Both accept the following arguments:

- `[input]: Any OR Array` - the default value or the array of chartable values (the input is undefined by default)
- `[blank]: Any` - the value of the zero byte (undefined by default)

**Note:** The value assigned to zero byte is only affected by the *blank* argument regardless of the default or values array passed to the *input*. That's because zero byte is expected only at the end of content, and thus is considered a special case that shouldn't have its non-undefined value changed by accident.

Also, it's possible to create a new chartable based on an existing one, using the `clone` instance method.

#### Configuration

The Strewt chartable can be configured with the following methods:

- `with_byte_value(byte: Real, value: Any) -> StrewtChartable` - assigns a value to the given byte
- `with_value(target: Real OR Array<Real> OR String, value: Any) -> StrewtChartable` - assigns a value to all bytes represented by the given target, which may be a byte, an array of bytes or a string of single-byte (ASCII) charcters to assign the value to
- `with_range_value(from: Real OR String, to: Real OR String, value: Any) -> StrewtChartable` - assigns a value to all bytes in a given range, with start and end given as a byte or a single-byte string

## Charsets

A charsets is a special kind of chartable that assigns only *true* or *false* to each value; bytes with *true* value assigned are included in the charset, while bytes with *false* value assigned are excluded from the charset. The zero byte value is always set to *false* so that the Strewt reader stops when matching a charset string (otherwise it would go past the string terminator byte out of content buffer bounds).

Like with other chartables, charset values can be accessed via its internal `table` array, though it's expected these values will be accessed indirectly via charset-related reader functions most of the time. 

#### Creation

The charset can be created with the **StrewtCharset** constructor or `strewt_charset_create` function. Both accept the following argument:

- `[input]: Bool OR Array<Bool>` - the default value or the array of charset values (the input is false by default)

Additionally, a `strewt_charset_from_string` function can be used to create a charset instantly configured to include or exclude given characters. It accepts the following arguments:

- `chars: String` - the string of characters to include/exclude
- `[including]: Bool` - whether to create a charset including only the given character, or including all but the given characters (true by default)

Example use for creating charsets from string:

```gml
digits_charset = strewt_charset_from_string("0123456789");
nonquote_charset = strewt_charset_from_string("\"", /* including */ false);
```

Additionally, it's possible to create a new charset based on an existing one, using the `clone` instance method. Moreover, one can create an inverse of the existing charset (with inclusions and exclusions flipped) using the `inverse` instance method. The inverted charset still doesn't include the zero byte.

#### Configuration

The Strewt charset can be configured with the following methods:

- `including(target: Real OR Array<Real> OR String) -> StrewtChartable` - includes the given byte, array of bytes or a string of single-byte (ASCII) characters
- `excluding(target: Real OR Array<Real> OR String) -> StrewtChartable` - excludes the given byte, array of bytes or a string of single-byte (ASCII) characters
- `including_range(from: Real OR String, to: Real OR String) -> StrewtChartable` - includes all bytes in the given bytes/characters range
- `excluding_range(from: Real OR String, to: Real OR String) -> StrewtChartable` - excludes all bytes in the given bytes/characters range

**Next:** [Patterns](04-Patterns.md)
