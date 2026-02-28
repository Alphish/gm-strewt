function StrewtReaderLineTests(_run, _method) : StrewtReaderBaseTests(_run, _method) constructor {
    static test_subject = "Line checking";
    
    // --------
    // Spanning
    // --------
    
    static should_span_empty_line_on_empty_string = function() {
        given_content("");
        when(reader.span_line(/* with end */ false));
        expect_result_position(0, 0);
    }
    
    static should_span_empty_line_with_end_on_empty_string = function() {
        given_content("");
        when(reader.span_line(/* with end */ true));
        expect_result_position(0, 0);
    }
    
    static should_span_entire_string_without_linebreak = function() {
        given_content("Lorem ipsum");
        when(reader.span_line(/* with end */ false));
        expect_result_position(11, 0);
    }
    
    static should_span_entire_string_with_end_without_linebreak = function() {
        given_content("Lorem ipsum");
        when(reader.span_line(/* with end */ true));
        expect_result_position(11, 0);
    }
    
    static should_span_line_without_end_by_default = function() {
        given_content("Lorem\nIpsum");
        when(reader.span_line());
        expect_result_position(5, 0);
    }
    
    // Starting line break
    
    static should_span_line_on_starting_lf = function() {
        given_content("\nTest");
        when(reader.span_line(/* with end */ false));
        expect_result_position(0, 0);
    }
    
    static should_span_line_with_end_on_starting_lf = function() {
        given_content("\nTest");
        when(reader.span_line(/* with end */ true));
        expect_result_position(1, 0);
    }
    
    static should_span_line_on_starting_cr = function() {
        given_content("\rTest");
        when(reader.span_line(/* with end */ false));
        expect_result_position(0, 0);
    }
    
    static should_span_line_with_end_on_starting_cr = function() {
        given_content("\rTest");
        when(reader.span_line(/* with end */ true));
        expect_result_position(1, 0);
    }
    
    static should_span_line_on_starting_crlf = function() {
        given_content("\r\nTest");
        when(reader.span_line(/* with end */ false));
        expect_result_position(0, 0);
    }
    
    static should_span_line_with_end_on_starting_crlf = function() {
        given_content("\r\nTest");
        when(reader.span_line(/* with end */ true));
        expect_result_position(2, 0);
    }
    
    // Middle line break
    
    static should_span_line_on_middle_lf = function() {
        given_content("Lorem\nIpsum");
        when(reader.span_line(/* with end */ false));
        expect_result_position(5, 0);
    }
    
    static should_span_line_with_end_on_middle_lf = function() {
        given_content("Lorem\nIpsum");
        when(reader.span_line(/* with end */ true));
        expect_result_position(6, 0);
    }
    
    static should_span_line_on_middle_cr = function() {
        given_content("Lorem\rIpsum");
        when(reader.span_line(/* with end */ false));
        expect_result_position(5, 0);
    }
    
    static should_span_line_with_end_on_middle_cr = function() {
        given_content("Lorem\rIpsum");
        when(reader.span_line(/* with end */ true));
        expect_result_position(6, 0);
    }
    
    static should_span_line_on_middle_crlf = function() {
        given_content("Lorem\r\nIpsum");
        when(reader.span_line(/* with end */ false));
        expect_result_position(5, 0);
    }
    
    static should_span_line_with_end_on_middle_crlf = function() {
        given_content("Lorem\r\nIpsum");
        when(reader.span_line(/* with end */ true));
        expect_result_position(7, 0);
    }
    
    static should_span_line_on_middle_lfcr = function() {
        given_content("Lorem\n\rIpsum");
        when(reader.span_line(/* with end */ false));
        expect_result_position(5, 0);
    }
    
    static should_span_line_with_end_on_middle_lfcr = function() {
        given_content("Lorem\n\rIpsum");
        when(reader.span_line(/* with end */ true));
        expect_result_position(6, 0);
    }
    
    static should_span_line_on_middle_lflf = function() {
        given_content("Lorem\n\nIpsum");
        when(reader.span_line(/* with end */ false));
        expect_result_position(5, 0);
    }
    
    static should_span_line_with_end_on_middle_lflf = function() {
        given_content("Lorem\n\nIpsum");
        when(reader.span_line(/* with end */ true));
        expect_result_position(6, 0);
    }
    
    // Ending line break
    
    static should_span_line_on_ending_lf = function() {
        given_content("Lorem Ipsum\n");
        when(reader.span_line(/* with end */ false));
        expect_result_position(11, 0);
    }
    
    static should_span_line_with_end_on_ending_lf = function() {
        given_content("Lorem Ipsum\n");
        when(reader.span_line(/* with end */ true));
        expect_result_position(12, 0);
    }
    
    // Reading from middle
    
    static should_span_line_from_middle = function() {
        given_content("Lorem\nIpsum\nDolor");
        reader.move_to(8);
        when(reader.span_line(/* with end */ false));
        expect_result_position(3, 8);
    }
    
    static should_span_line_with_end_from_middle = function() {
        given_content("Lorem\nIpsum\nDolor");
        reader.move_to(8);
        when(reader.span_line(/* with end */ true));
        expect_result_position(4, 8);
    }
    
    // --------
    // Skipping
    // --------
    
    static should_skip_empty_line_on_empty_string = function() {
        given_content("");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(0, 0);
    }
    
    static should_skip_empty_line_with_end_on_empty_string = function() {
        given_content("");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(0, 0);
    }
    
    static should_skip_entire_string_without_linebreak = function() {
        given_content("Lorem ipsum");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(11, 11);
    }
    
    static should_skip_entire_string_with_end_without_linebreak = function() {
        given_content("Lorem ipsum");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(11, 11);
    }
    
    static should_skip_line_without_end_by_default = function() {
        given_content("Lorem\nIpsum");
        when(reader.skip_line());
        expect_result_position(5, 6);
    }
    
    // Starting line break
    
    static should_skip_line_on_starting_lf = function() {
        given_content("\nTest");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(0, 1);
    }
    
    static should_skip_line_with_end_on_starting_lf = function() {
        given_content("\nTest");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(1, 1);
    }
    
    static should_skip_line_on_starting_cr = function() {
        given_content("\rTest");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(0, 1);
    }
    
    static should_skip_line_with_end_on_starting_cr = function() {
        given_content("\rTest");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(1, 1);
    }
    
    static should_skip_line_on_starting_crlf = function() {
        given_content("\r\nTest");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(0, 2);
    }
    
    static should_skip_line_with_end_on_starting_crlf = function() {
        given_content("\r\nTest");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(2, 2);
    }
    
    // Middle line break
    
    static should_skip_line_on_middle_lf = function() {
        given_content("Lorem\nIpsum");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(5, 6);
    }
    
    static should_skip_line_with_end_on_middle_lf = function() {
        given_content("Lorem\nIpsum");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(6, 6);
    }
    
    static should_skip_line_on_middle_cr = function() {
        given_content("Lorem\rIpsum");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(5, 6);
    }
    
    static should_skip_line_with_end_on_middle_cr = function() {
        given_content("Lorem\rIpsum");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(6, 6);
    }
    
    static should_skip_line_on_middle_crlf = function() {
        given_content("Lorem\r\nIpsum");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(5, 7);
    }
    
    static should_skip_line_with_end_on_middle_crlf = function() {
        given_content("Lorem\r\nIpsum");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(7, 7);
    }
    
    static should_skip_line_on_middle_lfcr = function() {
        given_content("Lorem\n\rIpsum");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(5, 6);
    }
    
    static should_skip_line_with_end_on_middle_lfcr = function() {
        given_content("Lorem\n\rIpsum");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(6, 6);
    }
    
    static should_skip_line_on_middle_lflf = function() {
        given_content("Lorem\n\nIpsum");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(5, 6);
    }
    
    static should_skip_line_with_end_on_middle_lflf = function() {
        given_content("Lorem\n\nIpsum");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(6, 6);
    }
    
    // Ending line break
    
    static should_skip_line_on_ending_lf = function() {
        given_content("Lorem Ipsum\n");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(11, 12);
    }
    
    static should_skip_line_with_end_on_ending_lf = function() {
        given_content("Lorem Ipsum\n");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(12, 12);
    }
    
    // Reading from middle
    
    static should_skip_line_until_end = function() {
        given_content("Lorem\nIpsum\nDolor");
        when(reader.skip_line(/* with end */ false));
        expect_result_position(5, 6);
        when(reader.skip_line(/* with end */ false));
        expect_result_position(5, 12);
        when(reader.skip_line(/* with end */ false));
        expect_result_position(5, 17);
        when(reader.skip_line(/* with end */ false));
        expect_result_position(0, 17);
    }
    
    static should_skip_line_with_end_until_end = function() {
        given_content("Lorem\nIpsum\nDolor");
        when(reader.skip_line(/* with end */ true));
        expect_result_position(6, 6);
        when(reader.skip_line(/* with end */ true));
        expect_result_position(6, 12);
        when(reader.skip_line(/* with end */ true));
        expect_result_position(5, 17);
        when(reader.skip_line(/* with end */ true));
        expect_result_position(0, 17);
    }
    
    // --------
    // Peeking
    // --------
    
    static should_peek_empty_line_on_empty_string = function() {
        given_content("");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("", 0);
    }
    
    static should_peek_empty_line_with_end_on_empty_string = function() {
        given_content("");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("", 0);
    }
    
    static should_peek_entire_string_without_linebreak = function() {
        given_content("Lorem ipsum");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("Lorem ipsum", 0);
    }
    
    static should_peek_entire_string_with_end_without_linebreak = function() {
        given_content("Lorem ipsum");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("Lorem ipsum", 0);
    }
    
    static should_peek_line_without_end_by_default = function() {
        given_content("Lorem\nIpsum");
        when(reader.peek_line());
        expect_result_position("Lorem", 0);
    }
    
    // Starting line break
    
    static should_peek_line_on_starting_lf = function() {
        given_content("\nTest");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("", 0);
    }
    
    static should_peek_line_with_end_on_starting_lf = function() {
        given_content("\nTest");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("\n", 0);
    }
    
    static should_peek_line_on_starting_cr = function() {
        given_content("\rTest");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("", 0);
    }
    
    static should_peek_line_with_end_on_starting_cr = function() {
        given_content("\rTest");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("\r", 0);
    }
    
    static should_peek_line_on_starting_crlf = function() {
        given_content("\r\nTest");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("", 0);
    }
    
    static should_peek_line_with_end_on_starting_crlf = function() {
        given_content("\r\nTest");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("\r\n", 0);
    }
    
    // Middle line break
    
    static should_peek_line_on_middle_lf = function() {
        given_content("Lorem\nIpsum");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("Lorem", 0);
    }
    
    static should_peek_line_with_end_on_middle_lf = function() {
        given_content("Lorem\nIpsum");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("Lorem\n", 0);
    }
    
    static should_peek_line_on_middle_cr = function() {
        given_content("Lorem\rIpsum");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("Lorem", 0);
    }
    
    static should_peek_line_with_end_on_middle_cr = function() {
        given_content("Lorem\rIpsum");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("Lorem\r", 0);
    }
    
    static should_peek_line_on_middle_crlf = function() {
        given_content("Lorem\r\nIpsum");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("Lorem", 0);
    }
    
    static should_peek_line_with_end_on_middle_crlf = function() {
        given_content("Lorem\r\nIpsum");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("Lorem\r\n", 0);
    }
    
    static should_peek_line_on_middle_lfcr = function() {
        given_content("Lorem\n\rIpsum");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("Lorem", 0);
    }
    
    static should_peek_line_with_end_on_middle_lfcr = function() {
        given_content("Lorem\n\rIpsum");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("Lorem\n", 0);
    }
    
    static should_peek_line_on_middle_lflf = function() {
        given_content("Lorem\n\nIpsum");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("Lorem", 0);
    }
    
    static should_peek_line_with_end_on_middle_lflf = function() {
        given_content("Lorem\n\nIpsum");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("Lorem\n", 0);
    }
    
    // Ending line break
    
    static should_peek_line_on_ending_lf = function() {
        given_content("Lorem Ipsum\n");
        when(reader.peek_line(/* with end */ false));
        expect_result_position("Lorem Ipsum", 0);
    }
    
    static should_peek_line_with_end_on_ending_lf = function() {
        given_content("Lorem Ipsum\n");
        when(reader.peek_line(/* with end */ true));
        expect_result_position("Lorem Ipsum\n", 0);
    }
    
    // Reading from middle
    
    static should_peek_line_from_middle = function() {
        given_content("Lorem\nIpsum\nDolor");
        reader.move_to(8);
        when(reader.peek_line(/* with end */ false));
        expect_result_position("sum", 8);
    }
    
    static should_peek_line_with_end_from_middle = function() {
        given_content("Lorem\nIpsum\nDolor");
        reader.move_to(8);
        when(reader.peek_line(/* with end */ true));
        expect_result_position("sum\n", 8);
    }
    
    // -------
    // Reading
    // -------
    
    static should_read_empty_line_on_empty_string = function() {
        given_content("");
        when(reader.read_line(/* with end */ false));
        expect_result_position("", 0);
    }
    
    static should_read_empty_line_with_end_on_empty_string = function() {
        given_content("");
        when(reader.read_line(/* with end */ true));
        expect_result_position("", 0);
    }
    
    static should_read_entire_string_without_linebreak = function() {
        given_content("Lorem ipsum");
        when(reader.read_line(/* with end */ false));
        expect_result_position("Lorem ipsum", 11);
    }
    
    static should_read_entire_string_with_end_without_linebreak = function() {
        given_content("Lorem ipsum");
        when(reader.read_line(/* with end */ true));
        expect_result_position("Lorem ipsum", 11);
    }
    
    static should_read_line_without_end_by_default = function() {
        given_content("Lorem\nIpsum");
        when(reader.read_line());
        expect_result_position("Lorem", 6);
    }
    
    // Starting line break
    
    static should_read_line_on_starting_lf = function() {
        given_content("\nTest");
        when(reader.read_line(/* with end */ false));
        expect_result_position("", 1);
    }
    
    static should_read_line_with_end_on_starting_lf = function() {
        given_content("\nTest");
        when(reader.read_line(/* with end */ true));
        expect_result_position("\n", 1);
    }
    
    static should_read_line_on_starting_cr = function() {
        given_content("\rTest");
        when(reader.read_line(/* with end */ false));
        expect_result_position("", 1);
    }
    
    static should_read_line_with_end_on_starting_cr = function() {
        given_content("\rTest");
        when(reader.read_line(/* with end */ true));
        expect_result_position("\r", 1);
    }
    
    static should_read_line_on_starting_crlf = function() {
        given_content("\r\nTest");
        when(reader.read_line(/* with end */ false));
        expect_result_position("", 2);
    }
    
    static should_read_line_with_end_on_starting_crlf = function() {
        given_content("\r\nTest");
        when(reader.read_line(/* with end */ true));
        expect_result_position("\r\n", 2);
    }
    
    // Middle line break
    
    static should_read_line_on_middle_lf = function() {
        given_content("Lorem\nIpsum");
        when(reader.read_line(/* with end */ false));
        expect_result_position("Lorem", 6);
    }
    
    static should_read_line_with_end_on_middle_lf = function() {
        given_content("Lorem\nIpsum");
        when(reader.read_line(/* with end */ true));
        expect_result_position("Lorem\n", 6);
    }
    
    static should_read_line_on_middle_cr = function() {
        given_content("Lorem\rIpsum");
        when(reader.read_line(/* with end */ false));
        expect_result_position("Lorem", 6);
    }
    
    static should_read_line_with_end_on_middle_cr = function() {
        given_content("Lorem\rIpsum");
        when(reader.read_line(/* with end */ true));
        expect_result_position("Lorem\r", 6);
    }
    
    static should_read_line_on_middle_crlf = function() {
        given_content("Lorem\r\nIpsum");
        when(reader.read_line(/* with end */ false));
        expect_result_position("Lorem", 7);
    }
    
    static should_read_line_with_end_on_middle_crlf = function() {
        given_content("Lorem\r\nIpsum");
        when(reader.read_line(/* with end */ true));
        expect_result_position("Lorem\r\n", 7);
    }
    
    static should_read_line_on_middle_lfcr = function() {
        given_content("Lorem\n\rIpsum");
        when(reader.read_line(/* with end */ false));
        expect_result_position("Lorem", 6);
    }
    
    static should_read_line_with_end_on_middle_lfcr = function() {
        given_content("Lorem\n\rIpsum");
        when(reader.read_line(/* with end */ true));
        expect_result_position("Lorem\n", 6);
    }
    
    static should_read_line_on_middle_lflf = function() {
        given_content("Lorem\n\nIpsum");
        when(reader.read_line(/* with end */ false));
        expect_result_position("Lorem", 6);
    }
    
    static should_read_line_with_end_on_middle_lflf = function() {
        given_content("Lorem\n\nIpsum");
        when(reader.read_line(/* with end */ true));
        expect_result_position("Lorem\n", 6);
    }
    
    // Ending line break
    
    static should_read_line_on_ending_lf = function() {
        given_content("Lorem Ipsum\n");
        when(reader.read_line(/* with end */ false));
        expect_result_position("Lorem Ipsum", 12);
    }
    
    static should_read_line_with_end_on_ending_lf = function() {
        given_content("Lorem Ipsum\n");
        when(reader.read_line(/* with end */ true));
        expect_result_position("Lorem Ipsum\n", 12);
    }
    
    // Reading from middle
    
    static should_read_line_until_end = function() {
        given_content("Lorem\nIpsum\nDolor");
        when(reader.read_line(/* with end */ false));
        expect_result_position("Lorem", 6);
        when(reader.read_line(/* with end */ false));
        expect_result_position("Ipsum", 12);
        when(reader.read_line(/* with end */ false));
        expect_result_position("Dolor", 17);
        when(reader.read_line(/* with end */ false));
        expect_result_position("", 17);
    }
    
    static should_read_line_with_end_until_end = function() {
        given_content("Lorem\nIpsum\nDolor");
        when(reader.read_line(/* with end */ true));
        expect_result_position("Lorem\n", 6);
        when(reader.read_line(/* with end */ true));
        expect_result_position("Ipsum\n", 12);
        when(reader.read_line(/* with end */ true));
        expect_result_position("Dolor", 17);
        when(reader.read_line(/* with end */ true));
        expect_result_position("", 17);
    }
}
