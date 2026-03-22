function StrewtStringCharacterEscapePatternTests(_run, _method) : StrewtPatternBaseTest(_run, _method) constructor {
    static test_subject = "Character escape string pattern";
    
    pattern = new StrewtStringCharacterEscapePattern().with_json_escapes();
    
    // ------
    // Basics
    // ------
    
    static should_ignore_empty_string = function() {
        given_content("");
        when_pattern_tested();
        
        then_expect_span(0, 0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_ignore_string_without_opening_terminator = function() {
        given_content("Lorem ipsum");
        when_pattern_tested();
        
        then_expect_span(0, 0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_ignore_string_without_closing_terminator = function() {
        given_content("\"Lorem ipsum");
        when_pattern_tested();
        
        then_expect_span(0, 0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_empty_string_representation = function() {
        given_content("\"\"");
        when_pattern_tested();
        
        then_expect_span(2, 0);
        then_expect_string("\"\"", "");
        then_expect_positions(0, 2);
    }
    
    static should_handle_basic_string_representation = function() {
        given_content("\"Lorem ipsum\"");
        when_pattern_tested();
        
        then_expect_span(13, 11);
        then_expect_string("\"Lorem ipsum\"", "Lorem ipsum");
        then_expect_positions(0, 13);
    }
    
    static should_handle_basic_string_with_added_content = function() {
        given_content("\"Lorem ipsum\" + \"Dolor sit\"");
        when_pattern_tested();
        
        then_expect_span(13, 11);
        then_expect_string("\"Lorem ipsum\"", "Lorem ipsum");
        then_expect_positions(0, 13);
    }
    
    static should_handle_basic_string_from_middle = function() {
        given_content("\"Lorem ipsum\" + \"Dolor sit\"");
        given_position(16);
        when_pattern_tested();
        
        then_expect_span(11, 9);
        then_expect_string("\"Dolor sit\"", "Dolor sit");
        then_expect_positions(16, 27);
    }
    
    // ---------------
    // Default escapes
    // ---------------
    
    static should_handle_string_with_escaped_terminator = function() {
        given_content("\"This is \\\"The Title\\\"\"");
        when_pattern_tested();
        
        then_expect_span(23, 19);
        then_expect_string("\"This is \\\"The Title\\\"\"", "This is \"The Title\"");
        then_expect_positions(0, 23);
    }
    
    static should_ignore_string_with_closing_terminator_escaped = function() {
        given_content("\"Lorem ipsum\\\"");
        when_pattern_tested();
        
        then_expect_span(0, 0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_string_with_escaped_escape = function() {
        given_content("\"C:\\\\Program Files\\\\Stuff\"");
        when_pattern_tested();
        
        then_expect_span(26, 22);
        then_expect_string("\"C:\\\\Program Files\\\\Stuff\"", "C:\\Program Files\\Stuff");
        then_expect_positions(0, 26);
    }
    
    static should_read_string_with_direct_escapes = function() {
        given_content("\"\\h\\e\\l\\l\\o\"");
        when_pattern_tested();
        
        then_expect_span(12, 5);
        then_expect_string("\"\\h\\e\\l\\l\\o\"", "hello");
        then_expect_positions(0, 12);
    }
    
    // ------------
    // JSON escapes
    // ------------
    
    static should_handle_string_with_foreslashes = function() {
        given_content("\"http://example.com\\/test\"");
        when_pattern_tested();
        
        then_expect_span(26, 23);
        then_expect_string("\"http://example.com\\/test\"", "http://example.com/test");
        then_expect_positions(0, 26);
    }
    
    static should_handle_string_with_newline_representation = function() {
        given_content("\"Lorem\\r\\nIpsum\"");
        when_pattern_tested();
        
        then_expect_span(16, 12);
        then_expect_string("\"Lorem\\r\\nIpsum\"", "Lorem\r\nIpsum");
        then_expect_positions(0, 16);
    }
    
    static should_handle_string_with_miscellaneous_json_escapes = function() {
        given_content("\"This is tab: \\t; This is form feed: \\f; This is backspace: \\b\"");
        when_pattern_tested();
        
        then_expect_span(63, 58);
        then_expect_string("\"This is tab: \\t; This is form feed: \\f; This is backspace: \\b\"", "This is tab: \t; This is form feed: \f; This is backspace: \b");
        then_expect_positions(0, 63);
    }
    
    static should_handle_string_with_unicode_escape = function() {
        given_content("\"You are the star! \\u2606\"");
        when_pattern_tested();
        
        then_expect_span(26, 21);
        then_expect_string("\"You are the star! \\u2606\"", "You are the star! ☆");
        then_expect_positions(0, 26);
    }
    
    static should_handle_string_with_unicode_mixed_case_escape = function() {
        given_content("\"\\u4Ab1\"");
        when_pattern_tested();
        
        then_expect_span(8, 3);
        then_expect_string("\"\\u4Ab1\"", "䪱");
        then_expect_positions(0, 8);
    }
    
    static should_ignore_invalid_unicode_escape = function() {
        given_content("\"Lorem ipsum \\u26xx\"");
        when_pattern_tested();
        
        then_expect_span(0, 0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    // ------------------
    // Custom terminators
    // ------------------
    
    static should_handle_basic_string_with_custom_terminator = function() {
        given_content("'Lorem ipsum'");
        given_pattern(new StrewtStringCharacterEscapePattern("'").with_json_escapes());
        when_pattern_tested();
        
        then_expect_span(13, 11);
        then_expect_string("'Lorem ipsum'", "Lorem ipsum");
        then_expect_positions(0, 13);
    }
    
    static should_handle_escaped_string_with_custom_terminator = function() {
        given_content("'Nice weather, isn\\'t it?'");
        given_pattern(new StrewtStringCharacterEscapePattern("'").with_json_escapes());
        when_pattern_tested();
        
        then_expect_span(26, 23);
        then_expect_string("'Nice weather, isn\\'t it?'", "Nice weather, isn't it?");
        then_expect_positions(0, 26);
    }
    
    // --------------
    // Custom escapes
    // --------------
    
    static should_read_string_with_custom_escape = function() {
        given_content("\"One & Other \\& Another\"");
        pattern.with_custom_escape("&", "and");
        when_pattern_tested();
        
        then_expect_span(24, 23);
        then_expect_string("\"One & Other \\& Another\"", "One & Other and Another");
        then_expect_positions(0, 24);
    }
    
    static should_reject_invalid_custom_escape_when_skipping = function() {
        pattern.with_custom_escape("!", { text: "ESCAPE" });
        given_content("\"This is invalid escape: \\!\"");
        try {
            reader.skip_pattern(pattern);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("invalid_escape", _ex.code);
        }
    }
    
    static should_reject_invalid_custom_escape_when_reading = function() {
        pattern.with_custom_escape("!", { text: "ESCAPE" });
        given_content("\"This is invalid escape: \\!\"");
        try {
            reader.read_pattern(pattern);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("invalid_escape", _ex.code);
        }
    }
}
