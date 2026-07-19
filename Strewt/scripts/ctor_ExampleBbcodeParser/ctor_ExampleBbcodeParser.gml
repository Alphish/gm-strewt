function ExampleBbcodeParser(_visitor) : StrewtParser() constructor { 
    static space_charset = new StrewtCharset(false).including(" \t\r\n");
    static plaintext_charset = new StrewtCharset(true).excluding("[:");
    static word_charset = new StrewtCharset(false).including_range("0", "9").including_range("A", "Z").including_range("a", "z").including("_");
    
    visitor = _visitor;
    
    function_table = new StrewtChartable(read_plaintext, try_complete)
        .with_value("[", read_tag)
        .with_value(":", read_symbol);
    
    static process_step = function() {
        var _function = reader.peek_chartable(function_table);
        method(self, _function)();
        return status != 0;
    }
    
    static resolve_result = function() {
        return visitor.build_result(self);
    }
    
    static read_plaintext = function() {
        var _text = reader.read_charset(plaintext_charset);
        visitor.visit_text(_text);
    }
    
    static read_tag = function() {
        static tag_close_byte = ord("/");
        static tag_terminate_byte = ord("]");
        static tag_arg_assign_byte = ord("=");
        static tag_arg_content_charset = new StrewtCharset(true).excluding("[]");
        
        var _start_position = reader.position;
        reader.skip_next(); // skip the opening bracket
        if (reader.skip_byte(tag_close_byte)) {
            reader.skip_charset(space_charset);
            var _tag = reader.read_charset(word_charset);
            if (_tag == "")
                return fail("Expected the tag name following the closing tag symbol, but none was found.", _start_position);
            
            reader.skip_charset(space_charset);
            if (!reader.skip_byte(tag_terminate_byte))
                return fail("Expected the tag terminator, but no applicable terminator was found.", _start_position);
            
            visitor.visit_close_tag(_tag, self, _start_position);
       } else {
            reader.skip_charset(space_charset);
            var _tag = reader.read_charset(word_charset);
            if (_tag == "")
                return fail("Expected the tag name following the open bracket, but none was found.", _start_position);
            
            reader.skip_charset(space_charset);
            
            var _arg_content = undefined;
            if (reader.skip_byte(tag_arg_assign_byte)) {
                var _arg_content = reader.read_charset(tag_arg_content_charset);
                reader.skip_charset(space_charset);
            }
            
            if (!reader.skip_byte(tag_terminate_byte))
                return fail("Expected the tag terminator, but no applicable terminator was found.", _start_position);
            
            visitor.visit_open_tag(_tag);
            if (is_string(_arg_content))
                visitor.visit_tag_argument(string_trim(_arg_content));
        }
    }
    
    static read_symbol = function() {
        static symbol_terminator = ord(":");
        
        var _start_position = reader.position;
        reader.skip_next();
        if (reader.skip_byte(symbol_terminator)) {
            visitor.visit_symbol("");
            return;
        }
        
        var _symbol = reader.read_charset(word_charset);
        if (_symbol == "") {
            visitor.visit_text(":");
            return;
        }
        
        visitor.visit_symbol(_symbol);
        if (!reader.skip_byte(symbol_terminator))
            return fail("Expected the symbol terminator, but none was found.", _start_position);
    }
}
