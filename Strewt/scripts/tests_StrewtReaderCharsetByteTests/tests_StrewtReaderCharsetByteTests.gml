function StrewtReaderCharsetTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Charset byte checking";
    
    // -----
    // Setup
    // -----
    
    charset = undefined;
    static given_charset = function(_input = undefined) {
        charset = is_undefined(_input) ? new StrewtCharset() : new StrewtCharset(_input);
        return charset;
    }
    
    static when_spanned = function() {
        return reader.span_charset_byte(charset);
    }
    
    static when_skipped = function() {
        return reader.skip_charset_byte(charset);
    }
    
    static when_peeked = function() {
        return reader.peek_charset_byte(charset);
    }
    
    static when_read = function() {
        return reader.read_charset_byte(charset);
    }
    
    static when_read_into_target = function(_target, _offset = undefined) {
        return is_undefined(_offset)
            ? reader.read_charset_byte_into(charset, _target)
            : reader.read_charset_byte_into(charset, _target, _offset);
    }
    
    // -----
    // Tests
    // -----
    
    static should_ignore_charset_on_empty_string = function() {
        given_content("");
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_byte(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_charset_byte_when_matched = function() {
        given_content("123, 456  , 789");
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_byte(49);
        then_expect_string("1");
        then_expect_positions(0, 1);
    }
    
    static should_ignore_charset_when_unmatched = function() {
        given_content("Lorem ipsum");
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_byte(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_charset_byte_from_middle = function() {
        given_content("AREA12345");
        given_position(5)
        given_charset().including_range("0", "9");
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_byte(50);
        then_expect_string("2");
        then_expect_positions(5, 6);
    }
}
