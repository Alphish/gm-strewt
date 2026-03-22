function StrewtNumberPatternTests(_run, _method) : StrewtPatternBaseTest(_run, _method) constructor {
    static test_subject = "Number pattern";
    
    pattern = new StrewtNumberPattern();
    
    original_epsilon = math_get_epsilon();
    math_set_epsilon(0);
    
    static should_ignore_empty_string = function() {
        given_content("");
        when_pattern_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_ignore_non_numeric_characters = function() {
        given_content("ABC");
        when_pattern_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_zero = function() {
        given_content("0");
        when_pattern_tested();
        
        then_expect_span(1);
        then_expect_number(0);
        then_expect_positions(0, 1);
    }
    
    static should_handle_plain_integer = function() {
        given_content("123");
        when_pattern_tested();
        
        then_expect_span(3);
        then_expect_number(123);
        then_expect_positions(0, 3);
    }
    
    static should_handle_42_apples = function() {
        given_content("42 apples");
        when_pattern_tested();
        
        then_expect_span(2);
        then_expect_number(42);
        then_expect_positions(0, 2);
    }
    
    static should_handle_integer_from_middle = function() {
        given_content("AREA 51");
        given_position(5);
        when_pattern_tested();
        
        then_expect_span(2);
        then_expect_number(51);
        then_expect_positions(5, 7);
    }
    
    static should_handle_positive_integer = function() {
        given_content("+123");
        when_pattern_tested();
        
        then_expect_span(4);
        then_expect_number(123);
        then_expect_positions(0, 4);
    }
    
    static should_handle_negative_integer = function() {
        given_content("-456");
        when_pattern_tested();
        
        then_expect_span(4);
        then_expect_number(-456);
        then_expect_positions(0, 4);
    }
    
    static should_ignore_sign_alone = function() {
        given_content("+");
        when_pattern_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_fraction = function() {
        given_content("3.14");
        when_pattern_tested();
        
        then_expect_span(4);
        then_expect_number(3.14);
        then_expect_positions(0, 4);
    }
    
    static should_ignore_trailing_decimal_point = function() {
        given_content("123.");
        when_pattern_tested();
        
        then_expect_span(3);
        then_expect_number(123);
        then_expect_positions(0, 3);
    }
    
    static should_handle_unsigned_exponent = function() {
        given_content("9e3");
        when_pattern_tested();
        
        then_expect_span(3);
        then_expect_number(9000);
        then_expect_positions(0, 3);
    }
    
    static should_handle_positive_exponent = function() {
        given_content("9E+3");
        when_pattern_tested();
        
        then_expect_span(4);
        then_expect_number(9000);
        then_expect_positions(0, 4);
    }
    
    static should_handle_negative_exponent = function() {
        given_content("123E-12");
        when_pattern_tested();
        
        then_expect_span(7);
        then_expect_number(0.000000000123);
        then_expect_positions(0, 7);
    }
    
    static should_ignore_trailing_exponent = function() {
        given_content("123E");
        when_pattern_tested();
        
        then_expect_span(3);
        then_expect_number(123);
        then_expect_positions(0, 3);
    }
    
    static should_ignore_trailing_exponent_with_sign = function() {
        given_content("123E-");
        when_pattern_tested();
        
        then_expect_span(3);
        then_expect_number(123);
        then_expect_positions(0, 3);
    }
    
    static should_handle_scientific_notation = function() {
        given_content("+2.998e8");
        when_pattern_tested();
        
        then_expect_span(8);
        then_expect_number(299800000);
        then_expect_positions(0, 8);
    }
    
    // -------
    // Helpers
    // -------
    
    static then_expect_number = function(_value) {
        assert_equal(_value, real(peek_raw_result), $"Expected peek_raw number to be {_value} but got {real(peek_raw_result)} instead.");
        assert_equal(_value, real(read_raw_result), $"Expected read_raw number to be {_value} but got {real(read_raw_result)} instead.");
        assert_equal(_value, real(peek_result), $"Expected peek number to be {_value} but got {real(peek_result)} instead.");
        assert_equal(_value, real(read_result), $"Expected read number to be {_value} but got {real(read_result)} instead.");
        
        var _unprefixed_read_into_string = string_delete(read_into_string, 1, 6);
        assert_equal(_value, real(_unprefixed_read_into_string), $"Expected read_into number to be {_value} but got {real(_unprefixed_read_into_string)} instead.");
    }
    
    static test_cleanup = function() {
        var _base = method(self, StrewtPatternBaseTest.test_cleanup);
        _base();
        math_set_epsilon(original_epsilon);
    }
}
