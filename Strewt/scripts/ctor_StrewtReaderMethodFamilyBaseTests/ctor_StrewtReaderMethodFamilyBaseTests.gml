function StrewtReaderMethodFamilyBaseTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    reader = undefined;
    
    span_result = undefined;
    span_position = undefined;
    skip_result = undefined;
    skip_position = undefined;
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
    
    // ----
    // When
    // ----
    
    static when_spanned = function() {
        throw StrewtException.not_implemented(self, nameof(when_spanned));
    }
    
    static when_skipped = function() {
        throw StrewtException.not_implemented(self, nameof(when_skipped));
    }
    
    static when_peeked = function() {
        throw StrewtException.not_implemented(self, nameof(when_peeked));
    }
    
    static when_read = function() {
        throw StrewtException.not_implemented(self, nameof(when_read));
    }
    
    static when_read_into_target = function(_target) {
        throw StrewtException.not_implemented(self, nameof(when_read_into_target));
    }
    
    static when_method_family_tested = function() {
        when_method_tested(when_spanned, nameof(span_result), nameof(span_position));
        when_method_tested(when_skipped, nameof(skip_result), nameof(skip_position));
        when_method_tested(when_peeked, nameof(peek_result), nameof(peek_position));
        when_method_tested(when_read, nameof(read_result), nameof(read_position));
        
        when_method_tested(when_read_into_target, nameof(read_into_result), nameof(read_into_position), read_into_target);
        buffer_write(read_into_target, buffer_u8, 0);
        read_into_string = buffer_peek(read_into_target, 0, buffer_string);
    }
    
    static when_method_tested = function(_func, _result_name, _position_name, _target = undefined) {
        var _original_position = reader.position;
        
        var _method = method(self, _func);
        self[$ _result_name] = is_undefined(_target) ? _method() : _method(_target);
        
        if (is_undefined(self[$ _result_name])) {
            self[$ _position_name] = undefined;
        } else {
            assert_equal(reader.position, buffer_tell(reader.content_buffer));
            self[$ _position_name] = reader.position;
        }
        
        // restoring the original position
        reader.move_to(_original_position);
    }
    
    // ----
    // Then
    // ----
    
    static then_expect_span = function(_span) {
        if (!is_undefined(span_result))
            assert_equal(_span, span_result, $"Expected the span method to return {_span}, but got {span_result} instead.");
        
        if (!is_undefined(skip_result))
            assert_equal(_span, skip_result, $"Expected the skip method to return {_span}, but got {skip_result} instead.");
        
        if (!is_undefined(read_into_result))
            assert_equal(_span, read_into_result, $"Expected the read_into method to return {_span}, but got {read_into_result} instead.");
    }
    
    static then_expect_byte = function(_byte) {
        if (!is_undefined(peek_result) && !is_string(peek_result))
            assert_equal(_byte, peek_result, $"Expected the peek method to return {_byte}, but got {peek_result} instead.");
        
        if (!is_undefined(read_result) && !is_string(read_result))
            assert_equal(_byte, read_result, $"Expected the read method to return {_byte}, but got {read_result} instead.");
    }
    
    static then_expect_string = function(_str) {
        if (!is_undefined(peek_result) && !is_numeric(peek_result))
            assert_equal(_str, peek_result, $"Expected the peek method to return {_str}, but got {peek_result} instead.");
        
        if (!is_undefined(read_result) && !is_numeric(read_result))
            assert_equal(_str, read_result, $"Expected the read method to return {_str}, but got {read_result} instead.");
        
        // read_into should write on top of "PREFIX" already written to the buffer
        if (_str == "")
            assert_equal("PREFIX", read_into_string, $"Expected the read_into method to leave the target unaffected when reading empty span.");
        else if (!is_undefined(read_into_string))
            assert_equal("PREFIX" + _str, read_into_string, $"Expected the read_into method to result in PREFIX{_str}, but got {read_into_string} instead.");
    }
    
    static then_expect_positions = function(_from, _to) {
        if (!is_undefined(span_position))
            assert_equal(_from, span_position, $"Expected the span method to leave the reader at {_from}th byte, but it's at the {span_position}th byte instead.")
        
        if (!is_undefined(skip_position))
            assert_equal(_to, skip_position, $"Expected the skip method to leave the reader at {_to}th byte, but it's at the {skip_position}th byte instead.")
        
        if (!is_undefined(peek_position))
            assert_equal(_from, peek_position, $"Expected the peek method to leave the reader at {_from}th byte, but it's at the {peek_position}th byte instead.")
        
        if (!is_undefined(read_position))
            assert_equal(_to, read_position, $"Expected the read method to leave the reader at {_to}th byte, but it's at the {read_position}th byte instead.")
        
        if (!is_undefined(read_into_position))
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
