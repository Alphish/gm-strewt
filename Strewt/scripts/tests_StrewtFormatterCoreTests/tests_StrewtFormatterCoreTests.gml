function StrewtFormatterCoreTests(_run, _method) : StrewtFormatterBaseTests(_run, _method) constructor {
    static test_subject = "Example formatter";
    
    static should_format_empty_input = function() {
        given_formatter_of([]);
        when_formatted();
        expect_result("");
        expect_cleanup();
    }
    
    static should_format_valid_input = function() {
        given_formatter_of(["Lorem", "Ipsum", "Dolor"]);
        when_formatted();
        expect_result("Lorem\nIpsum\nDolor\n");
        expect_cleanup();
    }
    
    static should_format_input_with_indents = function() {
        given_formatter_of(["open", ">", "inner1", "inner2", "<", "close"]);
        when_formatted();
        expect_result("open\n    inner1\n    inner2\nclose\n");
        expect_cleanup();
    }
    
    static should_format_input_with_blank_lines = function() {
        given_formatter_of(["open", ">", "inner1", "inner2", "", "<", "close"]);
        when_formatted();
        expect_result("open\n    inner1\n    inner2\n\nclose\n");
        expect_cleanup();
    }
}
