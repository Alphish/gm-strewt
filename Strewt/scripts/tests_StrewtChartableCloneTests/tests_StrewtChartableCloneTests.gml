function StrewtChartableCloneTests(_run, _method) : StrewtChartableBaseTests(_run, _method) constructor {
    static test_subject = "Derived chartable";
    
    static should_be_clone_with_original_values = function() {
        var _original = new StrewtChartable("test");
        var _clone = _original.clone();
        assert_is_undefined(_clone.table[0]);
        for (var i = 1; i < 256; i++) {
            assert_equal("test", _clone.table[i]);
        }
    }
    
    static should_be_clone_with_zero_value_carried_over = function() {
        var _original = new StrewtChartable("nonzero", "zero");
        var _clone = _original.clone();
        assert_equal("zero", _clone.table[0]);
        for (var i = 1; i < 256; i++) {
            assert_equal("nonzero", _clone.table[i]);
        }
    }
}
