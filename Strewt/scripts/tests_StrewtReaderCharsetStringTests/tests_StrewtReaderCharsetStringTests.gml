function StrewtReaderCharsetStringTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Charset string reading";
    
    // -----
    // Setup
    // -----
    
    charset = undefined;
    static given_charset = function(_input = undefined) {
        charset = is_undefined(_input) ? new StrewtCharset() : new StrewtCharset(_input);
        return charset;
    }
    
    static when_spanned = function() {
        return reader.span_charset_string(charset);
    }
    
    static when_skipped = function() {
        return reader.skip_charset_string(charset);
    }
    
    static when_peeked = function() {
        return reader.peek_charset_string(charset);
    }
    
    static when_read = function() {
        return reader.read_charset_string(charset);
    }
    
    static when_read_into_target = function(_target, _offset = undefined) {
        return is_undefined(_offset)
            ? reader.read_charset_string_into(charset, _target)
            : reader.read_charset_string_into(charset, _target, _offset);
    }
    
    // -----
    // Tests
    // -----
    
    static should_ignore_empty_string = function() {
        given_content("");
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_matched_characters_from_start = function() {
        given_content("123, 456  , 789");
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("123");
        then_expect_positions(0, 3);
    }
    
    static should_ignore_unmatched_characters_from_start = function() {
        given_content("Lorem ipsum");
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_matched_characters_from_middle = function() {
        given_content("123, 4567, 89");
        given_position(5);
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(4);
        then_expect_string("4567");
        then_expect_positions(5, 9);
    }
    
    static should_ignore_unmatched_characters_from_middle = function() {
        given_content("123, 4567, 89");
        given_position(3);
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(3, 3);
    }
    
    static should_handle_entire_matched_string = function() {
        given_content("12345");
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(5);
        then_expect_string("12345");
        then_expect_positions(0, 5);
    }
    
    static should_handle_matched_nonascii_characters_until_space = function() {
        given_content("Zażółć gęślą jaźń");
        given_charset(/* default */ true).excluding(" ");
        when_method_family_tested();
        
        then_expect_span(10);
        then_expect_string("Zażółć");
        then_expect_positions(0, 10);
    }
}
