function StrewtReaderTargetCopyTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "read_into target";
    
    target = buffer_create(10, buffer_grow, 1);
    
    static should_not_copy_anything_given_zero_span = function() {
        given_content("ld!lo, Helwor");
        when(reader.read_into(0, 0, target));
        when_target_terminated();
        expect_result_position(0, 0);
        expect_target_text("");
    }
    
    static should_not_copy_anything_given_negative_span = function() {
        given_content("ld!lo, Helwor");
        when(reader.read_into(0, -3, target));
        when_target_terminated();
        expect_result_position(0, 0);
        expect_target_text("");
    }
    
    static should_copy_some_text_from_start = function() {
        given_content("ld!lo, Helwor");
        when(reader.read_into(0, 3, target));
        when_target_terminated();
        expect_result_position(3, 0);
        expect_target_text("ld!");
    }
    
    static should_copy_some_text_from_middle = function() {
        given_content("ld!lo, Helwor");
        when(reader.read_into(3, 4, target));
        when_target_terminated();
        expect_result_position(4, 0);
        expect_target_text("lo, ");
    }
    
    static should_copy_some_text_from_end = function() {
        given_content("ld!lo, Helwor");
        when(reader.read_into(10, 3, target));
        when_target_terminated();
        expect_result_position(3, 0);
        expect_target_text("wor");
    }
    
    static should_copy_text_multiple_times = function() {
        given_content("ld!lo, Helwor");
        when(reader.read_into(7, 3, target));
        when(reader.read_into(3, 4, target));
        when(reader.read_into(10, 3, target));
        when(reader.read_into(0, 3, target));
        when_target_terminated();
        expect_result_position(3, 0);
        expect_target_text("Hello, world!");
    }
    
    static when_target_terminated = function() {
        buffer_write(target, buffer_u8, 0);
    }
    
    static expect_target_text = function(_expected) {
        var _actual = buffer_peek(target, 0, buffer_string);
        assert_equal(_expected, _actual);
    }
    
    static test_cleanup = function() {
        if (!is_undefined(reader))
            reader.cleanup();
        
        buffer_delete(target);
    }
}
