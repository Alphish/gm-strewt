function StrewtCharsetCreationTests(_run, _method) : StrewtCharsetBaseTests(_run, _method) constructor {
    static test_subject = "Charset creation";
    
    static should_create_all_empty_by_default = function() {
        var _charset = strewt_charset_create();
        assert_true_indices(_charset, []);
    }
    
    static should_create_all_empty_with_false_value = function() {
        var _charset = strewt_charset_create(false);
        assert_true_indices(_charset, []);
    }
    
    static should_create_all_filled_except_zero_with_true_value = function() {
        var _charset = strewt_charset_create(true);
        assert_false_indices(_charset, [0]);
    }
    
    static should_use_input_array_as_table = function() {
        var _input = array_create_ext(256, function(i) { return i % 32 == 31; });
        var _charset = strewt_charset_create(_input);
        assert_true_indices(_charset, [31, 63, 95, 127, 159, 191, 223, 255]);
    }
    
    static should_keep_terminating_character_false_in_input_array = function() {
        var _input = array_create_ext(256, function(i) { return i % 32 != 31; });
        var _charset = strewt_charset_create(_input);
        assert_false_indices(_charset, [0, 31, 63, 95, 127, 159, 191, 223, 255]);
    }
    
    static should_create_charset_from_string_including_by_default = function() {
        var _charset = strewt_charset_from_string("0123456789");
        assert_true_indices(_charset, [48, 49, 50, 51, 52, 53, 54, 55, 56, 57]);
    }
    
    static should_create_charset_including_given_string = function() {
        var _charset = strewt_charset_from_string("0123456789", true);
        assert_true_indices(_charset, [48, 49, 50, 51, 52, 53, 54, 55, 56, 57]);
    }
    
    static should_create_charset_excluding_given_string = function() {
        var _charset = strewt_charset_from_string("0123456789", false);
        assert_false_indices(_charset, [0, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57]);
    }
    
    static should_reject_inputs_other_than_array_or_bool = function() {
        try {
            var _charset = new StrewtCharset("oops");
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("invalid_type", _ex.code);
        }
    }
    
    static should_reject_creation_from_string_given_non_string = function() {
        try {
            var _charset = strewt_charset_from_string(48);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("invalid_type", _ex.code);
        }
    }
}
