function StrewtParserCoreTests(_run, _method) : StrewtParserBaseTests(_run, _method) constructor {
    static test_subject = "Example parser";
    
    static should_read_valid_content = function() {
        given_parser().for_content(">Lorem\n>Ipsum\n>Dolor");
        when_parsed();
        assert_equal(parse_result, parser.result);
        expect_parse_result(["Lorem", "Ipsum", "Dolor"]);
        expect_cleanup();
    }
    
    static should_fail_reading_content_with_forbidden_character = function() {
        given_parser().for_content(">This is\n>bad! Really bad\n>Oh no...");
        when_parsed();
        assert_is_undefined(parse_result);
        assert_array_equal(["This is"], parser.collected_lines);
        expect_parse_error(2, 5, 13, "Error at Ln: 2 Col: 5: DON'T SHOUT!!!");
        expect_cleanup();
    }
    
    static should_fail_reading_content_completed_too_early = function() {
        given_parser().for_content(">Lorem\n>Ipsum\nDolor"); // mind the lack of ">" before "Dolor"
        when_parsed();
        assert_is_undefined(parse_result);
        assert_array_equal(["Lorem", "Ipsum"], parser.collected_lines);
        expect_parse_error(3, 1, 14, "Error at Ln: 3 Col: 1: Attempting to complete parsing before the whole text was processed.");
        expect_cleanup();
    }
    
    static should_fail_reading_content_without_resolved_result = function() {
        given_parser().for_content("");
        when_parsed();
        assert_is_undefined(parse_result);
        assert_array_equal([], parser.collected_lines);
        expect_parse_error(1, 1, 0, "Error at Ln: 1 Col: 1: At least one content line was expected.");
        expect_cleanup();
    }
}
