function StrewtMultigraphTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    static test_subject = "Strewt multigraph function";
    
    multigraph_function = undefined;
    multigraph_input = undefined;
    result = undefined;
    exception = undefined;
    
    // Byte
    
    static should_create_byte_from_valid_string = function() {
        given_multigraph_function(strewt_byte);
        given_input("1");
        when_multigraph_created();
        then_expect_value(49);
    }
    
    static should_create_byte_from_number = function() {
        given_multigraph_function(strewt_byte);
        given_input(123);
        when_multigraph_created();
        then_expect_value(123);
    }
    
    static should_fail_to_create_byte_from_non_string = function() {
        given_multigraph_function(strewt_byte);
        given_input([]);
        when_multigraph_creation_attempted();
        then_expect_exception("invalid_type", "a string or a number")
    }
    
    static should_fail_to_create_byte_from_too_short_string = function() {
        given_multigraph_function(strewt_byte);
        given_input("");
        when_multigraph_creation_attempted();
        then_expect_exception("multigraph_invalid_length", "byte")
    }
    
    static should_fail_to_create_byte_from_too_long_string = function() {
        given_multigraph_function(strewt_byte);
        given_input("12");
        when_multigraph_creation_attempted();
        then_expect_exception("multigraph_invalid_length", "byte")
    }
    
    // Digraph
    
    static should_create_digraph_from_valid_string = function() {
        given_multigraph_function(strewt_digraph);
        given_input("++");
        when_multigraph_created();
        then_expect_value(11051);
    }
    
    static should_create_digraph_from_number = function() {
        given_multigraph_function(strewt_digraph);
        given_input(12345);
        when_multigraph_created();
        then_expect_value(12345);
    }
    
    static should_fail_to_create_digraph_from_non_string = function() {
        given_multigraph_function(strewt_digraph);
        given_input([]);
        when_multigraph_creation_attempted();
        then_expect_exception("invalid_type", "a string or a number")
    }
    
    static should_fail_to_create_digraph_from_too_short_string = function() {
        given_multigraph_function(strewt_digraph);
        given_input("e");
        when_multigraph_creation_attempted();
        then_expect_exception("multigraph_invalid_length", "digraph")
    }
    
    static should_fail_to_create_digraph_from_too_long_string = function() {
        given_multigraph_function(strewt_digraph);
        given_input("elo");
        when_multigraph_creation_attempted();
        then_expect_exception("multigraph_invalid_length", "digraph")
    }
    
    // Trigraph
    
    static should_create_trigraph_from_valid_string = function() {
        given_multigraph_function(strewt_trigraph);
        given_input("??=");
        when_multigraph_created();
        then_expect_value(4013887);
    }
    
    static should_create_trigraph_from_number = function() {
        given_multigraph_function(strewt_trigraph);
        given_input(123456);
        when_multigraph_created();
        then_expect_value(123456);
    }
    
    static should_fail_to_create_trigraph_from_non_string = function() {
        given_multigraph_function(strewt_trigraph);
        given_input([]);
        when_multigraph_creation_attempted();
        then_expect_exception("invalid_type", "a string or a number")
    }
    
    static should_fail_to_create_trigraph_from_too_short_string = function() {
        given_multigraph_function(strewt_trigraph);
        given_input("??");
        when_multigraph_creation_attempted();
        then_expect_exception("multigraph_invalid_length", "trigraph")
    }
    
    static should_fail_to_create_trigraph_from_too_long_string = function() {
        given_multigraph_function(strewt_trigraph);
        given_input("/***");
        when_multigraph_creation_attempted();
        then_expect_exception("multigraph_invalid_length", "trigraph")
    }
    
    // Tetragraph
    
    static should_create_tetragraph_from_valid_string = function() {
        given_multigraph_function(strewt_tetragraph);
        given_input("else");
        when_multigraph_created();
        then_expect_value(1702063205);
    }
    
    static should_create_tetragraph_from_number = function() {
        given_multigraph_function(strewt_tetragraph);
        given_input(7654321);
        when_multigraph_created();
        then_expect_value(7654321);
    }
    
    static should_fail_to_create_tetragraph_from_non_string = function() {
        given_multigraph_function(strewt_tetragraph);
        given_input([]);
        when_multigraph_creation_attempted();
        then_expect_exception("invalid_type", "a string or a number")
    }
    
    static should_fail_to_create_tetragraph_from_too_short_string = function() {
        given_multigraph_function(strewt_tetragraph);
        given_input("not");
        when_multigraph_creation_attempted();
        then_expect_exception("multigraph_invalid_length", "tetragraph")
    }
    
    static should_fail_to_create_tetragraph_from_too_long_string = function() {
        given_multigraph_function(strewt_tetragraph);
        given_input("class");
        when_multigraph_creation_attempted();
        then_expect_exception("multigraph_invalid_length", "tetragraph")
    }
    
    // -----
    // Setup
    // -----
    
    static given_multigraph_function = function(_func) {
        multigraph_function = _func;
    }
    
    static given_input = function(_str) {
        multigraph_input = _str;
    }
    
    static when_multigraph_created = function() {
        result = multigraph_function(multigraph_input);
    }
    
    static when_multigraph_creation_attempted = function() {
        try {
            result = multigraph_function(multigraph_input);
        } catch (_ex) {
            exception = _ex;
        }
    }
    
    static then_expect_value = function(_value) {
        assert_equal(_value, result);
    }
    
    static then_expect_exception = function(_code, _content) {
        if (is_undefined(exception)) {
            assert_fail($"Expected the multigraph creation to fail, but it didn't.'");
            return;
        }
        
        assert_is_instanceof_struct(StrewtException, exception);
        assert_equal(_code, exception.code);
        assert_is_true(string_pos(_content, exception.description) > 0);
    }
}