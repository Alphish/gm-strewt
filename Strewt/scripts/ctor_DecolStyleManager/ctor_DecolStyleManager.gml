/// @arg {Id.Instance} instance
/// @arg {Struct.DecolStylesheet} stylesheet
function DecolStyleManager(_instance, _stylesheet) constructor {
    instance = _instance;
    stylesheet = _stylesheet;
    
    struct_foreach(stylesheet.base_overrides, function(_key, _value) {
        instance[$ _key] = _value;
    });
    
    base_values = {};
    array_foreach(stylesheet.variables, function(_variable) {
        base_values[$ _variable] = instance[$ _variable];
    });
    
    modifiers = {};
    array_foreach(_stylesheet.modifiers, function(_modifier) { modifiers[$ _modifier] = false; });
    
    styles_applied = array_create(array_length(stylesheet.styles), false);
    source_indices_by_variable = {};
    
    static add_modifier = function(_modifier) {
        set_modifier(_modifier, true);
    }
    
    static remove_modifier = function(_modifier) {
        set_modifier(_modifier, false);
    }
    
    static set_modifier = function(_modifier, _value) {
        if ((modifiers[$ _modifier] ?? _value) == _value)
            return;
        
        modifiers[$ _modifier] = _value;
        var _affected_styles = stylesheet.styles_by_modifier[$ _modifier];
        for (var i = 0, _count = array_length(_affected_styles); i < _count; i++) {
            var _style = _affected_styles[i];
            if (_style.should_apply(modifiers))
                apply_style(_style);
            else
                unapply_style(_style);
        }
    }
    
    static apply_style = function(_style) {
        if (styles_applied[_style.index])
            return;
        
        styles_applied[_style.index] = true;
        for (var i = 0, _count = array_length(_style.variables); i < _count; i++) {
            apply_variable(_style.variables[i], _style);
        }
    }
    
    static apply_variable = function(_variable, _style) {
        var _current_index = source_indices_by_variable[$ _variable] ?? -1;
        if (_current_index > _style.index)
            return;
        
        instance[$ _variable] = _style.values[$ _variable];
        source_indices_by_variable[$ _variable] = _style.index;
    }
    
    static unapply_style = function(_style) {
        if (!styles_applied[_style.index])
            return;
        
        styles_applied[_style.index] = false;
        for (var i = 0, _count = array_length(_style.variables); i < _count; i++) {
            unapply_variable(_style.variables[i], _style);
        }
    }
    
    static unapply_variable = function(_variable, _style) {
        var _current_index = source_indices_by_variable[$ _variable] ?? -1;
        if (_current_index != _style.index)
            return;
        
        var _fallback_style = stylesheet.get_fallback_style(_variable, _style.index, styles_applied);
        if (is_undefined(_fallback_style)) {
            instance[$ _variable] = base_values[$ _variable];
            struct_remove(source_indices_by_variable, _variable);
        } else {
            instance[$ _variable] = _fallback_style.values[$ _variable];
            source_indices_by_variable[$ _variable] = _fallback_style.index;
        }
    }
}
