function StrewtReaderStringTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "String checking";
    
    // --------
    // Skipping
    // --------
    
    static should_not_skip_sequence_on_empty_string = function() {
        given_content("");
        when(reader.try_skip_string("123"));
        expect_result_position(false, 0);
    }
    
    static should_skip_single_byte_sequence = function() {
        given_content("12345");
        when(reader.try_skip_string("1"));
        expect_result_position(true, 1);
    }
    
    static should_skip_matching_sequence = function() {
        given_content("12345");
        when(reader.try_skip_string("123"));
        expect_result_position(true, 3);
    }
    
    static should_skip_matching_sequence_to_end = function() {
        given_content("12345");
        when(reader.try_skip_string("12345"));
        expect_result_position(true, 5);
    }
    
    static should_not_skip_different_sequence = function() {
        given_content("ABCDE");
        when(reader.try_skip_string("123"));
        expect_result_position(false, 0);
    }
    
    static should_not_skip_partially_matching_sequence = function() {
        given_content("1290");
        when(reader.try_skip_string("123"));
        expect_result_position(false, 0);
    }
    
    static should_skip_matching_sequence_repeatedly = function() {
        given_content("123123456");
        
        when(reader.try_skip_string("123"));
        expect_result_position(true, 3);
        when(reader.try_skip_string("123"));
        expect_result_position(true, 6);
        
        when(reader.try_skip_string("123"));
        expect_result_position(false, 6);
    }
    
    // -------
    // Peeking
    // -------
    
    static should_not_peek_sequence_on_empty_string = function() {
        given_content("");
        when(reader.peeks_string("123"));
        expect_result_position(false, 0);
    }
    
    static should_peek_single_byte_sequence = function() {
        given_content("12345");
        when(reader.peeks_string("1"));
        expect_result_position(true, 0);
    }
    
    static should_peek_matching_sequence = function() {
        given_content("12345");
        when(reader.peeks_string("123"));
        expect_result_position(true, 0);
    }
    
    static should_peek_matching_sequence_to_end = function() {
        given_content("12345");
        when(reader.peeks_string("12345"));
        expect_result_position(true, 0);
    }
    
    static should_not_peek_different_sequence = function() {
        given_content("ABCDE");
        when(reader.peeks_string("123"));
        expect_result_position(false, 0);
    }
    
    static should_not_peek_partially_matching_sequence = function() {
        given_content("1290");
        when(reader.peeks_string("123"));
        expect_result_position(false, 0);
    }
    
    static should_peek_matching_sequence_in_the_middle = function() {
        given_content("112358");
        
        when(reader.peeks_string("123"));
        expect_result_position(false, 0);
        
        reader.move_to(1);
        when(reader.peeks_string("123"));
        expect_result_position(true, 1);
    }
}
