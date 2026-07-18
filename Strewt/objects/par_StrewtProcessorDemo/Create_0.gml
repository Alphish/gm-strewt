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
