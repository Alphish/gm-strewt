function StrewtReaderLineTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Line checking";
    
    // -----
    // Setup
    // -----
    
    include_eol = undefined;
    static excluding_end_of_line = function() {
        include_eol = false;
    }
    
    static including_end_of_line = function() {
        include_eol = true;
    }
    
    static when_spanned = function() {
        return is_undefined(include_eol) ? reader.span_line() : reader.span_line(include_eol);
    }
    
    static when_skipped = function() {
        return is_undefined(include_eol) ? reader.skip_line() : reader.skip_line(include_eol);
    }
    
    static when_peeked = function() {
        return is_undefined(include_eol) ? reader.peek_line() : reader.peek_line(include_eol);
    }
    
    static when_read = function() {
        return is_undefined(include_eol) ? reader.read_line() : reader.read_line(include_eol);
    }
    
    static when_read_into_target = function(_target, _offset = undefined) {
        return is_undefined(_offset)
            ? reader.read_line_into(include_eol, _target)
            : reader.read_line_into(include_eol, _target, _offset);
    }
    
    // --------
    // Spanning
    // --------
    
    static should_receive_empty_line_on_empty_string = function() {
        given_content("");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_receive_empty_line_on_empty_string_with_end = function() {
        given_content("");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_receive_entire_string_without_linebreak = function() {
        given_content("Lorem ipsum");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(11);
        then_expect_string("Lorem ipsum");
        then_expect_positions(0, 11);
    }
    
    static should_receive_entire_string_without_linebreak_with_end = function() {
        given_content("Lorem ipsum");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(11);
        then_expect_string("Lorem ipsum");
        then_expect_positions(0, 11);
    }
    
    static should_receive_line_without_end_by_default = function() {
        given_content("Lorem\nIpsum");
        when_method_family_tested();
        
        then_expect_span(5);
        then_expect_string("Lorem");
        then_expect_positions(0, 6);
    }
    
    // Starting line break
    
    static should_receive_empty_line_on_starting_lf = function() {
        given_content("\nTest");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 1);
    }
    
    static should_receive_lf_on_starting_lf_with_end = function() {
        given_content("\nTest");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_string("\n");
        then_expect_positions(0, 1);
    }
    
    static should_receive_empty_line_on_starting_cr = function() {
        given_content("\rTest");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 1);
    }
    
    static should_receive_cr_on_starting_cr_with_end = function() {
        given_content("\rTest");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(1);
        then_expect_string("\r");
        then_expect_positions(0, 1);
    }
    
    static should_receive_empty_line_on_starting_crlf = function() {
        given_content("\r\nTest");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 2);
    }
    
    static should_receive_crlf_on_starting_crlf_with_end = function() {
        given_content("\r\nTest");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(2);
        then_expect_string("\r\n");
        then_expect_positions(0, 2);
    }
    
    // Middle line break
    
    static should_span_line_on_middle_lf = function() {
        given_content("Lorem\nIpsum");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(5);
        then_expect_string("Lorem");
        then_expect_positions(0, 6);
    }
    
    static should_handle_line_on_middle_lf_with_end = function() {
        given_content("Lorem\nIpsum");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(6);
        then_expect_string("Lorem\n");
        then_expect_positions(0, 6);
    }
    
    static should_handle_line_on_middle_cr = function() {
        given_content("Lorem\rIpsum");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(5);
        then_expect_string("Lorem");
        then_expect_positions(0, 6);
    }
    
    static should_handle_line_on_middle_cr_with_end = function() {
        given_content("Lorem\rIpsum");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(6);
        then_expect_string("Lorem\r");
        then_expect_positions(0, 6);
    }
    
    static should_handle_line_on_middle_crlf = function() {
        given_content("Lorem\r\nIpsum");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(5);
        then_expect_string("Lorem");
        then_expect_positions(0, 7);
    }
    
    static should_handle_line_on_middle_crlf_with_end = function() {
        given_content("Lorem\r\nIpsum");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(7);
        then_expect_string("Lorem\r\n");
        then_expect_positions(0, 7);
    }
    
    static should_handle_line_on_middle_lfcr = function() {
        given_content("Lorem\n\rIpsum");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(5);
        then_expect_string("Lorem");
        then_expect_positions(0, 6);
    }
    
    static should_handle_line_on_middle_lfcr_with_end = function() {
        given_content("Lorem\n\rIpsum");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(6);
        then_expect_string("Lorem\n");
        then_expect_positions(0, 6);
    }
    
    static should_handle_line_on_middle_lflf = function() {
        given_content("Lorem\n\nIpsum");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(5);
        then_expect_string("Lorem");
        then_expect_positions(0, 6);
    }
    
    static should_handle_line_on_middle_lflf_with_end = function() {
        given_content("Lorem\n\nIpsum");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(6);
        then_expect_string("Lorem\n");
        then_expect_positions(0, 6);
    }
    
    // Ending line break
    
    static should_handle_line_on_ending_lf = function() {
        given_content("Lorem Ipsum\n");
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(11);
        then_expect_string("Lorem Ipsum");
        then_expect_positions(0, 12);
    }
    
    static should_handle_line_on_ending_lf_with_end = function() {
        given_content("Lorem Ipsum\n");
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(12);
        then_expect_string("Lorem Ipsum\n");
        then_expect_positions(0, 12);
    }
    
    // Reading from middle
    
    static should_handle_line_from_middle = function() {
        given_content("Lorem\nIpsum\nDolor");
        given_position(8);
        excluding_end_of_line();
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("sum");
        then_expect_positions(8, 12);
    }
    
    static should_handle_line_from_middle_with_end = function() {
        given_content("Lorem\nIpsum\nDolor");
        given_position(8);
        including_end_of_line();
        when_method_family_tested();
        
        then_expect_span(4);
        then_expect_string("sum\n");
        then_expect_positions(8, 12);
    }
}
