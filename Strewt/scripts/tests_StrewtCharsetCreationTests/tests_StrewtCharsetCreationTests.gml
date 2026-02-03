function StrewtCharsetCreationTests(_run, _method) : StrewtCharsetBaseTests(_run, _method) constructor {
    static test_subject = "Charset creation";
    
    static should_create_all_empty_by_default = function() {
        var _charset = new StrewtCharset();
        assert_true_indices(_charset, []);
    }
    
    static should_create_all_empty_with_false_value = function() {
        var _charset = new StrewtCharset(false);
        assert_true_indices(_charset, []);
    }
    
    static should_create_all_filled_except_zero_with_true_value = function() {
        var _charset = new StrewtCharset(true);
        assert_false_indices(_charset, [0]);
    }
    
    static should_use_input_array_as_table = function() {
        var _input = array_create_ext(256, function(i) { return i % 32 == 31; });
        var _charset = new StrewtCharset(_input);
        assert_true_indices(_charset, [31, 63, 95, 127, 159, 191, 223, 255]);
    }
    
    static should_keep_terminating_character_false_in_input_array = function() {
        var _input = array_create_ext(256, function(i) { return i % 32 != 31; });
        var _charset = new StrewtCharset(_input);
        assert_false_indices(_charset, [0, 31, 63, 95, 127, 159, 191, 223, 255]);
    }
    
    static should_reject_inputs_other_than_array_or_bool = function() {
        try {
            var _charset = new StrewtCharset("oops");
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_input", _ex.code);
        }
    }
}
