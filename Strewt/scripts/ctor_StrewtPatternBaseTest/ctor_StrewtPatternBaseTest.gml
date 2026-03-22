function StrewtPatternBaseTest(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    reader = undefined;
    pattern = undefined;
    
    span_result = undefined;
    span_position = undefined;
    skip_result = undefined;
    skip_position = undefined;
    peek_raw_result = undefined;
    peek_raw_position = undefined;
    read_raw_result = undefined;
    read_raw_position = undefined;
    
    peek_result = undefined;
    peek_position = undefined;
    read_result = undefined;
    read_position = undefined;
    read_into_result = undefined;
    read_into_position = undefined;
    read_into_target = buffer_create(10, buffer_grow, 1);
    buffer_write(read_into_target, buffer_text, "PREFIX");
    buffer_poke(read_into_target, string_length("PREFIX"), buffer_u8, 0);
    read_into_string = undefined;
    
    // -----
    // Given
    // -----
    
    static given_content = function(_content) {
        reader = new StrewtReader(_content);
    }
    
    static given_position = function(_position) {
        reader.move_to(_position);
    }
    
    static given_pattern = function(_pattern) {
        pattern = _pattern;
    }
    
    // ----
    // When
    // ----
    
    static when_pattern_tested = function() {
        when_method_tested(reader.span_pattern, nameof(span_result), nameof(span_position));
        when_method_tested(reader.skip_pattern, nameof(skip_result), nameof(skip_position));
        when_method_tested(reader.peek_pattern_raw, nameof(peek_raw_result), nameof(peek_raw_position));
        when_method_tested(reader.read_pattern_raw, nameof(read_raw_result), nameof(read_raw_position));
        when_method_tested(reader.peek_pattern, nameof(peek_result), nameof(peek_position));
        when_method_tested(reader.read_pattern, nameof(read_result), nameof(read_position));
        
        when_method_tested(reader.read_pattern_into, nameof(read_into_result), nameof(read_into_position), read_into_target);
        buffer_write(read_into_target, buffer_u8, 0);
        read_into_string = buffer_peek(read_into_target, 0, buffer_string);
    }
    
    static when_method_tested = function(_func, _result_name, _position_name, _target = undefined) {
        var _original_position = reader.position;
        
        var _method = method(reader, _func);
        self[$ _result_name] = is_undefined(_target) ? _method(pattern) : _method(pattern, _target);
        assert_equal(reader.position, buffer_tell(reader.content_buffer));
        self[$ _position_name] = reader.position;
        
        reader.move_to(_original_position);
    }
    
    // ----
    // Then
    // ----
    
    static then_expect_span = function(_span, _target_span = _span) {
        assert_equal(_span, span_result, $"Expected the span method to return {_span}, but got {span_result} instead.");
        assert_equal(_span, skip_result, $"Expected the skip method to return {_span}, but got {skip_result} instead.");
        assert_equal(_target_span, read_into_result, $"Expected the read_into method to return {_target_span}, but got {read_into_result} instead.");
    }
    
    static then_expect_string = function(_raw, _pattern = _raw) {
        assert_equal(_raw, peek_raw_result, $"Expected the peek_raw method to return {_raw}, but got {peek_raw_result} instead.");
        assert_equal(_raw, read_raw_result, $"Expected the read_raw method to return {_raw}, but got {read_raw_result} instead.");
        
        assert_equal(_pattern, peek_result, $"Expected the peek method to return {_pattern}, but got {peek_result} instead.");
        assert_equal(_pattern, read_result, $"Expected the read method to return {_pattern}, but got {read_result} instead.");
        
        // read_into should write on top of "PREFIX" already written to the buffer
        if (_pattern == "")
            assert_equal("PREFIX", read_into_string, $"Expected the read_into method to leave the target unaffected when reading empty span.");
        else if (!is_undefined(read_into_string))
            assert_equal("PREFIX" + _pattern, read_into_string, $"Expected the read_into method to result in PREFIX{_pattern}, but got {read_into_string} instead.");
    }
    
    static then_expect_positions = function(_from, _to) {
        assert_equal(_from, span_position, $"Expected the span method to leave the reader at {_from}th byte, but it's at the {span_position}th byte instead.")
        assert_equal(_to, skip_position, $"Expected the skip method to leave the reader at {_to}th byte, but it's at the {skip_position}th byte instead.")
        assert_equal(_from, peek_raw_position, $"Expected the peek_raw method to leave the reader at {_from}th byte, but it's at the {peek_raw_position}th byte instead.")
        assert_equal(_to, read_raw_position, $"Expected the read_raw method to leave the reader at {_to}th byte, but it's at the {read_raw_position}th byte instead.")
        assert_equal(_from, peek_position, $"Expected the peek method to leave the reader at {_from}th byte, but it's at the {peek_position}th byte instead.")
        assert_equal(_to, read_position, $"Expected the read method to leave the reader at {_to}th byte, but it's at the {read_position}th byte instead.")
        assert_equal(_to, read_into_position, $"Expected the read_into method to leave the reader at {_to}th byte, but it's at the {read_into_position}th byte instead.")
    }
    
    // -------
    // Cleanup
    // -------
    
    static test_cleanup = function() {
        if (!is_undefined(reader))
            reader.cleanup();
        
        buffer_delete(read_into_target);
    }
}
