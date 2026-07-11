function StrewtParserOptionsTests(_run, _method) : StrewtParserBaseTests(_run, _method) constructor {
    static test_subject = "Configurable parser";
    
    static should_read_valid_content_with_defaults = function() {
        given_parser().for_content(">Lorem\n>Ipsum\n>Dolor");
        when_parsed();
        assert_equal(parse_result, parser.result);
        expect_parse_result(["Lorem", "Ipsum", "Dolor"]);
        expect_cleanup();
    }
    
    static should_read_invalid_content_with_defaults = function() {
        given_parser().for_content(">This is\n>bad! Really bad\n>Oh no...");
        when_parsed();
        assert_is_undefined(parse_result);
        expect_parse_error(2, 5, 13, "Error at Ln: 2 Col: 5: DON'T SHOUT!!!");
        expect_cleanup();
    }
    
    static should_read_valid_content_with_source_name = function() {
        given_parser().for_content(">Lorem\n>Ipsum\n>Dolor").with_source_name("given string");
        when_parsed();
        assert_equal(parse_result, parser.result);
        expect_parse_result(["Lorem", "Ipsum", "Dolor"]);
        expect_cleanup();
    }
    
    static should_read_invalid_content_with_source_name = function() {
        given_parser().for_content(">This is\n>bad! Really bad\n>Oh no...").with_source_name("given string");
        when_parsed();
        assert_is_undefined(parse_result);
        expect_parse_error(2, 5, 13, "Error in given string at Ln: 2 Col: 5: DON'T SHOUT!!!");
        expect_cleanup();
    }
    
    static should_read_valid_content_with_manual_cleanup = function() {
        given_parser().for_content(">Lorem\n>Ipsum\n>Dolor").with_manual_cleanup();
        when_parsed();
        assert_equal(parse_result, parser.result);
        expect_parse_result(["Lorem", "Ipsum", "Dolor"]);
        expect_no_cleanup();
        
        parser.cleanup();
        expect_cleanup();
    }
    
    static should_read_invalid_content_with_manual_cleanup = function() {
        given_parser().for_content(">This is\n>bad! Really bad\n>Oh no...").with_manual_cleanup();
        when_parsed();
        assert_is_undefined(parse_result);
        expect_parse_error(2, 5, 13, "Error at Ln: 2 Col: 5: DON'T SHOUT!!!");
        expect_no_cleanup();
        
        parser.cleanup();
        expect_cleanup();
    }
}
