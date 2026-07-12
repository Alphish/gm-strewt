function StrewtReaderNextByteTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Next byte checking";
    
    // -----
    // Setup
    // -----
    
    static when_spanned = function() {
        return reader.span_next();
    }
    
    static when_skipped = function() {
        return reader.skip_next();
    }
    
    static when_peeked = function() {
        return reader.peek_next();
    }
    
    static when_read = function() {
        return reader.read_next();
    }
    
    static when_read_into_target = function(_target) {
        return reader.read_next_into(_target);
    }
    
    // -----
    // Tests
    // -----
    
    static should_ignore_next_byte_on_empty_string = function() {
        given_content("");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_next_byte_at_start = function() {
        given_content("12345");
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_string("1");
        then_expect_positions(0, 1);
    }
    
    static should_handle_next_byte_in_the_middle = function() {
        given_content("12345");
        given_position(3);
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_string("4");
        then_expect_positions(3, 4);
    }
    
    static should_ignore_next_byte_at_end = function() {
        given_content("12345");
        given_position(5);
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(5, 5);
    }
}
