function StrewtCharsetRangeTests(_run, _method) : StrewtCharsetBaseTests(_run, _method) constructor {
    static test_subject = "Charset range setting";
    
    // -----
    // Bytes
    // -----
    
    static should_set_single_byte_range_true = function() {
        var _charset = new StrewtCharset(false).with_range_value(32, 32, true);
        assert_true_indices(_charset, [32]);
    }
    
    static should_set_single_byte_range_false = function() {
        var _charset = new StrewtCharset(true).with_range_value(32, 32, false);
        assert_false_indices(_charset, [0, 32]);
    }
    
    static should_include_single_byte_range = function() {
        var _charset = new StrewtCharset(false).including_range(32, 32);
        assert_true_indices(_charset, [32]);
    }
    
    static should_exclude_single_byte_range = function() {
        var _charset = new StrewtCharset(true).excluding_range(32, 32);
        assert_false_indices(_charset, [0, 32]);
    }
    
    static should_set_multi_byte_range_true = function() {
        var _charset = new StrewtCharset(false).with_range_value(1, 15, true);
        assert_true_indices(_charset, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    }
    
    static should_set_multi_byte_range_false = function() {
        var _charset = new StrewtCharset(true).with_range_value(1, 15, false);
        assert_false_indices(_charset, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    }
    
    static should_include_multi_byte_range = function() {
        var _charset = new StrewtCharset(false).including_range(1, 15);
        assert_true_indices(_charset, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    }
    
    static should_exclude_multi_byte_range = function() {
        var _charset = new StrewtCharset(true).excluding_range(1, 15);
        assert_false_indices(_charset, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    }
    
    // ----------
    // Characters
    // ----------
    
    static should_set_single_character_range_true = function() {
        var _charset = new StrewtCharset(false).with_range_value(" ", " ", true);
        assert_true_indices(_charset, [32]);
    }
    
    static should_set_single_character_range_false = function() {
        var _charset = new StrewtCharset(true).with_range_value(" ", " ", false);
        assert_false_indices(_charset, [0, 32]);
    }
    
    static should_include_single_character_range = function() {
        var _charset = new StrewtCharset(false).including_range(" ", " ");
        assert_true_indices(_charset, [32]);
    }
    
    static should_exclude_single_character_range = function() {
        var _charset = new StrewtCharset(true).excluding_range(" ", " ");
        assert_false_indices(_charset, [0, 32]);
    }

    static should_set_multi_character_range_true = function() {
        var _charset = new StrewtCharset(false).with_range_value("1", "9", true);
        assert_true_indices(_charset, [49, 50, 51, 52, 53, 54, 55, 56, 57]);
    }
    
    static should_set_multi_character_range_false = function() {
        var _charset = new StrewtCharset(true).with_range_value("1", "9", false);
        assert_false_indices(_charset, [0, 49, 50, 51, 52, 53, 54, 55, 56, 57]);
    }
    
    static should_include_multi_character_range = function() {
        var _charset = new StrewtCharset(false).including_range("1", "9");
        assert_true_indices(_charset, [49, 50, 51, 52, 53, 54, 55, 56, 57]);
    }
    
    static should_exclude_multi_character_range = function() {
        var _charset = new StrewtCharset(true).excluding_range("1", "9");
        assert_false_indices(_charset, [0, 49, 50, 51, 52, 53, 54, 55, 56, 57]);
    }
    
    // -----
    // Mixed
    // -----
    
    static should_set_number_to_character_range = function() {
        var _charset = new StrewtCharset(false).with_range_value(48, "3", true);
        assert_true_indices(_charset, [48, 49, 50, 51]);
    }
    
    static should_set_character_to_number_range = function() {
        var _charset = new StrewtCharset(false).with_range_value("0", 51, true);
        assert_true_indices(_charset, [48, 49, 50, 51]);
    }
    
    // -------
    // Invalid
    // -------
    
    static should_reject_negative_byte_from = function() {
        try {
            var _charset = new StrewtCharset().with_range_value(-1, 32, true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_too_large_byte_to = function() {
        try {
            var _charset = new StrewtCharset().with_range_value(32, 256, true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_empty_character_from = function() {
        try {
            var _charset = new StrewtCharset().with_range_value("", 32, true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_multi_character_from = function() {
        try {
            var _charset = new StrewtCharset().with_range_value("12", 32, true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_nonascii_character_from = function() {
        try {
            var _charset = new StrewtCharset().with_range_value("Ż", 32, true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_empty_character_to = function() {
        try {
            var _charset = new StrewtCharset().with_range_value(32, "", true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_multi_character_to = function() {
        try {
            var _charset = new StrewtCharset().with_range_value(32, "42", true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_nonascii_character_to = function() {
        try {
            var _charset = new StrewtCharset().with_range_value(32, "Ż", true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_swapped_range_bytes = function() {
        try {
            var _charset = new StrewtCharset().with_range_value(57, 48, true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_order", _ex.code);
        }
    }
    
    static should_reject_swapped_range_characters = function() {
        try {
            var _charset = new StrewtCharset().with_range_value("9", "0", true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_order", _ex.code);
        }
    }
    
    static should_reject_swapped_mixed_range = function() {
        try {
            var _charset = new StrewtCharset().with_range_value(57, "0", true);
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("charset_invalid_range_order", _ex.code);
        }
    }
}
