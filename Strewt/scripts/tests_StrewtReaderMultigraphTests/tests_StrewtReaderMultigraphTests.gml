function StrewtReaderMultigraphTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Multigraph checking";
    
    // --------
    // Digraphs
    // --------
    
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
    
    static should_not_skip_digraph_on_empty_string = function() {
        var _value = strewt_digraph("+=");
        given_content("");
        when(reader.try_skip_digraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_not_skip_digraph_on_single_character_string = function() {
        var _value = strewt_digraph("+=");
        given_content("+");
        when(reader.try_skip_digraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_skip_digraph_on_digraph_string = function() {
        var _value = strewt_digraph("+=");
        given_content("+=");
        when(reader.try_skip_digraph(_value));
        expect_result_position(true, 2);
    }
    
    static should_skip_digraph_before_matching_sequence = function() {
        var _value = strewt_digraph("+=");
        given_content("+=123");
        when(reader.try_skip_digraph(_value));
        expect_result_position(true, 2);
    }
    
    static should_not_skip_digraph_before_different_sequence = function() {
        var _value = strewt_digraph("+=");
        given_content("+-123");
        when(reader.try_skip_digraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_skip_nonascii_digraph_before_matching_sequence = function() {
        var _value = strewt_digraph("ż");
        given_content("żółć");
        when(reader.try_skip_digraph(_value));
        expect_result_position(true, 2);
    }
    
    static should_not_skip_nonascii_digraph_before_different_sequence = function() {
        var _value = strewt_digraph("ż");
        given_content("ŻÓŁĆ");
        when(reader.try_skip_digraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_skip_digraph_repeatedly_until_end = function() {
        var _value = strewt_digraph("+=");
        given_content("+=+=+=");
        
        when(reader.try_skip_digraph(_value));
        expect_result_position(true, 2);
        when(reader.try_skip_digraph(_value));
        expect_result_position(true, 4);
        when(reader.try_skip_digraph(_value));
        expect_result_position(true, 6);
        
        when(reader.try_skip_digraph(_value));
        expect_result_position(false, 6);
    }
    
    static should_not_peek_digraph_on_empty_string = function() {
        var _value = strewt_digraph("+=");
        given_content("");
        when(reader.peeks_digraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_not_peek_digraph_on_single_character_string = function() {
        var _value = strewt_digraph("+=");
        given_content("+");
        when(reader.peeks_digraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_peek_digraph_on_digraph_string = function() {
        var _value = strewt_digraph("+=");
        given_content("+=");
        when(reader.peeks_digraph(_value));
        expect_result_position(true, 0);
    }
    
    static should_peek_digraph_before_matching_sequence = function() {
        var _value = strewt_digraph("+=");
        given_content("+=123");
        when(reader.peeks_digraph(_value));
        expect_result_position(true, 0);
    }
    
    static should_not_peek_digraph_before_different_sequence = function() {
        var _value = strewt_digraph("+=");
        given_content("+-123");
        when(reader.peeks_digraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_peek_nonascii_digraph_before_matching_sequence = function() {
        var _value = strewt_digraph("ż");
        given_content("żółć");
        when(reader.peeks_digraph(_value));
        expect_result_position(true, 0);
    }
    
    static should_not_peek_nonascii_digraph_before_different_sequence = function() {
        var _value = strewt_digraph("ż");
        given_content("ŻÓŁĆ");
        when(reader.peeks_digraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_peek_digraph_in_the_middle = function() {
        var _value = strewt_digraph("+=");
        given_content("test += 123;");
        
        reader.move_to(5);
        when(reader.peeks_digraph(_value));
        expect_result_position(true, 5);
    }
    
    // ---------
    // Trigraphs
    // ---------
    
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
    
    static should_not_skip_trigraph_on_empty_string = function() {
        var _value = strewt_trigraph("??=");
        given_content("");
        when(reader.try_skip_trigraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_not_skip_trigraph_on_short_string = function() {
        var _value = strewt_trigraph("??=");
        given_content("??");
        when(reader.try_skip_trigraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_skip_trigraph_on_trigraph_string = function() {
        var _value = strewt_trigraph("??=");
        given_content("??=");
        when(reader.try_skip_trigraph(_value));
        expect_result_position(true, 3);
    }
    
    static should_skip_trigraph_before_matching_sequence = function() {
        var _value = strewt_trigraph("??=");
        given_content("??=123");
        when(reader.try_skip_trigraph(_value));
        expect_result_position(true, 3);
    }
    
    static should_not_skip_trigraph_before_different_sequence = function() {
        var _value = strewt_trigraph("??=");
        given_content("+-123");
        when(reader.try_skip_trigraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_skip_nonascii_trigraph_before_matching_sequence = function() {
        var _value = strewt_trigraph("日");
        given_content("日本");
        when(reader.try_skip_trigraph(_value));
        expect_result_position(true, 3);
    }
    
    static should_not_skip_nonascii_trigraph_before_different_sequence = function() {
        var _value = strewt_trigraph("日");
        given_content("中国");
        when(reader.try_skip_trigraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_skip_trigraph_repeatedly_until_end = function() {
        var _value = strewt_trigraph("??=");
        given_content("??=??=??=");
        
        when(reader.try_skip_trigraph(_value));
        expect_result_position(true, 3);
        when(reader.try_skip_trigraph(_value));
        expect_result_position(true, 6);
        when(reader.try_skip_trigraph(_value));
        expect_result_position(true, 9);
        
        when(reader.try_skip_trigraph(_value));
        expect_result_position(false, 9);
    }
    
    static should_not_peek_trigraph_on_empty_string = function() {
        var _value = strewt_trigraph("??=");
        given_content("");
        when(reader.peeks_trigraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_not_peek_trigraph_on_short_string = function() {
        var _value = strewt_trigraph("??=");
        given_content("??");
        when(reader.peeks_trigraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_peek_trigraph_on_trigraph_string = function() {
        var _value = strewt_trigraph("??=");
        given_content("??=");
        when(reader.peeks_trigraph(_value));
        expect_result_position(true, 0);
    }
    
    static should_peek_trigraph_before_matching_sequence = function() {
        var _value = strewt_trigraph("??=");
        given_content("??=123");
        when(reader.peeks_trigraph(_value));
        expect_result_position(true, 0);
    }
    
    static should_not_peek_trigraph_before_different_sequence = function() {
        var _value = strewt_trigraph("??=");
        given_content("+-123");
        when(reader.peeks_trigraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_peek_nonascii_trigraph_before_matching_sequence = function() {
        var _value = strewt_trigraph("日");
        given_content("日本");
        when(reader.peeks_trigraph(_value));
        expect_result_position(true, 0);
    }
    
    static should_not_peek_nonascii_trigraph_before_different_sequence = function() {
        var _value = strewt_trigraph("日");
        given_content("中国");
        when(reader.peeks_trigraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_peek_trigraph_in_the_middle = function() {
        var _value = strewt_trigraph("??=");
        given_content("test ??= 123;");
        
        reader.move_to(5);
        when(reader.peeks_trigraph(_value));
        expect_result_position(true, 5);
    }
    
    // -----------
    // Tetragraphs
    // -----------
    
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
    
    static should_not_skip_tetragraph_on_empty_string = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("");
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_not_skip_tetragraph_on_short_string = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("///");
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_skip_tetragraph_on_tetragraph_string = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("/// ");
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(true, 4);
    }
    
    static should_skip_tetragraph_before_matching_sequence = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("/// @desc Collision code");
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(true, 4);
    }
    
    static should_not_skip_tetragraph_before_different_sequence = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("// just a comment");
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_skip_nonascii_tetragraph_before_matching_sequence = function() {
        var _value = strewt_tetragraph("łą");
        given_content("łącznik");
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(true, 4);
    }
    
    static should_not_skip_nonascii_tetragraph_before_different_sequence = function() {
        var _value = strewt_tetragraph("łą");
        given_content("łucznik");
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_skip_tetragraph_repeatedly_until_end = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("/// /// /// ");
        
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(true, 4);
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(true, 8);
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(true, 12);
        
        when(reader.try_skip_tetragraph(_value));
        expect_result_position(false, 12);
    }
    
    static should_not_peek_tetragraph_on_empty_string = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("");
        when(reader.peeks_tetragraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_not_peek_tetragraph_on_short_string = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("///");
        when(reader.peeks_tetragraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_peek_tetragraph_on_tetragraph_string = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("/// ");
        when(reader.peeks_tetragraph(_value));
        expect_result_position(true, 0);
    }
    
    static should_peek_tetragraph_before_matching_sequence = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("/// @desc Collision code");
        when(reader.peeks_tetragraph(_value));
        expect_result_position(true, 0);
    }
    
    static should_not_peek_tetragraph_before_different_sequence = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("// just a comment");
        when(reader.peeks_tetragraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_peek_nonascii_tetragraph_before_matching_sequence = function() {
        var _value = strewt_tetragraph("łą");
        given_content("łącznik");
        when(reader.peeks_tetragraph(_value));
        expect_result_position(true, 0);
    }
    
    static should_not_peek_nonascii_tetragraph_before_different_sequence = function() {
        var _value = strewt_tetragraph("łą");
        given_content("łucznik");
        when(reader.peeks_tetragraph(_value));
        expect_result_position(false, 0);
    }
    
    static should_peek_tetragraph_in_the_middle = function() {
        var _value = strewt_tetragraph("/// ");
        given_content("test(); /// disable-warning");
        
        reader.move_to(8);
        when(reader.peeks_tetragraph(_value));
        expect_result_position(true, 8);
    }
}
