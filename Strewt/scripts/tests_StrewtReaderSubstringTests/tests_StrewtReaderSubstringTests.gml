function StrewtReaderSubstringTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "peek_substring method";
    
    static should_read_empty_string = function() {
        given_content("Hello, world!");
        assert_equal("", reader.peek_substring(3, 3));
    }
    
    static should_read_single_character = function() {
        given_content("Hello, world!");
        assert_equal("l", reader.peek_substring(3, 4));
    }
    
    static should_read_start_substring = function() {
        given_content("Hello, world!");
        assert_equal("Hell", reader.peek_substring(0, 4));
    }
    
    static should_read_middle_substring = function() {
        given_content("Hello, world!");
        assert_equal("lo, wo", reader.peek_substring(3, 9));
    }
    
    static should_read_end_substring = function() {
        given_content("Hello, world!");
        assert_equal("ld!", reader.peek_substring(10, 13));
    }
    
    static should_read_whole_string = function() {
        given_content("Hello, world!");
        assert_equal("Hello, world!", reader.peek_substring(0, 13));
    }
    
    static should_read_multibyte_character = function() {
        given_content("Zażółć gęślą jaźń");
        assert_equal("ż", reader.peek_substring(2, 4));
    }
}
