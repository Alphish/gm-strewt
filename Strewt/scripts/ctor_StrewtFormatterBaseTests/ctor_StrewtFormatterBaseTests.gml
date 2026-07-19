function StrewtFormatterBaseTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    static test_subject = "Example formatter";
    
    formatter = undefined;
    result = undefined;
    
    // -------
    // Helpers
    // -------
    
    static given_formatter_of = function(_input) {
        formatter = new TestDummyFormatter(_input);
        return formatter;
    }
    
    static when_formatted = function() {
        result = formatter.format_all();
    }
    
    static expect_result = function(_expected) {
        assert_equal(1, formatter.status);
        assert_is_true(formatter.is_finished());
        
        assert_array_equal(_expected, formatter.result);
        assert_is_undefined(formatter.error);
    }
    
    static expect_error = function(_error) {
        assert_equal(-1, formatter.status);
        assert_is_true(formatter.is_finished());
        
        assert_equal(_error, formatter.error);
        assert_is_undefined(formatter.result);
    }
    
    static expect_cleanup = function() {
        assert_is_undefined(formatter.writer);
    }
    
    static expect_no_cleanup = function() {
        assert_is_struct(formatter.writer);
    }
    
    // -------
    // Cleanup
    // -------
    
    static test_cleanup = function() {
        if (!is_undefined(formatter.writer))
            formatter.writer.cleanup();
    }
}
