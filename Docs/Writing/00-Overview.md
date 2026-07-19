[Home](/README.md)

# Writing overview

Strewt provides basic text writing utilities. It exposes a **writer** that can write values and lines and keeps track of indents. Also, it has a **formatter base** for writing complex and/or large entities.

The guide describes the following topics in more details:

- [Writer](01-Writer.md)
- [Formatting](02-Formatting.md)

## Basic writing example

The following bit of code demonstrates generating some example code:

```gml
var _writer = strewt_writer_create();
_writer.write_line("function example_function(a, b) {");
_writer.push_indent();
_writer.write_line("var _result = a + b;");
_writer.write_line("show_debug_message(_result);");
_writer.write_line("return _result;");
_writer.pop_indent();
_writer.write_line("}");

show_debug_message(_writer.get_content());

strewt_writer_destroy(_writer);
```

It produces the following output:

```
function example_function(a, b) {
    var _result = a + b;
    show_debug_message(_result);
    return _result;
}
```
