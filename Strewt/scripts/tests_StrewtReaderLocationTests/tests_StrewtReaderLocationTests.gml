function StrewtReaderLocationTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Reader location";
    
    static when_location_retrieved = function() {
        when(reader.get_location());
    }
    
    static when_location_updated = function(_line, _column, _position) {
        var _location = new StrewtLocation(_line, _column, _position);
        when(reader.update_location(_location));
    }
    
    static then_expect_location = function(_line, _column, _position) {
        assert_equal(_line, result.line);
        assert_equal(_column, result.column);
        assert_equal(_position, result.position);
    }
    
    // -----
    // Tests
    // -----
    
    static should_handle_initial_position = function() {
         given_content("Lorem ipsum");
         when_location_retrieved();
         then_expect_location(/* line */ 1, /* column */ 1, /* position*/ 0);
    }
    
    static should_handle_starting_line_middle_column = function() {
         given_content("Lorem ipsum");
         given_position(5);
         when_location_retrieved();
         then_expect_location(/* line */ 1, /* column */ 6, /* position*/ 5);
    }
    
    // Newlines
    
    static should_handle_lf_as_newline = function() {
        given_content("Lorem\nipsum");
        given_position(8);
        when_location_retrieved();
        then_expect_location(/* line */ 2, /* column */ 3, /* position*/ 8);
    }
    
    static should_handle_cr_as_newline = function() {
        given_content("Lorem\ripsum");
        given_position(8);
        when_location_retrieved();
        then_expect_location(/* line */ 2, /* column */ 3, /* position*/ 8);
    }
    
    static should_handle_crlf_as_single_line = function() {
        given_content("Lorem\r\nipsum");
        given_position(8);
        when_location_retrieved();
        then_expect_location(/* line */ 2, /* column */ 2, /* position*/ 8);
    }
    
    static should_handle_lfcr_as_two_lines = function() {
        given_content("Lorem\n\ripsum");
        given_position(8);
        when_location_retrieved();
        then_expect_location(/* line */ 3, /* column */ 2, /* position*/ 8);
    }
    
    static should_treat_cr_as_newline_before_non_lf = function() {
        given_content("Lorem\ripsum");
        given_position(6);
        when_location_retrieved();
        then_expect_location(/* line */ 2, /* column */ 1, /* position*/ 6);
    }
    
    static should_treat_cr_as_whitespace_before_lf = function() {
        given_content("Lorem\r\nipsum");
        given_position(6);
        when_location_retrieved();
        then_expect_location(/* line */ 1, /* column */ 7, /* position*/ 6);
    }
    
    static should_treat_cr_as_newline_on_end = function() {
        given_content("Lorem\r");
        given_position(6);
        when_location_retrieved();
        then_expect_location(/* line */ 2, /* column */ 1, /* position*/ 6);
    }
    
    // Unicode characters
    
    static should_treat_multibyte_characters_as_single_character = function() {
        given_content("Zażółć gęślą jaźń");
        given_position(6);
        when_location_retrieved();
        then_expect_location(/* line */ 1, /* column */ 5, /* position*/ 6);
    }
    
    static should_handle_unicode_characters_and_newlines = function() {
        given_content("Zażółć\ngęślą jaźń");
        given_position(16);
        when_location_retrieved();
        then_expect_location(/* line */ 2, /* column */ 4, /* position*/ 16);
    }
    
    // Updates
    
    static should_update_location_from_start = function() {
        given_content("Lorem\nipsum\ndolor");
        given_position(8);
        when_location_updated(1, 1, 0);
        then_expect_location(/* line */ 2, /* column */ 3, /* position*/ 8);
    }
    
    static should_update_location_from_middle = function() {
        given_content("Lorem\nipsum\ndolor");
        given_position(15);
        when_location_updated(2, 3, 8);
        then_expect_location(/* line */ 3, /* column */ 4, /* position*/ 15);
    }
    
    static should_update_location_from_same_position = function() {
        given_content("Lorem\nipsum\ndolor");
        given_position(8);
        when_location_updated(2, 3, 8);
        then_expect_location(/* line */ 2, /* column */ 3, /* position*/ 8);
    }
    
    static should_update_location_from_later_position = function() {
        given_content("Lorem\nipsum\ndolor");
        given_position(3);
        when_location_updated(2, 3, 8);
        then_expect_location(/* line */ 1, /* column */ 4, /* position*/ 3);
    }
}
