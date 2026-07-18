function StrewtFormatterOptionsTests(_run, _method) : StrewtFormatterBaseTests(_run, _method) constructor {
    static test_subject = "Example formatter";
    
    static should_format_valid_input_with_defaults = function() {
        given_formatter_of(["open", ">", "inner1", "inner2", "", "<", "close"]);
        when_formatted();
        expect_result("open\n    inner1\n    inner2\n\nclose\n");
        expect_cleanup();
    }
    
    static should_format_valid_input_with_custom_newline = function() {
        given_formatter_of(["open", ">", "inner1", "inner2", "", "<", "close"]).with_newline_sequence("\r\n");
        when_formatted();
        expect_result("open\r\n    inner1\r\n    inner2\r\n\r\nclose\r\n");
        expect_cleanup();
    }
    
    static should_format_valid_input_with_custom_indentation = function() {
        given_formatter_of(["open", ">", "inner1", "inner2", "", "<", "close"]).with_default_indent_unit("\t");
        when_formatted();
        expect_result("open\n\tinner1\n\tinner2\n\nclose\n");
        expect_cleanup();
    }
    
    static should_format_valid_input_with_blank_lines = function() {
        given_formatter_of(["open", ">", "inner1", "inner2", "", "<", "close"]).indenting_blank_lines();
        when_formatted();
        expect_result("open\n    inner1\n    inner2\n    \nclose\n");
        expect_cleanup();
    }
    
    static should_format_valid_input_with_manual_cleanup = function() {
        given_formatter_of(["open", ">", "inner1", "inner2", "", "<", "close"]).with_manual_cleanup();
        when_formatted();
        expect_result("open\n    inner1\n    inner2\n\nclose\n");
        expect_no_cleanup();
        
        formatter.cleanup();
        expect_cleanup();
    }
}
