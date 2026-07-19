processor = undefined;
task = undefined;
worker = undefined;
speed_property = new CimpliProperty(100);

status_panel = noone;
result_panel = noone;

process_example = function(_filename) {
    var _path = string(example_path_template, _filename);
    process_content(_path);
}

process_custom = function() {
    var _path = get_open_filename("All files|*.*", "");
    if (!file_exists(_path))
        return;
    
    process_content(_path);
}

process_content = function(_path) {
    if (!is_undefined(worker) && worker.is_busy())
        worker.try_cancel();
    
    processor = create_processor(_path);
    if (is_undefined(processor)) {
        task = undefined;
        worker = undefined;
        return;
    }
    
    task = new CimpliTask(processor);
    
    task.task_started.add_handler(on_start);
    task.task_progressed.add_handler(on_progress);
    task.task_cancelled.add_handler(on_cancelation);
    task.task_failed.add_handler(on_failure);
    task.task_completed.add_handler(on_success);
    
    worker = new CimpliWorker(task);
}

create_processor = function(_path) {
    throw StrewtException.not_implemented({}, nameof(create_processor));
}

load_json_data = function(_path) {
    var _json_content = load_file_content(_path);
    if (is_undefined(_json_content))
        return undefined;
    
    try {
        return json_parse(_json_content);
    } catch (_) {
        // if the file content isn't a valid JSON, prevent crash and return undefined instead
        return undefined;
    }
}

load_file_content = function(_path) {
    var _buffer = buffer_load(_path);
    if (!buffer_exists(_buffer))
        return undefined;
    
    if (buffer_get_size(_buffer) == 0)
        return "";
    
    var _result = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);
    return _result;
}

on_start = function() {
    status_panel.clear();
    result_panel.clear();
}

on_progress = function(_progress) {
    status_panel.replace_content($"Progress: {_progress}", c_yellow);
}

on_cancelation = function() {
    status_panel.replace_content($"Processing was cancelled.", c_gray);
}

on_failure = function(_error) {
    status_panel.replace_content(_error, c_orange);
}

on_success = function(_result) {
    status_panel.replace_content($"Processing successful!", #40BF55);
}

cancel_process_command = new CimpliCommand(function() {
    if (!is_undefined(worker))
        worker.try_cancel();
}, function() {
    return !is_undefined(worker) && worker.is_busy();
});

process_custom_command = new CimpliCommand(process_custom, function() { return os_type != os_gxgames; });

open_instructions = function() {
    layer_set_visible("Instructions", true);
}
