function StrewtReaderStringTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "String checking";
    
    // --------
    // Spanning
    // --------
    
    static should_not_span_sequence_on_empty_string = function() {
        given_content("");
        when(reader.span_string("123"));
        expect_result_position(0, 0);
    }
    
    static should_span_single_byte_sequence = function() {
        given_content("12345");
        when(reader.span_string("1"));
        expect_result_position(1, 0);
    }
    
    static should_span_matching_sequence = function() {
        given_content("12345");
        when(reader.span_string("123"));
        expect_result_position(3, 0);
    }
    
    static should_span_matching_sequence_to_end = function() {
        given_content("12345");
        when(reader.span_string("12345"));
        expect_result_position(5, 0);
    }
    
    static should_not_span_different_sequence = function() {
        given_content("ABCDE");
        when(reader.span_string("123"));
        expect_result_position(0, 0);
    }
    
    static should_not_span_partially_matching_sequence = function() {
        given_content("1290");
        when(reader.span_string("123"));
        expect_result_position(0, 0);
    }
    
    static should_span_matching_sequence_in_the_middle = function() {
        given_content("112358");
        
        when(reader.span_string("123"));
        expect_result_position(0, 0);
        
        reader.move_to(1);
        when(reader.span_string("123"));
        expect_result_position(3, 1);
    }
    
    // --------
    // Skipping
    // --------
    
    static should_not_skip_sequence_on_empty_string = function() {
        given_content("");
        when(reader.try_skip_string("123"));
        expect_result_position(0, 0);
    }
    
    static should_skip_single_byte_sequence = function() {
        given_content("12345");
        when(reader.try_skip_string("1"));
        expect_result_position(1, 1);
    }
    
    static should_skip_matching_sequence = function() {
        given_content("12345");
        when(reader.try_skip_string("123"));
        expect_result_position(3, 3);
    }
    
    static should_skip_matching_sequence_to_end = function() {
        given_content("12345");
        when(reader.try_skip_string("12345"));
        expect_result_position(5, 5);
    }
    
    static should_not_skip_different_sequence = function() {
        given_content("ABCDE");
        when(reader.try_skip_string("123"));
        expect_result_position(0, 0);
    }
    
    static should_not_skip_partially_matching_sequence = function() {
        given_content("1290");
        when(reader.try_skip_string("123"));
        expect_result_position(0, 0);
    }
    
    static should_skip_matching_sequence_repeatedly = function() {
        given_content("123123456");
        
        when(reader.try_skip_string("123"));
        expect_result_position(3, 3);
        when(reader.try_skip_string("123"));
        expect_result_position(3, 6);
        
        when(reader.try_skip_string("123"));
        expect_result_position(0, 6);
    }
}
