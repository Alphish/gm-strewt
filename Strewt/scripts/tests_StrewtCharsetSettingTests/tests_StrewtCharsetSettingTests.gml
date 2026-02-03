function StrewtCharsetSettingTests(_run, _method) : StrewtCharsetBaseTests(_run, _method) constructor {
    static test_subject = "Charset value setting";
    
    // -----
    // Bytes
    // -----
    
    static should_set_byte_true = function() {
        var _charset = new StrewtCharset(false).with_value(32, true);
        assert_true_indices(_charset, [32]);
    }
    
    static should_set_byte_false = function() {
        var _charset = new StrewtCharset(true).with_value(32, false);
        assert_false_indices(_charset, [0, 32]);
    }
    
    static should_include_byte = function() {
        var _charset = new StrewtCharset(false).including(32);
        assert_true_indices(_charset, [32]);
    }
    
    static should_exclude_byte = function() {
        var _charset = new StrewtCharset(true).excluding(32);
        assert_false_indices(_charset, [0, 32]);
    }
    
    // ----------
    // Characters
    // ----------
    
    static should_set_empty_string_true = function() {
        var _charset = new StrewtCharset(false).with_value("", true);
        assert_true_indices(_charset, []);
    }
    
    static should_set_empty_string_false = function() {
        var _charset = new StrewtCharset(true).with_value("", false);
        assert_false_indices(_charset, [0]);
    }
    
    static should_include_empty_string = function() {
        var _charset = new StrewtCharset(false).including("");
        assert_true_indices(_charset, []);
    }
    
    static should_exclude_empty_string = function() {
        var _charset = new StrewtCharset(true).excluding("");
        assert_false_indices(_charset, [0]);
    }
    
    static should_set_characters_true = function() {
        var _charset = new StrewtCharset(false).with_value("123", true);
        assert_true_indices(_charset, [49, 50, 51]);
    }
    
    static should_set_characters_false = function() {
        var _charset = new StrewtCharset(true).with_value("123", false);
        assert_false_indices(_charset, [0, 49, 50, 51]);
    }
    
    static should_include_characters = function() {
        var _charset = new StrewtCharset(false).including("123");
        assert_true_indices(_charset, [49, 50, 51]);
    }
    
    static should_exclude_characters = function() {
        var _charset = new StrewtCharset(true).excluding("123");
        assert_false_indices(_charset, [0, 49, 50, 51]);
    }
    
    // -----
    // Array
    // -----
    
    static should_set_empty_array_true = function() {
        var _charset = new StrewtCharset(false).with_value([], true);
        assert_true_indices(_charset, []);
    }
    
    static should_set_empty_array_false = function() {
        var _charset = new StrewtCharset(true).with_value([], false);
        assert_false_indices(_charset, [0]);
    }
    
    static should_include_empty_array = function() {
        var _charset = new StrewtCharset(false).including([]);
        assert_true_indices(_charset, []);
    }
    
    static should_exclude_empty_array = function() {
        var _charset = new StrewtCharset(true).excluding([]);
        assert_false_indices(_charset, [0]);
    }
    
    static should_set_items_true = function() {
        var _charset = new StrewtCharset(false).with_value([32, "123"], true);
        assert_true_indices(_charset, [32, 49, 50, 51]);
    }
    
    static should_set_items_false = function() {
        var _charset = new StrewtCharset(true).with_value([32, "123"], false);
        assert_false_indices(_charset, [0, 32, 49, 50, 51]);
    }
    
    static should_include_items = function() {
        var _charset = new StrewtCharset(false).including([32, "123"]);
        assert_true_indices(_charset, [32, 49, 50, 51]);
    }
    
    static should_exclude_items = function() {
        var _charset = new StrewtCharset(true).excluding([32, "123"]);
        assert_false_indices(_charset, [0, 32, 49, 50, 51]);
    }
    
    // -------
    // Invalid
    // -------
    
    static should_reject_negative_byte = function() {
        try {
            var _charset = new StrewtCharset().with_value(-1, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
    
    static should_reject_zero_byte = function() {
        try {
            var _charset = new StrewtCharset().with_value(0, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
    
    static should_reject_too_large_byte = function() {
        try {
            var _charset = new StrewtCharset().with_value(256, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
    
    static should_reject_nonascii_character = function() {
        try {
            var _charset = new StrewtCharset().with_value("Ż", true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
    
    static should_reject_non_target = function() {
        try {
            var _charset = new StrewtCharset().with_value({}, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
}
