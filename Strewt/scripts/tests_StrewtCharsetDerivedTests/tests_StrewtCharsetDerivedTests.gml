function StrewtCharsetDerivedTests(_run, _method) : StrewtCharsetBaseTests(_run, _method) constructor {
    static test_subject = "Derived charset";
    
    static should_be_clone_with_original_values = function() {
        var _original = new StrewtCharset().including("123");
        assert_true_indices(_original, [49, 50, 51]);
        var _clone = _original.clone();
        assert_true_indices(_clone, [49, 50, 51]);
    }
    
    static should_be_inverse_with_opposite_values_except_always_false_terminating_character = function() {
        var _original = new StrewtCharset().including("123");
        assert_true_indices(_original, [49, 50, 51]);
        var _inverse = _original.inverse();
        assert_false_indices(_inverse, [0, 49, 50, 51]);
    }
}
