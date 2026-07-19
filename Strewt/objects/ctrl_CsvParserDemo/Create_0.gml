event_inherited();

create_processor = function(_path) {
    return new ExampleCsvParser().for_file(_path);
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
    static key_colors = [ #5098d0, #30e088];
    static value_colors = [ #b0b0b0, #b0b0b0];
    static no_data_colors = [ #404040, #404040 ];
    
    status_panel.replace_content($"Processing successful!", #40BF55);
    result_panel.clear();
    
    var _header = processor.result_header;
    var _header_length = array_length(_header);
    for (var i = 0, _count = array_length(_result); i < _count; i++) {
        var _item = _result[i];
        var _color_idx = i % 2;
        for (var j = 0; j < _header_length; j++) {
            if (j > 0)
                result_panel.add_segment($"; ", no_data_colors[_color_idx]);
            
            var _key = _header[j];
            result_panel.add_segment($"{_key}: ", key_colors[_color_idx]);
            var _value = _item[$ _key];
            if (_value != "")
                result_panel.add_segment($"{_value}", value_colors[_color_idx]);
            else
                result_panel.add_segment($"N/A", no_data_colors[_color_idx]);
        }
        result_panel.add_segment("", c_white, /* newline */ true);
    }
}
