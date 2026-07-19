/// @arg {Real} index
/// @arg {Array<String>,String} modifiers
/// @arg {Struct} values
function DecolStyle(_index, _modifiers, _values) constructor {
    if (is_string(_modifiers))
        _modifiers = array_map(string_split(_modifiers, ",", true), function(_modifier) { return string_trim(_modifier); });
    
    index = _index;
    required_modifiers = array_filter(_modifiers, function(_modifier) { return !string_starts_with(_modifier, "!"); });
    forbidden_modifiers = array_map(
        array_filter(_modifiers, function(_modifier) { return string_starts_with(_modifier, "!"); }),
        function(_modifier) { static substrs = ["!"]; return string_trim_start(_modifier, substrs); }
        );
    
    values = _values;
    variables = struct_get_names(values);
    
    static should_apply = function(_modifiers) {
        for (var i = 0, _count = array_length(required_modifiers); i < _count; i++) {
            if (!_modifiers[$ required_modifiers[i]])
                return false;
        }
        for (var i = 0, _count = array_length(forbidden_modifiers); i < _count; i++) {
            if (_modifiers[$ forbidden_modifiers[i]])
                return false;
        }
        return true;
    }
}
