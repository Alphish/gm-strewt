function StrewtWriterLineWritingTests(_run, _method) : StrewtWriterBaseTests(_run, _method) constructor {
    static test_subject = "Line writing";
    
    static should_write_empty_line = function() {
        given_writer();
        writer.write_line();
        when_content_collected();
        expect_result("\n");
        expect_position(1);
    }
    
    static should_write_value_line = function() {
        given_writer();
        writer.write_line("Lorem");
        when_content_collected();
        expect_result("Lorem\n");
        expect_position(6);
    }
    
    static should_write_line_with_custom_newline_sequence = function() {
        given_writer().with_newline_sequence("\r\n");
        writer.write_line("Lorem");
        when_content_collected();
        expect_result("Lorem\r\n");
        expect_position(7);
    }
    
    static should_write_empty_line_without_indent = function() {
        given_writer();
        writer.push_indent();
        writer.write_line();
        when_content_collected();
        expect_result("\n");
        expect_position(1);
    }
    
    static should_write_empty_line_with_indent_when_indenting_blank_lines = function() {
        given_writer().indenting_blank_lines();
        writer.push_indent();
        writer.write_line();
        when_content_collected();
        expect_result("    \n");
        expect_position(5);
    }
    
    static should_write_value_line_with_indent = function() {
        given_writer();
        writer.push_indent();
        writer.write_line("Lorem");
        when_content_collected();
        expect_result("    Lorem\n");
        expect_position(10);
    }
}
