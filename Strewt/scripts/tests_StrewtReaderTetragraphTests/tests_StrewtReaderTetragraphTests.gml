function StrewtReaderTetragraphTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Tetragraph checking";
    
    // -----
    // Setup
    // -----
    
    tetragraph = undefined;
    static given_tetragraph = function(_str) {
        tetragraph = strewt_tetragraph(_str);
    }
    
    static when_spanned = function() {
        return reader.span_tetragraph(tetragraph);
    }
    
    static when_skipped = function() {
        return reader.try_skip_tetragraph(tetragraph);
    }
    
    static when_peeked = function() {
        return undefined;
    }
    
    static when_read = function() {
        return undefined;
    }
    
    static when_read_into_target = function(_target, _offset = undefined) {
        return is_undefined(_offset)
            ? reader.try_read_tetragraph_into(tetragraph, _target)
            : reader.try_read_tetragraph_into(tetragraph, _target, _offset);
    }
    
    // -----
    // Tests
    // -----
    
    static should_ignore_tetragraph_on_empty_string = function() {
        given_content("");
        given_tetragraph("/// ");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_ignore_tetragraph_on_short_string = function() {
        given_content("///");
        given_tetragraph("/// ");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_tetragraph_on_tetragraph_string = function() {
        given_content("/// ");
        given_tetragraph("/// ");
        when_method_family_tested();
        
        then_expect_span(4);
        then_expect_string("/// ");
        then_expect_positions(0, 4);
    }
    
    static should_handle_tetragraph_when_matched = function() {
        given_content("/// @desc Collision code");
        given_tetragraph("/// ");
        when_method_family_tested();
        
        then_expect_span(4);
        then_expect_string("/// ");
        then_expect_positions(0, 4);
    }
    
    static should_ignore_tetragraph_when_not_matched = function() {
        given_content("// just a comment");
        given_tetragraph("/// ");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_nonascii_tetragraph_when_matched = function() {
        given_content("łącznik");
        given_tetragraph("łą");
        when_method_family_tested();
        
        then_expect_span(4);
        then_expect_string("łą");
        then_expect_positions(0, 4);
    }
    
    static should_ignore_nonascii_tetragraph_when_not_matched = function() {
        given_content("łucznik");
        given_tetragraph("łą");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_tetragraph_in_the_middle = function() {
        given_content("test(); /// disable-warning");
        given_position(8);
        given_tetragraph("/// ");
        when_method_family_tested();
        
        then_expect_span(4);
        then_expect_string("/// ");
        then_expect_positions(8, 12);
    }
    
    
    static should_not_create_tetragraph_from_non_string = function() {
        try
        {
            var _value = strewt_tetragraph(123);
            assert_fail($"Creating a multigraph from a non-string should fail, but it didn't.");
        }
        catch (_ex)
        {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("multigraph_invalid_type", _ex.code);
            assert_is_true(string_pos("tetragraph", _ex.description) > 0);
        }
    }
    
    static should_not_create_tetragraph_from_too_short_string = function() {
        try
        {
            var _value = strewt_tetragraph("yes");
            assert_fail($"Creating a multigraph with invalid length should fail, but it didn't.");
        }
        catch (_ex)
        {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("multigraph_invalid_length", _ex.code);
            assert_is_true(string_pos("tetragraph", _ex.description) > 0);
        }
    }
    
    static should_not_create_tetragraph_from_too_long_string = function() {
        try
        {
            var _value = strewt_tetragraph("false");
            assert_fail($"Creating a multigraph with invalid length should fail, but it didn't.");
        }
        catch (_ex)
        {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("multigraph_invalid_length", _ex.code);
            assert_is_true(string_pos("tetragraph", _ex.description) > 0);
        }
    }
}
