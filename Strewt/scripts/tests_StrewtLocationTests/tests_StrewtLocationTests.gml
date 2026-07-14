function StrewtLocationTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    static test_subject = "Strewt Location";
    
    static should_have_correct_defaults = function() {
        var _location = new StrewtLocation();
        assert_equal(1, _location.line);
        assert_equal(1, _location.column);
        assert_equal(0, _location.position);
    }
    
    static should_create_location_with_given_values = function() {
        var _location = new StrewtLocation(3, 7, 42);
        assert_equal(3, _location.line);
        assert_equal(7, _location.column);
        assert_equal(42, _location.position);
    }
    
    static should_write_correct_string = function() {
        var _location = new StrewtLocation(3, 7, 42);
        var _str = string(_location);
        assert_equal("Ln: 3 Col: 7 Pos: 42", _str);
    }
    
    static should_write_correct_line_column = function() {
        var _location = new StrewtLocation(3, 7);
        var _str = _location.get_line_column();
        assert_equal("Ln: 3 Col: 7", _str);
    }
    
    static should_create_separate_clone = function() {
        var _location = new StrewtLocation(3, 7, 42);
        var _clone = _location.clone();
        _clone.line += 1;
        _clone.column += 2;
        _clone.position += 34;
        
        assert_equal(3, _location.line);
        assert_equal(7, _location.column);
        assert_equal(42, _location.position);
        
        assert_equal(4, _clone.line);
        assert_equal(9, _clone.column);
        assert_equal(76, _clone.position);
    }
}
