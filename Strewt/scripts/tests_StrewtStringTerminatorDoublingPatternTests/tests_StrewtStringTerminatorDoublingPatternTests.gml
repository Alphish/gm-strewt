function StrewtStringTerminatorDoublingPatternTests(_run, _method) : StrewtPatternBaseTest(_run, _method) constructor {
    static test_subject = "Terminator doubling string pattern";
    
    pattern = new StrewtStringTerminatorDoublingPattern();
    
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
    
    // -------------
    // Special cases
    // -------------
    
    static should_handle_string_with_escapes = function() {
        given_content("\"This is \"\"The Title\"\"\"");
        when_pattern_tested();
        
        then_expect_span(23, 19);
        then_expect_string("\"This is \"\"The Title\"\"\"", "This is \"The Title\"");
        then_expect_positions(0, 23);
    }
    
    static should_handle_various_characters_as_is = function() {
        given_content("\"Zażółć\r\ngęślą\r\njaźń\"");
        when_pattern_tested();
        
        then_expect_span(30, 28);
        then_expect_string("\"Zażółć\r\ngęślą\r\njaźń\"", "Zażółć\r\ngęślą\r\njaźń");
        then_expect_positions(0, 30);
    }
    
    static should_ignore_string_with_closing_terminator_escaped = function() {
        given_content("\"Lorem ipsum\"\"");
        when_pattern_tested();
        
        then_expect_span(0, 0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_basic_string_with_custom_terminator = function() {
        given_content("'Lorem ipsum'");
        given_pattern(new StrewtStringTerminatorDoublingPattern("'"));
        when_pattern_tested();
        
        then_expect_span(13, 11);
        then_expect_string("'Lorem ipsum'", "Lorem ipsum");
        then_expect_positions(0, 13);
    }
    
    static should_handle_escaped_string_with_custom_terminator = function() {
        given_content("'Nice weather, isn''t it?'");
        given_pattern(new StrewtStringTerminatorDoublingPattern("'"));
        when_pattern_tested();
        
        then_expect_span(26, 23);
        then_expect_string("'Nice weather, isn''t it?'", "Nice weather, isn't it?");
        then_expect_positions(0, 26);
    }
}
