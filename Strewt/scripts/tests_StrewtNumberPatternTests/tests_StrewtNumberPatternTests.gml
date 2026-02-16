function StrewtNumberPatternTests(_run, _method) : StrewtPatternBaseTest(_run, _method) constructor {
    pattern = new StrewtNumberPattern();
    
    original_epsilon = math_get_epsilon();
    math_set_epsilon(0);
    
    static should_not_read_empty_string = function() {
        given_content("");
        when_read();
        expect_no_result();
    }
    
    static should_read_zero = function() {
        given_content("0");
        when_read();
        expect_number(0);
    }
    
    static should_read_plain_integer = function() {
        given_content("123");
        when_read();
        expect_number(123);
    }
    
    static should_read_42_apples = function() {
        given_content("42 apples");
        when_read();
        expect_number(42);
    }
    
    static should_read_positive_integer = function() {
        given_content("+123");
        when_read();
        expect_number(123);
    }
    
    static should_read_negative_integer = function() {
        given_content("-456");
        when_read();
        expect_number(-456);
    }
    
    static should_not_read_sign_alone = function() {
        given_content("+");
        when_read();
        expect_no_result();
    }
    
    static should_read_fraction = function() {
        given_content("3.14");
        when_read();
        expect_number(3.14);
    }
    
    static should_not_read_trailing_decimal_point = function() {
        given_content("123.");
        when_read();
        expect_no_result();
    }
    
    static should_read_unsigned_exponent = function() {
        given_content("9e3");
        when_read();
        expect_number(9000);
    }
    
    static should_read_positive_exponent = function() {
        given_content("9E+3");
        when_read();
        expect_number(9000);
    }
    
    static should_read_negative_exponent = function() {
        given_content("123E-12");
        when_read();
        expect_number(0.000000000123);
    }
    
    static should_not_read_trailing_exponent = function() {
        given_content("123E");
        when_read();
        expect_no_result();
    }
    
    static should_read_scientific_notation = function() {
        given_content("+2.998e8");
        when_read();
        expect_number(299800000);
    }
    
    // -------
    // Helpers
    // -------
    
    static expect_number = function(_value) {
        assert_equal(_value, real(result));
    }
    
    static test_cleanup = function() {
        if (!is_undefined(reader))
            reader.cleanup();
        
        math_set_epsilon(original_epsilon);
    }
}
