function StrewtWriterValueWritingTests(_run, _method) : StrewtWriterBaseTests(_run, _method) constructor {
    static test_subject = "Value writing";
    
    static should_write_empty_string = function() {
        given_writer();
        writer.write("");
        when_content_collected();
        expect_result("");
        expect_position(0);
    }
    
    static should_write_given_string = function() {
        given_writer();
        writer.write("Lorem ipsum");
        when_content_collected();
        expect_result("Lorem ipsum");
        expect_position(11);
    }
    
    static should_write_given_nonstring = function() {
        given_writer();
        writer.write(123);
        when_content_collected();
        expect_result("123");
        expect_position(3);
    }
    
    static should_write_empty_string_without_indent = function() {
        given_writer();
        writer.push_indent();
        writer.write("");
        when_content_collected();
        expect_result("");
        expect_position(0);
    }
    
    static should_write_string_with_indent = function() {
        given_writer();
        writer.push_indent();
        writer.write("Lorem ipsum");
        when_content_collected();
        expect_result("    Lorem ipsum");
        expect_position(15);
    }
    
    static should_write_nonstring_with_indent = function() {
        given_writer();
        writer.push_indent();
        writer.write(123);
        when_content_collected();
        expect_result("    123");
        expect_position(7);
    }
    
    static should_write_no_indent_after_non_newline_value = function() {
        given_writer();
        writer.push_indent();
        writer.write("123");
        writer.write("456");
        when_content_collected();
        expect_result("    123456");
        expect_position(10);
    }
    
    static should_write_indent_after_newline_value = function() {
        given_writer();
        writer.push_indent();
        writer.write("123\n");
        writer.write("456");
        when_content_collected();
        expect_result("    123\n    456");
        expect_position(15);
    }
}
