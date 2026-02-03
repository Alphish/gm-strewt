function StrewtChartableSettingTests(_run, _method) : StrewtChartableBaseTests(_run, _method) constructor {
    static test_subject = "Chartable value setting";
    
    // -----
    // Valid
    // -----
    
    static should_set_byte = function() {
        var _chartable = new StrewtChartable().with_value(32, "space");
        assert_indices_value(_chartable, [32], "space");
    }
    
    static should_set_empty_string = function() {
        var _chartable = new StrewtChartable().with_value("", "none");
        assert_indices_value(_chartable, [], "none");
    }
    
    static should_set_multiple_characters = function() {
        var _chartable = new StrewtChartable().with_value("123456789", "digit");
        assert_indices_value(_chartable, [49, 50, 51, 52, 53, 54, 55, 56, 57], "digit");
    }
    
    static should_set_empty_array = function() {
        var _chartable = new StrewtChartable().with_value([], "none");
        assert_indices_value(_chartable, [], "none");
    }
    
    static should_set_multiple_items = function() {
        var _chartable = new StrewtChartable(false).with_value([32, "123"], "stuff");
        assert_indices_value(_chartable, [32, 49, 50, 51], "stuff");
    }
    
    // -------
    // Invalid
    // -------
    
    static should_reject_negative_byte = function() {
        try {
            var _chartable = new StrewtChartable().with_value(-1, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
    
    static should_reject_zero_byte = function() {
        try {
            var _chartable = new StrewtChartable().with_value(0, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
    
    static should_reject_too_large_byte = function() {
        try {
            var _chartable = new StrewtChartable().with_value(256, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
    
    static should_reject_nonascii_character = function() {
        try {
            var _chartable = new StrewtChartable().with_value("Ż", true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
    
    static should_reject_non_target = function() {
        try {
            var _chartable = new StrewtChartable().with_value({}, true);
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("chartable_invalid_target", _ex.code);
        }
    }
}
