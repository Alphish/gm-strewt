function TestDummyParser() : StrewtParser() constructor {
    collected_lines = [];
    
    static process_step = function() {
        static line_prefix_character = ord(">");
        
        if (status != 0)
            return true;
        
        if (!reader.skip_byte(line_prefix_character)) {
            try_complete();
        } else {
            var _line = reader.read_line(/* withend */ true);
            var _trimline = string_trim_end(_line);
            var _exclamation_idx = string_pos("!", _line) - 1;
            if (_exclamation_idx >= 0) {
                var _position = reader.position - string_length(_line) + _exclamation_idx;
                fail("DON'T SHOUT!!!", _position);
            } else {
                array_push(collected_lines, _trimline);
            }
        }
        return status != 0;
    }
    
    static resolve_result = function() {
        if (array_length(collected_lines) == 0)
            return fail("At least one content line was expected.");
        
        return collected_lines;
    }
}
