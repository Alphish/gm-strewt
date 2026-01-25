function StrewtReaderCharsetTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Charset byte reading";
    
    // ----
    // Skip
    // ----
    
    static should_not_skip_on_empty_string = function() {
        given_content("");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_skip(_charset, false, 0);
    }
    
    static should_skip_charset_byte = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_skip(_charset, true, 1);
    }
    
    static should_skip_charset_bytes_upon_repetition = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_skip(_charset, true, 1);
        assert_charset_skip(_charset, true, 2);
        assert_charset_skip(_charset, true, 3);
        assert_charset_skip(_charset, false, 3);
    }
    
    static should_skip_charset_bytes_until_end = function() {
        given_content("123");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_skip(_charset, true, 1);
        assert_charset_skip(_charset, true, 2);
        assert_charset_skip(_charset, true, 3);
        assert_charset_skip(_charset, false, 3);
    }
    
    static should_not_skip_before_unmatching_byte = function() {
        given_content("Lorem ipsum");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_skip(_charset, false, 0);
    }
    
    static should_skip_whole_string_with_different_charsets = function() {
        given_content("1+19=20");
        var _digits = new StrewtCharset().including_range("0", "9");
        var _operators = new StrewtCharset().including("+-=");
        
        assert_charset_skip(_digits, true, 1);
        assert_charset_skip(_digits, false, 1);
        
        assert_charset_skip(_operators, true, 2);
        assert_charset_skip(_operators, false, 2);
        
        assert_charset_skip(_digits, true, 3);
        assert_charset_skip(_digits, true, 4);
        assert_charset_skip(_digits, false, 4);
        
        assert_charset_skip(_operators, true, 5);
        assert_charset_skip(_operators, false, 5);
        
        assert_charset_skip(_digits, true, 6);
        assert_charset_skip(_digits, true, 7);
        assert_charset_skip(_digits, false, 7);
        assert_charset_skip(_operators, false, 7);
    }
    
    // ----
    // Peek
    // ----
    
    static should_peek_zero_byte_on_empty_string = function() {
        given_content("");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_peek(_charset, 0, 0);
    }
    
    static should_peek_charset_byte = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_peek(_charset, 49, 0);
    }
    
    static should_peek_again_upon_repetition = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_peek(_charset, 49, 0);
        assert_charset_peek(_charset, 49, 0);
    }
    
    static should_peek_zero_byte_before_unmatching_bytes = function() {
        given_content("Lorem ipsum");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_peek(_charset, 0, 0);
    }
    
    static should_peek_byte_from_middle = function() {
        given_content("AREA12345");
        var _charset = new StrewtCharset().including_range("0", "9");
        reader.move_to(6);
        assert_charset_peek(_charset, 51, 6);
    }
    
    // ----
    // Read
    // ----
    
    static should_read_zero_byte_on_empty_string = function() {
        given_content("");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_read(_charset, 0, 0);
    }
    
    static should_read_charset_byte = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_read(_charset, 49, 1);
    }
    
    static should_read_charset_bytes_upon_repetition = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_read(_charset, 49, 1);
        assert_charset_read(_charset, 50, 2);
        assert_charset_read(_charset, 51, 3);
        assert_charset_read(_charset, 0, 3);
    }
    
    static should_read_charset_bytes_until_end = function() {
        given_content("123");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_read(_charset, 49, 1);
        assert_charset_read(_charset, 50, 2);
        assert_charset_read(_charset, 51, 3);
        assert_charset_read(_charset, 0, 3);
    }
    
    static should_not_read_before_unmatching_byte = function() {
        given_content("Lorem ipsum");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_read(_charset, 0, 0);
    }
    
    static should_read_whole_string_with_different_charsets = function() {
        given_content("1+19=20");
        var _digits = new StrewtCharset().including_range("0", "9");
        var _operators = new StrewtCharset().including("+-=");
        
        assert_charset_read(_digits, 49, 1);
        assert_charset_read(_digits, 0, 1);
        
        assert_charset_read(_operators, 43, 2);
        assert_charset_read(_operators, 0, 2);
        
        assert_charset_read(_digits, 49, 3);
        assert_charset_read(_digits, 57, 4);
        assert_charset_read(_digits, 0, 4);
        
        assert_charset_read(_operators, 61, 5);
        assert_charset_read(_operators, 0, 5);
        
        assert_charset_read(_digits, 50, 6);
        assert_charset_read(_digits, 48, 7);
        assert_charset_read(_digits, 0, 7);
        assert_charset_read(_operators, 0, 7);
    }
    
    // ------
    // Helper
    // ------
    
    static assert_charset_skip = function(_charset, _result, _position) {
        assert_equal(_result, reader.try_skip_charset(_charset));
        assert_equal(_position, reader.get_position());
        assert_equal(_position, buffer_tell(reader.content_buffer));
    }
    
    static assert_charset_peek = function(_charset, _result, _position) {
        assert_equal(_result, reader.try_peek_charset(_charset));
        assert_equal(_position, reader.get_position());
        assert_equal(_position, buffer_tell(reader.content_buffer));
    }
    
    static assert_charset_read = function(_charset, _result, _position) {
        assert_equal(_result, reader.try_read_charset(_charset));
        assert_equal(_position, reader.get_position());
        assert_equal(_position, buffer_tell(reader.content_buffer));
    }
}
