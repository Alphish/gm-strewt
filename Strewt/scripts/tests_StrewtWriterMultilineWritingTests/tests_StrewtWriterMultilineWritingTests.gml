function StrewtWriterMultilineWritingTests(_run, _method) : StrewtWriterBaseTests(_run, _method) constructor {
    static test_subject = "Multiline writing";
    
    // No items
    
    static should_write_empty_string_multiline = function() {
        given_writer();
        writer.write_multiline("");
        when_content_collected();
        expect_result("");
        expect_position(0);
    }
    
    static should_write_empty_array_multiline = function() {
        given_writer();
        writer.write_multiline([]);
        when_content_collected();
        expect_result("");
        expect_position(0);
    }
    
    // Single item
    
    static should_write_single_item_string_multiline = function() {
        given_writer();
        writer.write_multiline("Lorem");
        when_content_collected();
        expect_result("Lorem\n");
        expect_position(6);
    }
    
    static should_write_single_item_array_multiline = function() {
        given_writer();
        writer.write_multiline(["Lorem"]);
        when_content_collected();
        expect_result("Lorem\n");
        expect_position(6);
    }
    
    // Multiple items
    
    static should_write_single_item_string_multiline_without_trailing_line = function() {
        given_writer();
        writer.write_multiline("Lorem", /* last line */ false);
        when_content_collected();
        expect_result("Lorem");
        expect_position(5);
    }
    
    static should_write_single_item_array_multiline_without_trailing_line = function() {
        given_writer();
        writer.write_multiline(["Lorem"], /* last line */ false);
        when_content_collected();
        expect_result("Lorem");
        expect_position(5);
    }
    
    static should_write_multi_item_string_multiline = function() {
        given_writer();
        writer.write_multiline("Lorem\nIpsum\nDolor");
        when_content_collected();
        expect_result("Lorem\nIpsum\nDolor\n");
        expect_position(18);
    }
    
    static should_write_multi_item_array_multiline = function() {
        given_writer();
        writer.write_multiline(["Lorem", "Ipsum", "Dolor"]);
        when_content_collected();
        expect_result("Lorem\nIpsum\nDolor\n");
        expect_position(18);
    }
    
    static should_write_multi_item_string_multiline_without_trailing_line = function() {
        given_writer();
        writer.write_multiline("Lorem\nIpsum\nDolor", /* last line */ false);
        when_content_collected();
        expect_result("Lorem\nIpsum\nDolor");
        expect_position(17);
    }
    
    static should_write_multi_item_array_multiline_without_trailing_line = function() {
        given_writer();
        writer.write_multiline(["Lorem", "Ipsum", "Dolor"], /* last line */ false);
        when_content_collected();
        expect_result("Lorem\nIpsum\nDolor");
        expect_position(17);
    }
    
    static should_write_multi_item_string_multiline_with_different_newlines = function() {
        given_writer();
        writer.write_multiline("Lorem\nIpsum\r\nDolor\rSit");
        when_content_collected();
        expect_result("Lorem\nIpsum\nDolor\nSit\n");
        expect_position(22);
    }
    
    // Items with blank
    
    static should_write_blank_item_string_multiline = function() {
        given_writer();
        writer.write_multiline("Lorem\n\nDolor");
        when_content_collected();
        expect_result("Lorem\n\nDolor\n");
        expect_position(13);
    }
    
    static should_write_blank_item_array_multiline = function() {
        given_writer();
        writer.write_multiline(["Lorem", "", "Dolor"]);
        when_content_collected();
        expect_result("Lorem\n\nDolor\n");
        expect_position(13);
    }
    
    static should_write_blank_item_string_multiline_with_nonblank_indents = function() {
        given_writer();
        writer.push_indent();
        writer.write_multiline("Lorem\n\nDolor");
        when_content_collected();
        expect_result("    Lorem\n\n    Dolor\n");
        expect_position(21);
    }
    
    static should_write_blank_item_array_multiline_with_nonblank_indents = function() {
        given_writer();
        writer.push_indent();
        writer.write_multiline(["Lorem", "", "Dolor"]);
        when_content_collected();
        expect_result("    Lorem\n\n    Dolor\n");
        expect_position(21);
    }
    
    static should_write_blank_item_string_multiline_with_all_indents = function() {
        given_writer().indenting_blank_lines();
        writer.push_indent();
        writer.write_multiline("Lorem\n\nDolor");
        when_content_collected();
        expect_result("    Lorem\n    \n    Dolor\n");
        expect_position(25);
    }
    
    static should_write_blank_item_array_multiline_with_all_indents = function() {
        given_writer().indenting_blank_lines();
        writer.push_indent();
        writer.write_multiline(["Lorem", "", "Dolor"]);
        when_content_collected();
        expect_result("    Lorem\n    \n    Dolor\n");
        expect_position(25);
    }
}
