function StrewtReaderChartableTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Chartable reading";
    
    // ----
    // Peek
    // ----
    
    static should_peek_zero_entry_on_empty_string = function() {
        given_content("");
        var _chartable = new StrewtChartable("default", "zero");
        when(reader.peek_chartable(_chartable));
        expect_result_position("zero", 0);
    }
    
    static should_peek_known_entry_before_specified_byte = function() {
        given_content("123");
        var _chartable = new StrewtChartable().with_range_value("0", "9", "digit");
        when(reader.peek_chartable(_chartable));
        expect_result_position("digit", 0);
    }
    
    static should_peek_same_entry_upon_repetition = function() {
        given_content("1ABC");
        var _chartable = new StrewtChartable().with_range_value("0", "9", "digit").with_range_value("A", "Z", "letter");
        when(reader.peek_chartable(_chartable));
        expect_result_position("digit", 0);
        when(reader.peek_chartable(_chartable));
        expect_result_position("digit", 0);
    }
    
    static should_peek_default_before_unspecified_byte = function() {
        given_content("Lorem ipsum");
        var _chartable = new StrewtChartable("default", "zero").with_range_value("0", "9", "digit");
        when(reader.peek_chartable(_chartable));
        expect_result_position("default", 0);
    }
    
    static should_peek_entry_from_middle = function() {
        given_content("AREA12345");
        var _chartable = new StrewtChartable().with_range_value("0", "9", "digit").with_range_value("A", "Z", "letter");
        reader.move_to(6);
        when(reader.peek_chartable(_chartable));
        expect_result_position("digit", 6);
    }
    
    // ----
    // Read
    // ----
    
    static should_read_zero_entry_on_empty_string = function() {
        given_content("");
        var _chartable = new StrewtChartable("default", "zero");
        when(reader.read_chartable(_chartable));
        expect_result_position("zero", 0);
    }
    
    static should_read_known_entry_before_specified_byte = function() {
        given_content("123");
        var _chartable = new StrewtChartable().with_range_value("0", "9", "digit");
        when(reader.read_chartable(_chartable));
        expect_result_position("digit", 1);
    }
    
    static should_read_next_entry_upon_repetition = function() {
        given_content("1ABC");
        var _chartable = new StrewtChartable().with_range_value("0", "9", "digit").with_range_value("A", "Z", "letter");
        when(reader.read_chartable(_chartable));
        expect_result_position("digit", 1);
        when(reader.read_chartable(_chartable));
        expect_result_position("letter", 2);
    }
    
    static should_read_default_before_unspecified_byte = function() {
        given_content("Lorem ipsum");
        var _chartable = new StrewtChartable("default", "zero").with_range_value("0", "9", "digit");
        when(reader.read_chartable(_chartable));
        expect_result_position("default", 1);
    }
}
