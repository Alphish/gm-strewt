function StrewtReaderByteTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Any byte reading";
    
    // --------
    // Skipping
    // --------
    
    static should_not_skip_byte_on_empty_string = function() {
        given_content("");
        when(reader.skip_next());
        expect_result_position(0, 0);
    }
    
    static should_skip_byte_on_nonempty_string = function() {
        given_content("123");
        when(reader.skip_next());
        expect_result_position(1, 1);
    }
    
    static should_skip_byte_repeatedly_until_end = function() {
        given_content("123");
        
        when(reader.skip_next());
        expect_result_position(1, 1);
        when(reader.skip_next());
        expect_result_position(1, 2);
        when(reader.skip_next());
        expect_result_position(1, 3);
        
        when(reader.skip_next());
        expect_result_position(0, 3);
    }
    
    // -------
    // Peeking
    // -------
    
    static should_not_peek_byte_on_empty_string = function() {
        given_content("");
        when(reader.peek_next());
        expect_result_position(0, 0);
    }
    
    static should_peek_byte_on_nonempty_string = function() {
        given_content("123");
        when(reader.peek_next());
        expect_result_position(49, 0);
    }
    
    static should_peek_same_byte_repeatedly = function() {
        given_content("123");
        
        when(reader.peek_next());
        expect_result_position(49, 0)
        when(reader.peek_next());
        expect_result_position(49, 0);
    }
    
    static should_peek_byte_in_the_middle = function() {
        given_content("12345");
        reader.move_to(3);
        
        when(reader.peek_next());
        expect_result_position(52, 3)
    }
    
    // -------
    // Reading
    // -------
    
    static should_not_read_byte_on_empty_string = function() {
        given_content("");
        when(reader.read_next());
        expect_result_position(0, 0);
    }
    
    static should_read_byte_on_nonempty_string = function() {
        given_content("123");
        when(reader.read_next());
        expect_result_position(49, 1);
    }
    
    static should_read_byte_repeatedly_until_end = function() {
        given_content("123");
        
        when(reader.read_next());
        expect_result_position(49, 1);
        when(reader.read_next());
        expect_result_position(50, 2);
        when(reader.read_next());
        expect_result_position(51, 3);
        
        when(reader.read_next());
        expect_result_position(0, 3);
    }
}
