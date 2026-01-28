function StrewtReaderBaseTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    reader = undefined;
    result = undefined;
    
    static given_content = function(_content) {
        reader = new StrewtReader(_content);
    }
    
    static when = function(_operation) {
        result = _operation;
    }
    
    static expect_result_position = function(_result, _position) {
        assert_equal(_result, result);
        assert_equal(_position, reader.get_position());
        assert_equal(_position, buffer_tell(reader.content_buffer));
    }
    
    static test_cleanup = function() {
        if (!is_undefined(reader))
            reader.cleanup();
    }
}
