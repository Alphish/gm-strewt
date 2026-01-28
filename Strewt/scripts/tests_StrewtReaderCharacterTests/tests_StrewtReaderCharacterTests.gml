function StrewtReaderCharacterTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Character reading";
    
    // -------
    // Peeking
    // -------
    
    static should_peek_empty_character_at_end_of_string = function() {
        given_content("");
        when(reader.peek_character());
        expect_result_position("", 0);
    }
    
    static should_peek_character_of_nonempty_string = function() {
        given_content("123");
        when(reader.peek_character());
        expect_result_position("1", 0);
    }
    
    static should_peek_multibyte_characters = function() {
        given_content("AŻ亞😊");
        
        reader.move_to(0);
        when(reader.peek_character());
        expect_result_position("A", 0);
        
        reader.move_to(1);
        when(reader.peek_character());
        expect_result_position("Ż", 1);
        
        reader.move_to(3);
        when(reader.peek_character());
        expect_result_position("亞", 3);
        
        reader.move_to(6);
        when(reader.peek_character());
        expect_result_position("😊", 6);
        
        reader.move_to(10);
        when(reader.peek_character());
        expect_result_position("", 10);
    }
    
    static should_fail_to_peek_character_from_continuation_byte = function() {
        given_content("Ż");
        reader.move_to(1);
        try {
            reader.peek_character();
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("reader_invalid_utf8_byte", _ex.code);
        }
    }
    
    static should_fail_to_peek_character_from_too_large_byte = function() {
        var _content = buffer_create(1, buffer_fixed, 1);
        buffer_write(_content, buffer_u8, 250);
        given_content(_content);
        try {
            reader.peek_character();
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("reader_invalid_utf8_byte", _ex.code);
        }
    }
    
    // -------
    // Reading
    // -------
    
    static should_read_empty_character_at_end_of_string = function() {
        given_content("");
        when(reader.read_character());
        expect_result_position("", 0);
    }
    
    static should_read_character_of_nonempty_string = function() {
        given_content("123");
        when(reader.read_character());
        expect_result_position("1", 1);
    }
    
    static should_read_character_repeatedly_until_end = function() {
        given_content("123");
        
        when(reader.read_character());
        expect_result_position("1", 1);
        when(reader.read_character());
        expect_result_position("2", 2);
        when(reader.read_character());
        expect_result_position("3", 3);
        
        when(reader.read_character());
        expect_result_position("", 3);
    }
    
    static should_read_multibyte_characters = function() {
        given_content("AŻ亞😊");
        
        when(reader.read_character());
        expect_result_position("A", 1);
        when(reader.read_character());
        expect_result_position("Ż", 3);
        when(reader.read_character());
        expect_result_position("亞", 6);
        when(reader.read_character());
        expect_result_position("😊", 10);
        
        when(reader.read_character());
        expect_result_position("", 10);
    }
    
    static should_fail_to_read_character_from_continuation_byte = function() {
        given_content("Ż");
        reader.move_to(1);
        try {
            reader.read_character();
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("reader_invalid_utf8_byte", _ex.code);
        }
    }
    
    static should_fail_to_read_character_from_too_large_byte = function() {
        var _content = buffer_create(1, buffer_fixed, 1);
        buffer_write(_content, buffer_u8, 250);
        given_content(_content);
        try {
            reader.read_character();
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("reader_invalid_utf8_byte", _ex.code);
        }
    }
}
