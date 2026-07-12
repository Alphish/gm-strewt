function StrewtWriterBaseTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    writer = undefined;
    result = undefined;
    
    static given_writer = function(_target = undefined) {
        writer = new StrewtWriter(_target);
        return writer;
    }
    
    static when_content_collected = function() {
        result = writer.get_content();
    }
    
    static when_content_bytes_collected = function() {
        result = writer.get_content_bytes();
    }
    
    static expect_result = function(_result) {
        if (is_string(_result)) {
            assert_equal(_result, result);
        } else if (is_array(_result)) {
            var _buffer = result;
            var _bytes = [];
            repeat (buffer_get_size(_buffer)) {
                array_push(_bytes, buffer_read(_buffer, buffer_u8));
            }
            assert_array_equal(_result, _bytes);
        } else {
            throw $"A string or array should be expected but got {typeof(_result)} instead.";
        }
    }
    
    static expect_position = function(_position) {
        assert_equal(_position, writer.get_position());
        assert_equal(_position, writer.get_length());
        assert_equal(_position, buffer_tell(writer.content_buffer));
    }
    
    static test_cleanup = function() {
        if (!is_undefined(writer))
            writer.cleanup();
        
        if (is_handle(result) && buffer_exists(result))
            buffer_delete(result);
    }
}
