function StrewtCharsetBaseTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    static assert_true_indices = function(_charset, _indices) {
        var _next_index = array_shift(_indices);
        for (var i = 0; i < 255; i++) {
            var _included = _charset.table[i];
            if (i == _next_index) {
                assert_is_true(_included, $"Expected true value at index #{i}, got false instead.");
                _next_index = array_shift(_indices);
            } else {
                assert_is_false(_included, $"Expected false value at index #{i}, got true instead.");
            }
        }
    }
    
    static assert_false_indices = function(_charset, _indices) {
        var _next_index = array_shift(_indices);
        for (var i = 0; i < 255; i++) {
            var _included = _charset.table[i];
            if (i == _next_index) {
                assert_is_false(_included, $"Expected false value at index #{i}, got true instead.");
                _next_index = array_shift(_indices);
            } else {
                assert_is_true(_included, $"Expected true value at index #{i}, got false instead.");
            }
        }
    }
}