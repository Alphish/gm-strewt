function StrewtWriterIndentTests(_run, _method) : StrewtWriterBaseTests(_run, _method) constructor {
    static test_subject = "Indent writing";
    
    static should_push_and_pop_indent = function() {
        given_writer();
        writer.write_line("open");
        writer.push_indent();
        writer.write_line("inner");
        writer.pop_indent();
        writer.write_line("close");
        when_content_collected();
        expect_result("open\n    inner\nclose\n");
    }
    
    static should_write_nested_indents = function() {
        given_writer();
        writer.write_line("open");
        writer.push_indent();
        writer.write_line("open");
        writer.push_indent();
        writer.write_line("nested");
        writer.pop_indent();
        writer.write_line("close");
        writer.pop_indent();
        writer.write_line("close");
        when_content_collected();
        expect_result("open\n    open\n        nested\n    close\nclose\n");
    }
    
    static should_write_custom_default_indent = function() {
        given_writer().with_default_indent_unit("\t");
        writer.write_line("open");
        writer.push_indent();
        writer.write_line("inner");
        writer.pop_indent();
        writer.write_line("close");
        when_content_collected();
        expect_result("open\n\tinner\nclose\n");
    }
    
    static should_mix_default_and_custom_indent = function() {
        given_writer();
        writer.write_line("open");
        writer.push_indent();
        writer.write_line("/* ");
        writer.push_indent(" * ");
        writer.write_line("nested");
        writer.pop_indent();
        writer.write_line(" */");
        writer.pop_indent();
        writer.write_line("close");
        when_content_collected();
        expect_result("open\n    /* \n     * nested\n     */\nclose\n");
    }
    
    static should_handle_blank_indent = function() {
        given_writer();
        writer.write_line("open");
        writer.push_indent();
        writer.write_line("open");
        writer.push_indent("");
        writer.write_line("nested");
        writer.pop_indent();
        writer.write_line("close");
        writer.pop_indent();
        writer.write_line("close");
        when_content_collected();
        expect_result("open\n    open\n    nested\n    close\nclose\n");
    }
    
    static should_safely_pop_without_indent = function() {
        given_writer();
        writer.write_line("open");
        writer.push_indent();
        writer.write_line("inner");
        writer.pop_indent();
        writer.write_line("close");
        writer.pop_indent();
        writer.write_line("close again");
        when_content_collected();
        expect_result("open\n    inner\nclose\nclose again\n");
    }
}
