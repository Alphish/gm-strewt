function StrewtParserTaskTests(_run, _method) : StrewtParserBaseTests(_run, _method) constructor {
    static test_subject = "Parsing task";
    
    parse_task = undefined;
    parse_worker = undefined;
    
    parse_progress = undefined;
    parse_status = undefined;
    parse_finished = false;
    parse_result = undefined;
    parse_failure = undefined;
    parse_canceled = false;
    
    static should_process_valid_content = function() {
        given_parser().for_content(">Lorem\n>Ipsum\n>Dolor");
        given_task();
        given_worker();
        when_task_ran_to_completion();
        expect_task_state("20/20", 1, true, ["Lorem", "Ipsum", "Dolor"], undefined, false);
        expect_parse_result(["Lorem", "Ipsum", "Dolor"]);
        expect_cleanup();
    }
    
    static should_process_valid_content_step_by_step = function() {
        given_parser().for_content(">Lorem\n>Ipsum\n>Dolor");
        given_task();
        given_worker();
        
        when_task_step_ran();
        expect_task_state("7/20", 0, false, undefined, undefined, false);
        
        when_task_step_ran();
        expect_task_state("14/20", 0, false, undefined, undefined, false);
        
        when_task_step_ran();
        expect_task_state("20/20", 0, false, undefined, undefined, false);
        
        when_task_step_ran();
        expect_task_state("20/20", 1, true, ["Lorem", "Ipsum", "Dolor"], undefined, false);
        
        expect_parse_result(["Lorem", "Ipsum", "Dolor"]);
        expect_cleanup();
    }
    
    static should_cancel_processing_content = function() {
        given_parser().for_content(">Lorem\n>Ipsum\n>Dolor");
        given_task();
        given_worker();
        
        when_task_step_ran();
        expect_task_state("7/20", 0, false, undefined, undefined, false);
        
        var _canceled = parse_worker.try_cancel();
        assert_is_true(_canceled);
        expect_task_state("7/20", 0, false, undefined, undefined, true);
        expect_cleanup(); // cleanup should run after cancellation
    }
    
    static should_fail_processing_invalid_content = function() {
        given_parser().for_content(">This is\n>bad! Really bad\n>Oh no...");
        given_task();
        given_worker();
        when_task_ran_to_completion();
        expect_task_state("13/35", -1, true, undefined, "Error at Ln: 2 Col: 5: DON'T SHOUT!!!", false);
        expect_parse_error(2, 5, 13, "Error at Ln: 2 Col: 5: DON'T SHOUT!!!");
        expect_cleanup();
    }
    
    // -------
    // Helpers
    // -------
    
    static given_task = function() {
        parse_task = new CimpliTask(parser);
        parse_task.task_progressed.add_handler(function(_progress) { parse_progress = _progress; });
        parse_task.status_changed.add_handler(function(_status) { parse_status = _status; });
        parse_task.task_finished.add_handler(function() { parse_finished = true; });
        parse_task.task_completed.add_handler(function(_result) { parse_result = _result; });
        parse_task.task_failed.add_handler(function(_failure) { parse_failure = _failure; });
        parse_task.task_cancelled.add_handler(function() { parse_canceled = true; });
        
        parse_status = parse_task.previous_status;
    }
    
    static given_worker = function() {
        parse_worker = new CimpliWorker(parse_task);
    }
    
    static when_task_step_ran = function() {
        parse_worker.run_step();
    }
    
    static when_task_ran_to_completion = function() {
        parse_worker.run_to_end();
    }
    
    static expect_task_state = function(_progress, _status, _finished, _result, _failure, _canceled) {
        assert_equal(_progress, parse_progress);
        assert_equal(_status, parse_status);
        assert_equal(_finished, parse_finished);
        
        if (is_undefined(_result))
            assert_is_undefined(parse_result);
        else
            assert_array_equal(_result, parse_result);
        
        assert_equal(_failure, parse_failure);
        assert_equal(_canceled, parse_canceled);
    }
}
