function StrewtReaderDigraphTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Digraph checking";
    
    // -----
    // Setup
    // -----
    
    digraph = undefined;
    static given_digraph = function(_str) {
        digraph = strewt_digraph(_str);
    }
    
    static when_spanned = function() {
        return reader.span_digraph(digraph);
    }
    
    static when_skipped = function() {
        return reader.skip_digraph(digraph);
    }
    
    static when_peeked = function() {
        return undefined;
    }
    
    static when_read = function() {
        return undefined;
    }
    
    static when_read_into_target = function(_target) {
        return reader.read_digraph_into(digraph, _target);
    }
    
    // -----
    // Tests
    // -----
    
    static should_ignore_digraph_on_empty_string = function() {
        given_content("");
        given_digraph("+=");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_ignore_digraph_on_short_string = function() {
        given_content("+");
        given_digraph("+=");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_digraph_on_digraph_string = function() {
        given_content("+=");
        given_digraph("+=");
        when_method_family_tested();
        
        then_expect_span(2);
        then_expect_string("+=");
        then_expect_positions(0, 2);
    }
    
    static should_handle_digraph_when_matched = function() {
        given_content("+=123");
        given_digraph("+=");
        when_method_family_tested();
        
        then_expect_span(2);
        then_expect_string("+=");
        then_expect_positions(0, 2);
    }
    
    static should_ignore_digraph_when_not_matched = function() {
        given_content("+-123");
        given_digraph("+=");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_nonascii_digraph_when_matched = function() {
        given_content("żółć");
        given_digraph("ż");
        when_method_family_tested();
        
        then_expect_span(2);
        then_expect_string("ż");
        then_expect_positions(0, 2);
    }
    
    static should_ignore_nonascii_digraph_when_not_matched = function() {
        given_content("ŻÓŁĆ");
        given_digraph("ż");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_digraph_in_the_middle = function() {
        given_content("test += 123;");
        given_position(5);
        given_digraph("+=");
        when_method_family_tested();
        
        then_expect_span(2);
        then_expect_string("+=");
        then_expect_positions(5, 7);
    }
    
    static should_not_create_digraph_from_non_string = function() {
        try
        {
            var _value = strewt_digraph(123);
            assert_fail($"Creating a multigraph from a non-string should fail, but it didn't.");
        }
        catch (_ex)
        {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("multigraph_invalid_type", _ex.code);
            assert_is_true(string_pos("digraph", _ex.description) > 0);
        }
    }
    
    static should_not_create_digraph_from_too_short_string = function() {
        try
        {
            var _value = strewt_digraph("e");
            assert_fail($"Creating a multigraph with invalid length should fail, but it didn't.");
        }
        catch (_ex)
        {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("multigraph_invalid_length", _ex.code);
            assert_is_true(string_pos("digraph", _ex.description) > 0);
        }
    }
    
    static should_not_create_digraph_from_too_long_string = function() {
        try
        {
            var _value = strewt_digraph("elo");
            assert_fail($"Creating a multigraph with invalid length should fail, but it didn't.");
        }
        catch (_ex)
        {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("multigraph_invalid_length", _ex.code);
            assert_is_true(string_pos("digraph", _ex.description) > 0);
        }
    }
}
