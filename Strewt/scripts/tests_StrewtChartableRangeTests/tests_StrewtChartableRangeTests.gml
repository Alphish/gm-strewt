function StrewtChartableRangeTests(_run, _method) : StrewtChartableBaseTests(_run, _method) constructor {
    static test_subject = "Chartable range setting";
    
    // -----
    // Valid
    // -----
    
    static should_set_single_byte_range = function() {
        var _chartable = new StrewtChartable().with_range_value(32, 32, "space");
        assert_indices_value(_chartable, [32], "space");
    }
    
    static should_set_multi_byte_range = function() {
        var _chartable = new StrewtChartable().with_range_value(1, 15, "low");
        assert_indices_value(_chartable, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], "low");
    }
    
    static should_set_single_character_range = function() {
        var _chartable = new StrewtChartable().with_range_value(" ", " ", "space");
        assert_indices_value(_chartable, [32], "space");
    }
    
    static should_set_multi_character_range_true = function() {
        var _chartable = new StrewtChartable().with_range_value("1", "9", "digit");
        assert_indices_value(_chartable, [49, 50, 51, 52, 53, 54, 55, 56, 57], "digit");
    }
    
    static should_set_number_to_character_range = function() {
        var _chartable = new StrewtChartable().with_range_value(48, "3", "0123");
        assert_indices_value(_chartable, [48, 49, 50, 51], "0123");
    }
    
    static should_set_character_to_number_range = function() {
        var _chartable = new StrewtChartable().with_range_value("0", 51, "0123");
        assert_indices_value(_chartable, [48, 49, 50, 51], "0123");
    }
    
    static should_set_multiple_ranges = function() {
        var _chartable = new StrewtChartable().with_range_value("0", "9", "digit").with_range_value("A", "Z", "letter");
        assert_indices_value(_chartable, [48, 49, 50, 51, 52, 53, 54, 55, 56, 57], "digit");
        assert_indices_value(_chartable, [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90], "letter");
    }
    
    // -------
    // Invalid
    // -------
    
    static should_reject_negative_byte_from = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value(-1, 32, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_zero_byte_from = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value(0, 32, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_too_large_byte_to = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value(32, 256, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_empty_character_from = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value("", 32, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_multi_character_from = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value("12", 32, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_nonascii_character_from = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value("Ż", 32, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_empty_character_to = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value(32, "", true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_multi_character_to = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value(32, "42", true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_nonascii_character_to = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value(32, "Ż", true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_end", _ex.code);
        }
    }
    
    static should_reject_swapped_range_bytes = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value(57, 48, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_order", _ex.code);
        }
    }
    
    static should_reject_swapped_range_characters = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value("9", "0", true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_order", _ex.code);
        }
    }
    
    static should_reject_swapped_mixed_range = function() {
        try {
            var _chartable = new StrewtChartable().with_range_value(57, "0", true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_range_order", _ex.code);
        }
    }
}
