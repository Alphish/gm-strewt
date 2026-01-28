function StrewtReaderByteTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Byte reading";
    
    // --------
    // Skipping
    // --------
    
    static should_not_skip_byte_on_empty_string = function() {
        given_content("");
        when(reader.skip_byte());
        expect_result_position(false, 0);
    }
    
    static should_skip_byte_on_nonempty_string = function() {
        given_content("123");
        when(reader.skip_byte());
        expect_result_position(true, 1);
    }
    
    static should_skip_byte_repeatedly_until_end = function() {
        given_content("123");
        
        when(reader.skip_byte());
        expect_result_position(true, 1);
        when(reader.skip_byte());
        expect_result_position(true, 2);
        when(reader.skip_byte());
        expect_result_position(true, 3);
        
        when(reader.skip_byte());
        expect_result_position(false, 3);
    }
    
    static should_not_skip_specific_byte_on_empty_string = function() {
        given_content("");
        when(reader.try_skip_byte(49));
        expect_result_position(false, 0);
    }
    
    static should_skip_specific_byte_before_matching_byte = function() {
        given_content("123");
        when(reader.try_skip_byte(49));
        expect_result_position(true, 1);
    }
    
    static should_not_skip_specific_byte_before_different_byte = function() {
        given_content("123");
        when(reader.try_skip_byte(59));
        expect_result_position(false, 0);
    }
    
    static should_skip_specific_bytes_repeatedly_until_end = function() {
        given_content("123");
        
        when(reader.try_skip_byte(49));
        expect_result_position(true, 1);
        when(reader.try_skip_byte(50));
        expect_result_position(true, 2);
        when(reader.try_skip_byte(51));
        expect_result_position(true, 3);
        
        when(reader.try_skip_byte(52));
        expect_result_position(false, 3);
    }
    
    // -------
    // Peeking
    // -------
    
    static should_not_peek_byte_on_empty_string = function() {
        given_content("");
        when(reader.peek_byte());
        expect_result_position(0, 0);
    }
    
    static should_peek_byte_on_nonempty_string = function() {
        given_content("123");
        when(reader.peek_byte());
        expect_result_position(49, 0);
    }
    
    static should_peek_same_byte_repeatedly = function() {
        given_content("123");
        
        when(reader.peek_byte());
        expect_result_position(49, 0)
        when(reader.peek_byte());
        expect_result_position(49, 0);
    }
    
    static should_peek_byte_in_the_middle = function() {
        given_content("12345");
        reader.move_to(3);
        
        when(reader.peek_byte());
        expect_result_position(52, 3)
    }
    
    static should_not_peek_specific_byte_on_empty_string = function() {
        given_content("");
        when(reader.peeks_byte(49));
        expect_result_position(false, 0);
    }
    
    static should_peek_specific_byte_before_matching = function() {
        given_content("123");
        when(reader.peeks_byte(49));
        expect_result_position(true, 0);
    }
    
    static should_not_peek_specific_byte_before_different_byte = function() {
        given_content("123");
        when(reader.peeks_byte(59));
        expect_result_position(false, 0);
    }
    
    static should_peek_same_specific_byte_repeatedly = function() {
        given_content("123");
        
        when(reader.peeks_byte(49));
        expect_result_position(true, 0)
        when(reader.peeks_byte(49));
        expect_result_position(true, 0);
    }
    
    static should_peek_specific_byte_in_the_middle = function() {
        given_content("12345");
        reader.move_to(3);
        
        when(reader.peeks_byte(52));
        expect_result_position(true, 3)
    }
    
    // -------
    // Reading
    // -------
    
    static should_not_read_byte_on_empty_string = function() {
        given_content("");
        when(reader.read_byte());
        expect_result_position(0, 0);
    }
    
    static should_read_byte_on_nonempty_string = function() {
        given_content("123");
        when(reader.read_byte());
        expect_result_position(49, 1);
    }
    
    static should_read_byte_repeatedly_until_end = function() {
        given_content("123");
        
        when(reader.read_byte());
        expect_result_position(49, 1);
        when(reader.read_byte());
        expect_result_position(50, 2);
        when(reader.read_byte());
        expect_result_position(51, 3);
        
        when(reader.read_byte());
        expect_result_position(0, 3);
    }
}
