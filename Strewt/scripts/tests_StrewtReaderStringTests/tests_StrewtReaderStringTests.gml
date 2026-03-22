function StrewtReaderStringTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "String checking";
    
    // -----
    // Setup
    // -----
    
    str = undefined;
    static given_string = function(_str) {
        str = _str;
    }
    
    static when_spanned = function() {
        return reader.span_string(str);
    }
    
    static when_skipped = function() {
        return reader.skip_string(str);
    }
    
    static when_peeked = function() {
        return undefined;
    }
    
    static when_read = function() {
        return undefined;
    }
    
    static when_read_into_target = function(_target) {
        return reader.read_string_into(str, _target);
    }
    
    // --------
    // Skipping
    // --------
    
    static should_ignore_string_on_empty_string = function() {
        given_content("");
        given_string("123");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_single_string_when_matched = function() {
        given_content("12345");
        given_string("1");
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_string("1");
        then_expect_positions(0, 1);
    }
    
    static should_handle_string_when_matching = function() {
        given_content("12345");
        given_string("123");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("123");
        then_expect_positions(0, 3);
    }
    
    static should_handle_string_matching_whole_string = function() {
        given_content("12345");
        given_string("12345");
        when_method_family_tested();
        
        then_expect_span(5);
        then_expect_string("12345");
        then_expect_positions(0, 5);
    }
    
    static should_ignore_string_when_not_matched = function() {
        given_content("ABCDE");
        given_string("123");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_ignore_string_when_not_fully_matched = function() {
        given_content("1290");
        given_string("123");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_matching_string_in_the_middle = function() {
        given_content("112358");
        given_position(1);
        given_string("123");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("123");
        then_expect_positions(1, 4);
    }
}
