function StrewtParserFileTests(_run, _method) : StrewtParserBaseTests(_run, _method) constructor {
    static test_subject = "File parser";
    
    static should_read_good_file = function() {
        given_parser().for_file("tests/good_test.txt");
        when_parsed();
        assert_equal(parse_result, parser.result);
        expect_parse_result(["Lorem", "Ipsum", "Dolor"]);
        expect_cleanup();
    }
    
    static should_read_bad_file = function() {
        given_parser().for_file("tests/bad_test.txt");
        when_parsed();
        assert_is_undefined(parse_result);
        expect_parse_error(2, 5, 13, "Error in bad_test.txt at Ln: 2 Col: 5: DON'T SHOUT!!!");
        expect_cleanup();
    }
    
    static should_read_bad_file_without_source_name = function() {
        given_parser().for_file("tests/bad_test.txt", /* as source name */ false);
        when_parsed();
        assert_is_undefined(parse_result);
        expect_parse_error(2, 5, 13, "Error at Ln: 2 Col: 5: DON'T SHOUT!!!");
        expect_cleanup();
    }
    
    static should_read_bad_file_with_previous_source = function() {
        given_parser().with_source_name("BAD CASE").for_file("tests/bad_test.txt");
        when_parsed();
        assert_is_undefined(parse_result);
        expect_parse_error(2, 5, 13, "Error in BAD CASE at Ln: 2 Col: 5: DON'T SHOUT!!!");
        expect_cleanup();
    }
    
    static should_read_bad_file_with_subsequent_source = function() {
        given_parser().for_file("tests/bad_test.txt").with_source_name("BAD CASE");
        when_parsed();
        assert_is_undefined(parse_result);
        expect_parse_error(2, 5, 13, "Error in BAD CASE at Ln: 2 Col: 5: DON'T SHOUT!!!");
        expect_cleanup();
    }
    
    static should_throw_when_neither_content_nor_file_was_given = function() {
        given_parser();
        try {
            parser.init();
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("parser_invalid_filename", _ex.code);
        }
    }
    
    static should_throw_when_given_non_string_filename = function() {
        given_parser().for_file(["tests/good_test.txt"]);
        try {
            parser.init();
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("parser_invalid_filename", _ex.code);
        }
    }
    
    static should_throw_when_given_nonexistent_file = function() {
        given_parser().for_file("tests/this_file_does_not_exist.txt");
        try {
            parser.init();
            assert_fail($"Expected the code to fail, but it didn't.");
        } catch (_ex) {
            assert_is_instanceof_struct(StrewtException, _ex);
            assert_equal("parser_invalid_filename", _ex.code);
        }
    }
}
