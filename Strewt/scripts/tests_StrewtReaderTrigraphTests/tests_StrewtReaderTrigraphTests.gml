function StrewtReaderTrigraphTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Trigraph checking";
    
    // -----
    // Setup
    // -----
    
    trigraph = undefined;
    static given_trigraph = function(_str) {
        trigraph = strewt_trigraph(_str);
    }
    
    static when_spanned = function() {
        return reader.span_trigraph(trigraph);
    }
    
    static when_skipped = function() {
        return reader.skip_trigraph(trigraph);
    }
    
    static when_peeked = function() {
        return undefined;
    }
    
    static when_read = function() {
        return undefined;
    }
    
    static when_read_into_target = function(_target, _offset = undefined) {
        return is_undefined(_offset)
            ? reader.read_trigraph_into(trigraph, _target)
            : reader.read_trigraph_into(trigraph, _target, _offset);
    }
    
    // -----
    // Tests
    // -----
    
    static should_ignore_trigraph_on_empty_string = function() {
        given_content("");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_ignore_trigraph_on_short_string = function() {
        given_content("??");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_trigraph_on_trigraph_string = function() {
        given_content("??=");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("??=");
        then_expect_positions(0, 3);
    }
    
    static should_handle_trigraph_when_matched = function() {
        given_content("??=123");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("??=");
        then_expect_positions(0, 3);
    }
    
    static should_ignore_trigraph_when_not_matched = function() {
        given_content("?? 123");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_nonascii_trigraph_when_matched = function() {
        given_content("日本");
        given_trigraph("日");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("日");
        then_expect_positions(0, 3);
    }
    
    static should_ignore_nonascii_trigraph_when_not_matched = function() {
        given_content("中国");
        given_trigraph("日");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_trigraph_in_the_middle = function() {
        given_content("test ??= 123;");
        given_position(5);
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("??=");
        then_expect_positions(5, 8);
    }
    
    static should_not_create_trigraph_from_non_string = function() {
        try
        {
            var _value = strewt_trigraph(123);
            assert_fail($"Creating a multigraph from a non-string should fail, but it didn't.");
        }
        catch (_ex)
        {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("multigraph_invalid_type", _ex.code);
            assert_is_true(string_pos("trigraph", _ex.description) > 0);
        }
    }
    
    static should_not_create_trigraph_from_too_short_string = function() {
        try
        {
            var _value = strewt_trigraph("/*");
            assert_fail($"Creating a multigraph with invalid length should fail, but it didn't.");
        }
        catch (_ex)
        {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("multigraph_invalid_length", _ex.code);
            assert_is_true(string_pos("trigraph", _ex.description) > 0);
        }
    }
    
    static should_not_create_trigraph_from_too_long_string = function() {
        try
        {
            var _value = strewt_trigraph("/***");
            assert_fail($"Creating a multigraph with invalid length should fail, but it didn't.");
        }
        catch (_ex)
        {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("multigraph_invalid_length", _ex.code);
            assert_is_true(string_pos("trigraph", _ex.description) > 0);
        }
    }
}
