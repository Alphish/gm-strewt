function StrewtPatternBaseTest(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    reader = undefined;
    pattern = undefined;
    result = undefined;
    
    static given_content = function(_content) {
        reader = new StrewtReader(_content);
    }
    
    static when_read_raw = function() {
        result = reader.read_pattern_raw(pattern);
    }
    
    static when_read = function() {
        result = reader.read_pattern(pattern);
    }
    
    static expect_result = function(_expected) {
        assert_equal(_expected, result);
    }
    
    static expect_no_result = function() {
        assert_equal("", result);
    }
    
    static test_cleanup = function() {
        if (!is_undefined(reader))
            reader.cleanup();
    }
}
