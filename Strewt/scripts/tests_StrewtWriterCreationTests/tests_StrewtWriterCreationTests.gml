function StrewtWriterCreationTests(_run, _method) : StrewtWriterBaseTests(_run, _method) constructor{
    static test_subject = "Writer creation";
    
    static should_create_writer_without_arguments = function() {
        given_writer();
        assert_is_true(buffer_exists(writer.content_buffer));
        assert_equal(0, buffer_tell(writer.content_buffer));
    }
    
    static should_create_writer_with_target_buffer = function() {
        var _target = buffer_create(16, buffer_fixed, 1);
        buffer_write(_target, buffer_text, "Lorem");
        
        given_writer(_target);
        assert_equal(_target, writer.content_buffer);
        assert_equal(5, buffer_tell(writer.content_buffer));
    }
    
    static should_fail_to_create_writer_with_non_buffer = function() {
        try {
            given_writer(123);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal(_ex.code, "invalid_type");
        }
    }
    
    static should_write_indent_on_writer_without_arguments = function() {
        given_writer();
        writer.push_indent();
        writer.write("123");
        when_content_collected();
        expect_result("    123");
    }
    
    static should_write_indent_on_blank_target = function() {
        var _target = buffer_create(16, buffer_fixed, 1);
        
        given_writer(_target);
        writer.push_indent();
        writer.write("123");
        when_content_collected();
        expect_result("    123");
    }
    
    static should_not_write_indent_on_target_with_content = function() {
        var _target = buffer_create(16, buffer_fixed, 1);
        buffer_write(_target, buffer_text, "Lorem");
        
        given_writer(_target);
        writer.push_indent();
        writer.write("123");
        when_content_collected();
        expect_result("Lorem123");
    }
    
    static should_write_indent_on_target_with_newline_ending_content = function() {
        var _target = buffer_create(16, buffer_fixed, 1);
        buffer_write(_target, buffer_text, "Lorem\n");
        
        given_writer(_target);
        writer.push_indent();
        writer.write("123");
        when_content_collected();
        expect_result("Lorem\n    123");
    }
}
