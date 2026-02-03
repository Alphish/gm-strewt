function StrewtChartableCreationTests(_run, _method) : StrewtChartableBaseTests(_run, _method) constructor {
    static test_subject = "Chartable creation";
    
    static should_create_all_undefined_by_default = function() {
        var _chartable = new StrewtChartable();
        for (var i = 0; i < 256; i++) {
            assert_is_undefined(_chartable.table[i]);
        }
    }
    
    static should_create_all_filled_except_zero_with_given_value = function() {
        var _chartable = new StrewtChartable("test");
        assert_is_undefined(_chartable.table[0]);
        for (var i = 1; i < 256; i++) {
            assert_equal("test", _chartable.table[i]);
        }
    }
    
    static should_customize_zero_value_with_second_argument = function() {
        var _chartable = new StrewtChartable("nonzero", "zero");
        assert_equal("zero", _chartable.table[0]);
        for (var i = 1; i < 256; i++) {
            assert_equal("nonzero", _chartable.table[i]);
        }
    }
    
    static should_use_input_array_as_table_except_zero = function() {
        var _input = array_create_ext(256, function(i) { return i; });
        var _chartable = new StrewtChartable(_input);
        assert_equal(undefined, _chartable.table[0]);
        for (var i = 1; i < 256; i++) {
            assert_equal(i, _chartable.table[i]);
        }
    }
    
    static should_use_input_array_as_table_with_zero_override = function() {
        var _input = array_create_ext(256, function(i) { return i; });
        var _chartable = new StrewtChartable(_input, -1);
        assert_equal(-1, _chartable.table[0]);
        for (var i = 1; i < 256; i++) {
            assert_equal(i, _chartable.table[i]);
        }
    }
}
