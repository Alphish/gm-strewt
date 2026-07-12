function StrewtReaderTrigraphTests(_run, _method) : StrewtReaderMethodFamilyBaseTests(_run, _method) constructor {
    static test_subject = "Trigraph checking";
    
    // -----
    // Setup
    // -----
    
    trigraph = undefined;
    static given_trigraph = function(_str) {
        trigraph = strewt_trigraph(_str);
    }
    
    static when_spanned = function() {
        return reader.span_trigraph(trigraph);
    }
    
    static when_skipped = function() {
        return reader.skip_trigraph(trigraph);
    }
    
    static when_peeked = function() {
        return undefined;
    }
    
    static when_read = function() {
        return undefined;
    }
    
    static when_read_into_target = function(_target) {
        return reader.read_trigraph_into(trigraph, _target);
    }
    
    // -----
    // Tests
    // -----
    
    static should_ignore_trigraph_on_empty_string = function() {
        given_content("");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_ignore_trigraph_on_short_string = function() {
        given_content("??");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_trigraph_on_trigraph_string = function() {
        given_content("??=");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("??=");
        then_expect_positions(0, 3);
    }
    
    static should_handle_trigraph_when_matched = function() {
        given_content("??=123");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("??=");
        then_expect_positions(0, 3);
    }
    
    static should_ignore_trigraph_when_not_matched = function() {
        given_content("?? 123");
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_nonascii_trigraph_when_matched = function() {
        given_content("日本");
        given_trigraph("日");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("日");
        then_expect_positions(0, 3);
    }
    
    static should_ignore_nonascii_trigraph_when_not_matched = function() {
        given_content("中国");
        given_trigraph("日");
        when_method_family_tested();
        
        then_expect_span(0);
        then_expect_string("");
        then_expect_positions(0, 0);
    }
    
    static should_handle_trigraph_in_the_middle = function() {
        given_content("test ??= 123;");
        given_position(5);
        given_trigraph("??=");
        when_method_family_tested();
        
        then_expect_span(3);
        then_expect_string("??=");
        then_expect_positions(5, 8);
    }
}
