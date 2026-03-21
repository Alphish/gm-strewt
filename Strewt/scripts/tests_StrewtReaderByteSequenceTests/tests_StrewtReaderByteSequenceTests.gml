function StrewtReaderByteSequenceTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Byte sequence checking";
    
    // -----
    // Setup
    // -----
    
    byte_sequence = undefined;
    static given_byte_sequence = function(_arr) {
        byte_sequence = _arr;
    }
    
    static when_spanned = function() {
        return reader.span_byte_sequence(byte_sequence);
    }
    
    static when_skipped = function() {
        return reader.try_skip_byte_sequence(byte_sequence);
    }
    
    static when_peeked = function() {
        return undefined;
    }
    
    static when_read = function() {
        return undefined;
    }
    
    static when_read_into_target = function(_target, _offset = undefined) {
        return is_undefined(_offset)
            ? reader.try_read_byte_sequence_into(byte_sequence, _target)
            : reader.try_read_byte_sequence_into(byte_sequence, _target, _offset);
    }
    
    // --------
    // Skipping
    // --------
    
    static should_ignore_sequence_on_empty_string = function() {
        given_content("");
        given_byte_sequence([49, 50, 51]);
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_single_byte_sequence_when_matched = function() {
        given_content("12345");
        given_byte_sequence([49]);
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_string("1");
        then_expect_positions(0, 1);
    }
    
    static should_handle_sequence_when_matching = function() {
        given_content("12345");
        given_byte_sequence([49, 50, 51]);
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("123");
        then_expect_positions(0, 3);
    }
    
    static should_handle_sequence_matching_whole_string = function() {
        given_content("12345");
        given_byte_sequence([49, 50, 51, 52, 53]);
        when_method_family_tested();
        
        then_expect_span(5);
        then_expect_string("12345");
        then_expect_positions(0, 5);
    }
    
    static should_ignore_sequence_when_not_matched = function() {
        given_content("ABCDE");
        given_byte_sequence([49, 50, 51]);
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_ignore_sequence_when_not_fully_matched = function() {
        given_content("1290");
        given_byte_sequence([49, 50, 51]);
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_matching_sequence_in_the_middle = function() {
        given_content("112358");
        given_position(1);
        given_byte_sequence([49, 50, 51]);
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("123");
        then_expect_positions(1, 4);
    }
}
