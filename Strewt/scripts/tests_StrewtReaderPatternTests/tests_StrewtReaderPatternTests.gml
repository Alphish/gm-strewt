function StrewtReaderPatternTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Pattern reading";
    
    // --------
    // Spanning
    // --------
    
    static should_not_span_pattern_on_empty_string = function() {
        given_content("");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.span_pattern(pattern));
        expect_result_position(0, 0);
    }
    
    static should_span_pattern_on_matching_string = function() {
        given_content("\"Hello, world!\", \"How are you?\"");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.span_pattern(pattern));
        expect_result_position(15, 0);
    }
    
    static should_not_span_pattern_on_different_string = function() {
        given_content("Nothing to see here, carry on");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.span_pattern(pattern));
        expect_result_position(0, 0);
    }
    
    static should_not_span_pattern_on_partially_matching_string = function() {
        given_content("\"My closing quote is missing");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.span_pattern(pattern));
        expect_result_position(0, 0);
    }
    
    static should_span_pattern_on_escaped_string = function() {
        given_content("\"This is \"\"The Title\"\"!\"...");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.span_pattern(pattern));
        expect_result_position(24, 0);
    }
    
    // --------
    // Skipping
    // --------
    
    static should_not_skip_pattern_on_empty_string = function() {
        given_content("");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.skip_pattern(pattern));
        expect_result_position(0, 0);
    }
    
    static should_skip_pattern_on_matching_string = function() {
        given_content("\"Hello, world!\", \"How are you?\"");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.skip_pattern(pattern));
        expect_result_position(15, 15);
    }
    
    static should_not_skip_pattern_on_different_string = function() {
        given_content("Nothing to see here, carry on");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.skip_pattern(pattern));
        expect_result_position(0, 0);
    }
    
    static should_not_skip_pattern_on_partially_matching_string = function() {
        given_content("\"My closing quote is missing");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.skip_pattern(pattern));
        expect_result_position(0, 0);
    }
    
    static should_skip_pattern_on_escaped_string = function() {
        given_content("\"This is \"\"The Title\"\"!\"...");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.skip_pattern(pattern));
        expect_result_position(24, 24);
    }
    
    // -----------
    // Peeking raw
    // -----------
    
    static should_not_peek_raw_pattern_on_empty_string = function() {
        given_content("");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern_raw(pattern));
        expect_result_position("", 0);
    }
    
    static should_peek_raw_pattern_on_matching_string = function() {
        given_content("\"Hello, world!\", \"How are you?\"");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern_raw(pattern));
        expect_result_position("\"Hello, world!\"", 0);
    }
    
    static should_not_peek_raw_pattern_on_different_string = function() {
        given_content("Nothing to see here, carry on");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern_raw(pattern));
        expect_result_position("", 0);
    }
    
    static should_not_peek_raw_pattern_on_partially_matching_string = function() {
        given_content("\"My closing quote is missing");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern_raw(pattern));
        expect_result_position("", 0);
    }
    
    static should_peek_raw_pattern_on_escaped_string = function() {
        given_content("\"This is \"\"The Title\"\"!\"...");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern_raw(pattern));
        expect_result_position("\"This is \"\"The Title\"\"!\"", 0);
    }
    
    // -----------
    // Reading raw
    // -----------
    
    static should_not_read_raw_pattern_on_empty_string = function() {
        given_content("");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern_raw(pattern));
        expect_result_position("", 0);
    }
    
    static should_read_raw_pattern_on_matching_string = function() {
        given_content("\"Hello, world!\", \"How are you?\"");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern_raw(pattern));
        expect_result_position("\"Hello, world!\"", 15);
    }
    
    static should_not_read_raw_pattern_on_different_string = function() {
        given_content("Nothing to see here, carry on");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern_raw(pattern));
        expect_result_position("", 0);
    }
    
    static should_not_read_raw_pattern_on_partially_matching_string = function() {
        given_content("\"My closing quote is missing");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern_raw(pattern));
        expect_result_position("", 0);
    }
    
    static should_read_raw_pattern_on_escaped_string = function() {
        given_content("\"This is \"\"The Title\"\"!\"...");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern_raw(pattern));
        expect_result_position("\"This is \"\"The Title\"\"!\"", 24);
    }
    
    // -------
    // Peeking
    // -------
    
    static should_not_peek_pattern_on_empty_string = function() {
        given_content("");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern(pattern));
        expect_result_position("", 0);
    }
    
    static should_peek_pattern_on_matching_string = function() {
        given_content("\"Hello, world!\", \"How are you?\"");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern(pattern));
        expect_result_position("Hello, world!", 0);
    }
    
    static should_not_peek_pattern_on_different_string = function() {
        given_content("Nothing to see here, carry on");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern(pattern));
        expect_result_position("", 0);
    }
    
    static should_not_peek_pattern_on_partially_matching_string = function() {
        given_content("\"My closing quote is missing");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern(pattern));
        expect_result_position("", 0);
    }
    
    static should_peek_pattern_on_escaped_string = function() {
        given_content("\"This is \"\"The Title\"\"!\"...");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.peek_pattern(pattern));
        expect_result_position("This is \"The Title\"!", 0);
    }
    
    // -------
    // Reading
    // -------
    
    static should_not_read_pattern_on_empty_string = function() {
        given_content("");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern(pattern));
        expect_result_position("", 0);
    }
    
    static should_read_pattern_on_matching_string = function() {
        given_content("\"Hello, world!\", \"How are you?\"");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern(pattern));
        expect_result_position("Hello, world!", 15);
    }
    
    static should_not_read_pattern_on_different_string = function() {
        given_content("Nothing to see here, carry on");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern(pattern));
        expect_result_position("", 0);
    }
    
    static should_not_read_pattern_on_partially_matching_string = function() {
        given_content("\"My closing quote is missing");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern(pattern));
        expect_result_position("", 0);
    }
    
    static should_read_pattern_on_escaped_string = function() {
        given_content("\"This is \"\"The Title\"\"!\"...");
        given_pattern(StringQuoteDoublingPattern);
        when(reader.read_pattern(pattern));
        expect_result_position("This is \"The Title\"!", 24);
    }
    
    // -------
    // Peeking
    // -------
    
    static should_not_peek_pattern_into_buffer_on_empty_string = function() {
        given_content("");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.peek_pattern_into(pattern, target));
        expect_result_position(0, 0);
        expect_target_position("", 0);
    }
    
    static should_peek_pattern_into_buffer_on_matching_string = function() {
        given_content("\"Hello, world!\", \"How are you?\"");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.peek_pattern_into(pattern, target));
        expect_result_position(13, 0);
        expect_target_position("Hello, world!", 13);
    }
    
    static should_not_peek_pattern_into_buffer_on_different_string = function() {
        given_content("Nothing to see here, carry on");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.peek_pattern_into(pattern, target));
        expect_result_position(0, 0);
    }
    
    static should_not_peek_pattern_into_buffer_on_partially_matching_string = function() {
        given_content("\"My closing quote is missing");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.peek_pattern_into(pattern, target));
        expect_result_position(0, 0);
        expect_target_position("", 0);
    }
    
    static should_peek_pattern_into_buffer_on_escaped_string = function() {
        given_content("\"This is \"\"The Title\"\"!\"...");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.peek_pattern_into(pattern, target));
        expect_result_position(20, 0);
        expect_target_position("This is \"The Title\"!", 20);
    }
    
    // -------
    // Reading
    // -------
    
    static should_not_read_pattern_into_buffer_on_empty_string = function() {
        given_content("");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.read_pattern_into(pattern, target));
        expect_result_position(0, 0);
        expect_target_position("", 0);
    }
    
    static should_read_pattern_into_buffer_on_matching_string = function() {
        given_content("\"Hello, world!\", \"How are you?\"");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.read_pattern_into(pattern, target));
        expect_result_position(13, 15);
        expect_target_position("Hello, world!", 13);
    }
    
    static should_not_read_pattern_into_buffer_on_different_string = function() {
        given_content("Nothing to see here, carry on");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.read_pattern_into(pattern, target));
        expect_result_position(0, 0);
        expect_target_position("", 0);
    }
    
    static should_not_read_pattern_into_buffer_on_partially_matching_string = function() {
        given_content("\"My closing quote is missing");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.read_pattern_into(pattern, target));
        expect_result_position(0, 0);
        expect_target_position("", 0);
    }
    
    static should_read_pattern_into_buffer_on_escaped_string = function() {
        given_content("\"This is \"\"The Title\"\"!\"...");
        given_pattern(StringQuoteDoublingPattern);
        given_target();
        when(reader.read_pattern_into(pattern, target));
        expect_result_position(20, 24);
        expect_target_position("This is \"The Title\"!", 20);
    }
    
    // -----
    // Setup
    // -----
    
    target = undefined;
    pattern = undefined;
    
    static given_target = function() {
        target = buffer_create(16, buffer_grow, 1);
    }
    
    static given_pattern = function(_type) {
        pattern = new _type();
    }
    
    static expect_target_position = function(_value, _position) {
        assert_equal(_value, buffer_peek(target, 0, buffer_string));
        assert_equal(_position, buffer_tell(target));
    }
    
    static test_cleanup = function() {
        if (!is_undefined(reader))
            reader.cleanup();
        
        if (!is_undefined(target))
            buffer_delete(target);
    }
}
