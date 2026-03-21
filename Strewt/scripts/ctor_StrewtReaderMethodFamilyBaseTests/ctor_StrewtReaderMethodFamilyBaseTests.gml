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
    
    read_into_plain_result = undefined;
    read_into_plain_position = undefined;
    read_into_plain_target = buffer_create(10, buffer_grow, 1);
    buffer_write(read_into_plain_target, buffer_text, "PREFIX");
    buffer_poke(read_into_plain_target, string_length("PREFIX"), buffer_u8, 0);
    read_into_plain_string = undefined;
    
    read_into_offset_result = undefined;
    read_into_offset_position = undefined;
    read_into_offset_target = buffer_create(10, buffer_grow, 1);
    buffer_write(read_into_offset_target, buffer_text, "OFFSET");
    buffer_poke(read_into_plain_target, string_length("OFFSET"), buffer_u8, 0);
    read_into_offset_string = undefined;
    
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
    
    static when_read_into_target = function(_target, _offset = undefined) {
        throw StrewtException.not_implemented(self, nameof(when_read_into_target));
    }
    
    static when_method_family_tested = function() {
        when_method_tested(when_spanned, nameof(span_result), nameof(span_position));
        when_method_tested(when_skipped, nameof(skip_result), nameof(skip_position));
        when_method_tested(when_peeked, nameof(peek_result), nameof(peek_position));
        when_method_tested(when_read, nameof(read_result), nameof(read_position));
        
        when_method_tested(when_read_into_target, nameof(read_into_plain_result), nameof(read_into_plain_position), read_into_plain_target);
        buffer_write(read_into_plain_target, buffer_u8, 0);
        read_into_plain_string = buffer_peek(read_into_plain_target, 0, buffer_string);
        
        when_method_tested(when_read_into_target, nameof(read_into_offset_result), nameof(read_into_offset_position), read_into_offset_target, /* offset */ 3);
        buffer_write(read_into_offset_target, buffer_u8, 0);
        read_into_offset_string = buffer_peek(read_into_offset_target, 0, buffer_string);
    }
    
    static when_method_tested = function(_func, _result_name, _position_name, _target = undefined, _offset = undefined) {
        var _original_position = reader.position;
        
        var _method = method(self, _func);
        if (is_undefined(_target))
            self[$ _result_name] = _method();
        else if (is_undefined(_offset))
            self[$ _result_name] = _method(_target);
        else
            self[$ _result_name] = _method(_target, _offset);
        
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
        
        if (!is_undefined(read_into_plain_result))
            assert_equal(_span, read_into_plain_result, $"Expected the read_into method without offset to return {_span}, but got {read_into_plain_result} instead.");
        
        if (!is_undefined(read_into_offset_result))
            assert_equal(_span, read_into_offset_result, $"Expected the read_into method with offset to return {_span}, but got {read_into_offset_result} instead.");
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
        
        // read_into without offset should write on top of "PREFIX" already written to the buffer
        if (_str == "")
            assert_equal("PREFIX", read_into_plain_string, $"Expected the read_into method without offset to leave the target unaffected when reading empty span.");
        else if (!is_undefined(read_into_plain_string))
            assert_equal("PREFIX" + _str, read_into_plain_string, $"Expected the read_into method without offset to result in PREFIX{_str}, but got {read_into_plain_string} instead.");
        
        // read into with offset should write on top of "OFF" already written to the buffer, overwriting subsequent "SET"
        if (_str == "")
            assert_equal("OFFSET", read_into_offset_string, $"Expected the read_into method with offset to leave the target unaffected when reading empty span.");
        else if (!is_undefined(read_into_offset_string))
            assert_equal("OFF" + _str, read_into_offset_string, $"Expected the read_into method with offset to result in OFF{_str}, but got {read_into_offset_string} instead.");
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
        
        if (!is_undefined(read_into_plain_position))
            assert_equal(_to, read_into_plain_position, $"Expected the read_into method without offset to leave the reader at {_to}th byte, but it's at the {read_into_plain_position}th byte instead.")
        
        if (!is_undefined(read_into_offset_position))
            assert_equal(_to, read_into_offset_position, $"Expected the read_into method with offset to leave the reader at {_to}th byte, but it's at the {read_into_offset_position}th byte instead.")
    }
    
    // -------
    // Cleanup
    // -------
    
    static test_cleanup = function() {
        if (!is_undefined(reader))
            reader.cleanup();
        
        buffer_delete(read_into_plain_target);
        buffer_delete(read_into_offset_target);
    }
}
