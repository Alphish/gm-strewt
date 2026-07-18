event_inherited();

create_processor = function(_path) {
    var _visitor = new BbcodeVisitor();
    return new BbcodeParser(_visitor).for_file(_path);
}

on_cancelation = function() {
    status_panel.replace_content($"Processing was cancelled.", c_gray);
    result_panel.replace_split_content(processor.reader.peek_all(), #a0a0a0, processor.reader.position, #404040);
}

on_failure = function(_error) {
    status_panel.replace_content(_error, c_orange);
    result_panel.replace_split_content(processor.reader.peek_all(), #a0a0a0, processor.reader.position, #804040);
}

on_success = function(_result) {
    static tag_colors = [c_red, c_orange, c_yellow, c_lime, c_aqua, #0080FF, c_blue, c_fuchsia];
    
    status_panel.replace_content($"Processing successful!", #40BF55);
    result_panel.clear();
    
    draw_set_font(fnt_Output);
    var _tag_number = 0;
    var _close_colors = [];
    
    for (var i = 0, _count = array_length(_result); i < _count; i++) {
        var _element = _result[i];
        switch (_element.type) {
            case "text":
                result_panel.add_text_block(_element.content, #a0a0a0);
                break;
            
            case "open":
                var _tag_color = tag_colors[_tag_number mod array_length(tag_colors)];
                _tag_number += 5;
                array_push(_close_colors, merge_color(_tag_color, c_black, 0.5));
                
                if (struct_exists(_element, "arg")) {
                    result_panel.add_segment($"[{_element.content}=", _tag_color);
                    result_panel.add_segment(_element.arg, merge_color(_tag_color, c_white, 0.5));
                    result_panel.add_segment($"]", _tag_color);
                } else {
                    result_panel.add_segment($"[{_element.content}]", _tag_color);
                }
                break;
            
            case "close":
                result_panel.add_segment($"[/{_element.content}]", array_pop(_close_colors));
                break;
            
            case "symbol":
                result_panel.add_segment($":{_element.content}:", #FFC000);
                break;
        }
    }
}
