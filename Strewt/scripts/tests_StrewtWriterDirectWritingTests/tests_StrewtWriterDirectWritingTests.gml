function StrewtWriterDirectWritingTests(_run, _method) : StrewtWriterBaseTests(_run, _method) constructor {
    static test_subject = "Direct writing";
    
    static should_write_text_bytes = function() {
        given_writer();
        writer.write_direct(buffer_u8, 49);
        writer.write_direct(buffer_u8, 50);
        writer.write_direct(buffer_u8, 51);
        when_content_collected();
        expect_result("123");
        expect_position(3);
    }
    
    static should_write_arbitrary_bytes = function() {
        given_writer();
        writer.write_direct(buffer_u8, 1);
        writer.write_direct(buffer_u8, 2);
        writer.write_direct(buffer_u8, 3);
        when_content_bytes_collected();
        expect_result([1, 2, 3]);
        expect_position(3);
    }
    
    static should_write_bytes_without_indent = function() {
        given_writer();
        writer.push_indent();
        writer.write_direct(buffer_u8, 49);
        writer.write_direct(buffer_u8, 50);
        writer.write_direct(buffer_u8, 51);
        when_content_collected();
        expect_result("123");
        expect_position(3);
    }
    
    static should_write_no_indent_after_non_newline_bytes = function() {
        given_writer();
        writer.push_indent();
        writer.write_direct(buffer_u8, 49);
        writer.write_direct(buffer_u8, 50);
        writer.write_direct(buffer_u8, 51);
        writer.write("Lorem");
        when_content_collected();
        expect_result("123Lorem");
        expect_position(8);
    }
    
    static should_write_indent_after_newline_byte = function() {
        given_writer();
        writer.push_indent();
        writer.write_direct(buffer_u8, 49);
        writer.write_direct(buffer_u8, 50);
        writer.write_direct(buffer_u8, 10);
        writer.write("Lorem");
        when_content_collected();
        expect_result("12\n    Lorem");
        expect_position(12);
    }
}
