function StrewtFormatterTaskTests(_run, _method) : StrewtFormatterBaseTests(_run, _method) constructor {
    static test_subject = "Formatting task";
    
    format_task = undefined;
    format_worker = undefined;
    
    format_progress = undefined;
    format_status = undefined;
    format_finished = false;
    format_result = undefined;
    format_failure = undefined;
    format_canceled = false;
    
    static should_foramt_valid_input = function() {
        given_formatter_of(["Lorem", "Ipsum", "Dolor"]);
        given_task();
        given_worker();
        when_task_ran_to_completion();
        expect_task_state("3/3", 1, true, "Lorem\nIpsum\nDolor\n", undefined, false);
        expect_result("Lorem\nIpsum\nDolor\n");
        expect_cleanup();
    }
    
    static should_process_valid_content_step_by_step = function() {
        given_formatter_of(["Lorem", "Ipsum", "Dolor"]);
        given_task();
        given_worker();
        
        when_task_step_ran();
        expect_task_state("1/3", 0, false, undefined, undefined, false);
        
        when_task_step_ran();
        expect_task_state("2/3", 0, false, undefined, undefined, false);
        
        when_task_step_ran();
        expect_task_state("3/3", 1, true, "Lorem\nIpsum\nDolor", undefined, false);
        
        expect_result("Lorem\nIpsum\nDolor\n");
        expect_cleanup();
    }
    
    static should_cancel_processing_content = function() {
        given_formatter_of(["Lorem", "Ipsum", "Dolor"]);
        given_task();
        given_worker();
        
        when_task_step_ran();
        expect_task_state("1/3", 0, false, undefined, undefined, false);
        
        var _canceled = format_worker.try_cancel();
        assert_is_true(_canceled);
        expect_task_state("1/3", 0, false, undefined, undefined, true);
        expect_cleanup(); // cleanup should run after cancellation
    }
    
    // -------
    // Helpers
    // -------
    
    static given_task = function() {
        format_task = new CimpliTask(formatter);
        format_task.task_progressed.add_handler(function(_progress) { format_progress = _progress; });
        format_task.status_changed.add_handler(function(_status) { format_status = _status; });
        format_task.task_finished.add_handler(function() { format_finished = true; });
        format_task.task_completed.add_handler(function(_result) { format_result = _result; });
        format_task.task_failed.add_handler(function(_failure) { format_failure = _failure; });
        format_task.task_cancelled.add_handler(function() { format_canceled = true; });
        
        format_status = format_task.previous_status;
    }
    
    static given_worker = function() {
        format_worker = new CimpliWorker(format_task);
    }
    
    static when_task_step_ran = function() {
        format_worker.run_step();
    }
    
    static when_task_ran_to_completion = function() {
        format_worker.run_to_end();
    }
    
    static expect_task_state = function(_progress, _status, _finished, _result, _failure, _canceled) {
        assert_equal(_progress, format_progress);
        assert_equal(_status, format_status);
        assert_equal(_finished, format_finished);
        
        if (is_undefined(_result))
            assert_is_undefined(format_result);
        else
            assert_array_equal(_result, format_result);
        
        assert_equal(_failure, format_failure);
        assert_equal(_canceled, format_canceled);
    }
}
