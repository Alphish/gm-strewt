function StrewtChartableBaseTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    static assert_indices_value = function(_charset, _indices, _expected) {
        var _next_index = array_shift(_indices);
        for (var i = 0; i < 255; i++) {
            var _actual = _charset.table[i];
            if (i == _next_index) {
                assert_equal(_expected, _actual, $"Expected value of '{_expected}' at index #{i}, got '{_actual}' instead.");
                _next_index = array_shift(_indices);
            } else {
                assert_is_true(_expected != _actual, $"Expected value other than '{_expected}' at index #{i}, but it was the same.");
            }
        }
    }
}