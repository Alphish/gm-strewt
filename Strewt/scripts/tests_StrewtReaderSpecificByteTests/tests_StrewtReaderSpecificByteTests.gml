function StrewtReaderSpecificByteTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Specific byte checking";
    
    // -----
    // Setup
    // -----
    
    byte = undefined;
    static given_byte = function(_byte) {
        byte = _byte;
    }
    
    static when_spanned = function() {
        return reader.span_byte(byte);
    }
    
    static when_skipped = function() {
        return reader.try_skip_byte(byte);
    }
    
    static when_peeked = function() {
        return undefined;
    }
    
    static when_read = function() {
        return undefined;
    }
    
    static when_read_into_target = function(_target, _offset = undefined) {
        return is_undefined(_offset)
            ? reader.try_read_byte_into(byte, _target)
            : reader.try_read_byte_into(byte, _target, _offset);
    }
    
    // -----
    // Tests
    // -----
    
    static should_ignore_specific_byte_on_empty_string = function() {
        given_content("");
        given_byte(49);
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_specific_byte_when_matched = function() {
        given_content("123");
        given_byte(49);
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_string("1");
        then_expect_positions(0, 1);
    }
    
    static should_ignore_specific_byte_when_unmatched = function() {
        given_content("123");
        given_byte(65);
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_specific_byte_in_the_middle = function() {
        given_content("12345");
        given_position(3);
        given_byte(52);
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_string("4");
        then_expect_positions(3, 4);
    }
}
