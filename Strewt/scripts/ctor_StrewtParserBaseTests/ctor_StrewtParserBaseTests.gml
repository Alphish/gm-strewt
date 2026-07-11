function StrewtParserBaseTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    static test_subject = "Example parser";
    
    parser = undefined;
    parse_result = undefined;
    
    // -------
    // Helpers
    // -------
    
    static given_parser = function() {
        parser = new TestDummyParser();
        return parser;
    }
    
    static when_parsed = function() {
        parse_result = parser.parse_all();
    }
    
    static expect_parse_result = function(_expected) {
        assert_equal(1, parser.status);
        assert_is_true(parser.is_finished());
        
        assert_array_equal(_expected, parser.result);
        assert_is_undefined(parser.error);
        assert_is_undefined(parser.error_location);
    }
    
    static expect_parse_error = function(_line, _column, _position, _message) {
        assert_equal(-1, parser.status);
        assert_is_true(parser.is_finished());
        
        assert_is_undefined(parser.result);
        assert_equal(_line, parser.error_location.line);
        assert_equal(_column, parser.error_location.column);
        assert_equal(_position, parser.error_location.position);
        assert_equal(_message, parser.error);
    }
    
    static expect_cleanup = function() {
        assert_is_undefined(parser.reader);
    }
    
    static expect_no_cleanup = function() {
        assert_is_struct(parser.reader);
    }
    
    // -------
    // Cleanup
    // -------
    
    static test_cleanup = function() {
        if (!is_undefined(parser.reader))
            parser.reader.cleanup();
    }
}
