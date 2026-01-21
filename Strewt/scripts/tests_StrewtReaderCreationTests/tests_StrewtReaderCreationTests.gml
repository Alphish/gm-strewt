function StrewtReaderCreationTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    static test_subject = "Reader creation";
    
    static should_accept_string_content = function() {
        given_content("Hello, world!");
        assert_equal("Hello, world!", reader.peek_all());
        assert_equal(13, reader.byte_length);
        assert_equal(14, buffer_get_size(reader.content_buffer));
        assert_equal(0, buffer_peek(reader.content_buffer, 13, buffer_u8));
    }
    
    static should_accept_buffer_content = function() {
        var _buffer = buffer_create(4, buffer_fixed, 1);
        buffer_poke(_buffer, 0, buffer_u8, 49);
        buffer_poke(_buffer, 1, buffer_u8, 50);
        buffer_poke(_buffer, 2, buffer_u8, 51);
        buffer_poke(_buffer, 3, buffer_u8, 0);
        
        given_content(_buffer);
        assert_equal("123", reader.peek_all());
        assert_equal(3, reader.byte_length);
        assert_equal(4, buffer_get_size(reader.content_buffer));
        assert_equal(0, buffer_peek(reader.content_buffer, 3, buffer_u8));
    }
    
    static should_add_trailing_zero_if_absent = function() {
        var _buffer = buffer_create(3, buffer_fixed, 1);
        buffer_poke(_buffer, 0, buffer_u8, 49);
        buffer_poke(_buffer, 1, buffer_u8, 50);
        buffer_poke(_buffer, 2, buffer_u8, 51);
        
        given_content(_buffer);
        assert_equal("123", reader.peek_all());
        assert_equal(3, reader.byte_length);
        assert_equal(4, buffer_get_size(_buffer));
        assert_equal(0, buffer_peek(_buffer, 3, buffer_u8));
    }
    
    static should_keep_trailing_zero_if_present = function() {
        var _buffer = buffer_create(4, buffer_fixed, 1);
        buffer_poke(_buffer, 0, buffer_u8, 49);
        buffer_poke(_buffer, 1, buffer_u8, 50);
        buffer_poke(_buffer, 2, buffer_u8, 51);
        buffer_poke(_buffer, 3, buffer_u8, 0);
        
        given_content(_buffer);
        assert_equal("123", reader.peek_all());
        assert_equal(3, reader.byte_length);
        assert_equal(4, buffer_get_size(_buffer));
        assert_equal(0, buffer_peek(_buffer, 3, buffer_u8));
    }
    
    static should_reposition_content_buffer_to_start = function() {
        var _buffer = buffer_create(4, buffer_fixed, 1);
        buffer_write(_buffer, buffer_u8, 49);
        buffer_write(_buffer, buffer_u8, 50);
        buffer_write(_buffer, buffer_u8, 51);
        buffer_write(_buffer, buffer_u8, 0);
        assert_equal(4, buffer_tell(_buffer));
        
        given_content(_buffer);
        assert_equal("123", reader.peek_all());
        assert_equal(0, reader.get_position());
        assert_equal(0, buffer_tell(_buffer));
    }
    
    static should_accept_empty_string = function() {
        given_content("");
        assert_equal("", reader.peek_all());
        assert_equal(0, reader.byte_length);
        assert_equal(1, buffer_get_size(reader.content_buffer));
        assert_equal(0, buffer_peek(reader.content_buffer, 0, buffer_u8));
    }
    
    static should_accept_empty_buffer = function() {
        var _buffer = buffer_create(0, buffer_fixed, 1);
        
        given_content(_buffer);
        assert_equal("", reader.peek_all());
        assert_equal(0, reader.byte_length);
        assert_equal(1, buffer_get_size(_buffer));
        assert_equal(0, buffer_peek(_buffer, 0, buffer_u8));
    }
    
    static should_reject_invalid_content = function() {
        try {
            given_content(123);
            assert_fail($"Creating reader with something other than string or buffer should fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("reader_invalid_content", _ex.code);
        }
    }
    
    // -----
    // Setup
    // -----
    
    reader = undefined;
    
    static given_content = function(_content) {
        reader = new StrewtReader(_content);
    }
    
    static test_cleanup = function() {
        if (!is_undefined(reader))
            reader.cleanup();
    }
}
