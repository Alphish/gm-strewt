function StrewtReaderCharsetStringTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Charset string reading";
    
    // ----
    // Skip
    // ----
    
    static should_skip_empty_string_on_empty_string = function() {
        given_content("");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_skip(_charset, 0);
    }
    
    static should_skip_characters_while_in_charset = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_skip(_charset, 3);
    }
    
    static should_skip_empty_string_upon_repetition = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_skip(_charset, 3);
        assert_charset_string_skip(_charset, 3);
    }
    
    static should_skip_characters_to_end = function() {
        given_content("12345");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_skip(_charset, 5);
    }
    
    static should_skip_empty_string_before_unmatching_characters = function() {
        given_content("Lorem ipsum");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_skip(_charset, 0);
    }
    
    static should_skip_nonascii_characters_until_space = function() {
        given_content("Zażółć gęślą jaźń");
        var _charset = new StrewtCharset(true).excluding(" ");
        assert_charset_string_skip(_charset, 10);
    }
    
    static should_skip_whole_string_with_different_charsets = function() {
        given_content("123, 456  , 789");
        var _spaces = new StrewtCharset().including(" ");
        var _digits = new StrewtCharset().including_range("0", "9");
        var _commas = new StrewtCharset().including(",");
        
        assert_charset_string_skip(_spaces, 0);
        assert_charset_string_skip(_digits, 3);
        assert_charset_string_skip(_spaces, 3);
        
        assert_charset_string_skip(_commas, 4);

        assert_charset_string_skip(_spaces, 5);
        assert_charset_string_skip(_digits, 8);
        assert_charset_string_skip(_spaces, 10);
        
        assert_charset_string_skip(_commas, 11);

        assert_charset_string_skip(_spaces, 12);
        assert_charset_string_skip(_digits, 15);
        assert_charset_string_skip(_spaces, 15);
    }
    
    // ----
    // Peek
    // ----
    
    static should_peek_empty_string_on_empty_string = function() {
        given_content("");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_peek(_charset, "", 0);
    }
    
    static should_peek_characters_while_in_charset = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_peek(_charset, "123", 0);
    }
    
    static should_peek_again_upon_repetition = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_peek(_charset, "123", 0);
        assert_charset_string_peek(_charset, "123", 0);
    }
    
    static should_peek_characters_to_end = function() {
        given_content("12345");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_peek(_charset, "12345", 0);
    }
    
    static should_peek_empty_string_before_unmatching_characters = function() {
        given_content("Lorem ipsum");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_peek(_charset, "", 0);
    }
    
    static should_peek_nonascii_characters_until_space = function() {
        given_content("Zażółć gęślą jaźń");
        var _charset = new StrewtCharset(true).excluding(" ");
        assert_charset_string_peek(_charset, "Zażółć", 0);
    }
    
    static should_peek_charset_from_middle = function() {
        given_content("AREA12345");
        var _charset = new StrewtCharset().including_range("0", "9");
        reader.move_to(6);
        assert_charset_string_peek(_charset, "345", 6);
    }
    
    // ----
    // Read
    // ----
    
    static should_read_empty_string_on_empty_string = function() {
        given_content("");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_read(_charset, "", 0);
    }
    
    static should_read_characters_while_in_charset = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_read(_charset, "123", 3);
    }
    
    static should_read_empty_string_upon_repetition = function() {
        given_content("123, 456  , 789");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_read(_charset, "123", 3);
        assert_charset_string_read(_charset, "", 3);
    }
    
    static should_read_characters_to_end = function() {
        given_content("12345");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_read(_charset, "12345", 5);
    }
    
    static should_read_empty_string_before_unmatching_characters = function() {
        given_content("Lorem ipsum");
        var _charset = new StrewtCharset().including_range("0", "9");
        assert_charset_string_read(_charset, "", 0);
    }
    
    static should_read_nonascii_characters_until_space = function() {
        given_content("Zażółć gęślą jaźń");
        var _charset = new StrewtCharset(true).excluding(" ");
        assert_charset_string_read(_charset, "Zażółć", 10);
    }
    
    static should_read_whole_string_with_different_charsets = function() {
        given_content("123, 456  , 789");
        var _spaces = new StrewtCharset().including(" ");
        var _digits = new StrewtCharset().including_range("0", "9");
        var _commas = new StrewtCharset().including(",");
        
        assert_charset_string_read(_spaces, "", 0);
        assert_charset_string_read(_digits, "123", 3);
        assert_charset_string_read(_spaces, "", 3);
        
        assert_charset_string_read(_commas, ",", 4);

        assert_charset_string_read(_spaces, " ", 5);
        assert_charset_string_read(_digits, "456", 8);
        assert_charset_string_read(_spaces, "  ", 10);
        
        assert_charset_string_read(_commas, ",", 11);

        assert_charset_string_read(_spaces, " ", 12);
        assert_charset_string_read(_digits, "789", 15);
        assert_charset_string_read(_spaces, "", 15);
    }
    
    // ------
    // Helper
    // ------
    
    static assert_charset_string_skip = function(_charset, _position) {
        reader.skip_charset_string(_charset);
        assert_equal(_position, reader.get_position());
        assert_equal(_position, buffer_tell(reader.content_buffer));
    }
    
    static assert_charset_string_peek = function(_charset, _result, _position) {
        assert_equal(_result, reader.peek_charset_string(_charset));
        assert_equal(_position, reader.get_position());
        assert_equal(_position, buffer_tell(reader.content_buffer));
    }
    
    static assert_charset_string_read = function(_charset, _result, _position) {
        assert_equal(_result, reader.read_charset_string(_charset));
        assert_equal(_position, reader.get_position());
        assert_equal(_position, buffer_tell(reader.content_buffer));
    }
}
