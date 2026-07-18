[Home](/README.md)

# Reading overview

Strewt provides a wide variety of text reading functionality, upon which more complex parsing logic can be built. It provides a **reader** that can process various **text units** in its content. Additionally, it defines **chartables**, **charsets** and **patterns** for reading more complex text blcks. Finally, it has a **parser base** for defining complex format reading.

The guide describes the following topics in more details:

- [Reader](01-Reader.md)
- [Text units](02-TextUnits.md)
- [Chartables and charsets](03-ChartablesCharsets.md)
- [Patterns](04-Patterns.md)
- [Built-in patterns](05-PatternsBuiltin.md)
- [Parsing](06-Parsing.md)

## Basic reading example

The following bit of code demonstrates reading the "Hello, world!' text:

```gml
var _comma_digraph = strewt_digraph(", ");
var _exclamation_byte = strewt_byte("!");
var _word_charset = strewt_charset_create().including_range("A", "Z").including_range("a", "z");

var _reader = strewt_reader_create("Hello, world!");
var _target = buffer_create(buffer_fixed, 5, 1);

show_debug_message($"First word content: {_reader.read_charset(_word_charset)}");
show_debug_message($"Comma skip: {_reader.skip_digraph(_comma_digraph)}");
show_debug_message($"Second word read length: {_reader.read_charset_into(_word_charset, _target)}");
show_debug_message($"Exclamation skip length: {_reader.skip_byte(_exclamation_byte)}");
show_debug_message($"Reading finished: {_reader.is_end_of_content()}");
show_debug_message($"Target buffer: {buffer_peek(_target, 0, buffer_text)}");

strewt_reader_destroy(_reader);
buffer_delete(_target);
```

It produces the following output:

```
First word content: Hello
Comma skip: 2
Second word read length: 5
Exclamation skip length: 1
Reading finished: 1
Target buffer content: world
```
