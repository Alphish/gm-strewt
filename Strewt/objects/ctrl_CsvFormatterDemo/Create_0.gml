event_inherited();

create_processor = function(_path) {
    var _data = load_json_data(_path);
    if (is_undefined(_data)) {
        status_panel.replace_content($"Could not read object from '{_path}'", c_orange);
        result_panel.clear();
        return undefined;
    }
    return new ExampleCsvFormatter(_data);
}

on_cancelation = function() {
    status_panel.replace_content($"Processing was cancelled.", c_gray);
    result_panel.replace_content(processor.writer.get_content(), #a0a0a0);
    result_panel.add_text_line("CANCELLED", #404040);
}

on_failure = function(_error) {
    status_panel.replace_content(_error, c_orange);
    result_panel.replace_content(processor.writer.get_content(), #a0a0a0);
    result_panel.add_text_line("ERROR", #804040);
}

on_success = function(_result) {
    status_panel.replace_content($"Processing successful!", #40BF55);
    result_panel.replace_content(processor.writer.get_content(), merge_color(#a0a0a0, #40BF55, 0.5));
}
