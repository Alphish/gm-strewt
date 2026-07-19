function ExampleIndentObjectFormatter(_input) : StrewtFormatter(_input) constructor {
    current_context = input;
    current_keys = [undefined];
    current_index = 0;
    
    pending_contexts = [];
    pending_keys = [];
    pending_indices = [];
    
    static process_step = function() {
        if (status != 0)
            return;
        
        if (keyboard_check_pressed(ord("E")))
            return fail("e");
        
        if (current_index >= array_length(current_keys)) {
            current_context = array_pop(pending_contexts);
            current_keys = array_pop(pending_keys);
            current_index = array_pop(pending_indices);
            writer.pop_indent();
        } else {
            var _key = current_keys[current_index++];
            write_key(_key);
            var _value = get_current_value(_key);
            if (is_array(_value))
                begin_array(_value);
            else if (is_struct(_value))
                begin_struct(_value);
            else
                write_primitive(_value);
        }
        
        return complete_when(is_undefined(current_context));
    }
    
    static get_current_value = function(_key) {
        if (is_string(_key))
            return current_context[$ _key];
        else if (is_real(_key))
            return current_context[_key];
        else
            return current_context;
    }
    
    static write_key = function(_key) {
        if (is_string(_key))
            writer.write($"\"{_key}\":");
        else if (is_real(_key))
            writer.write($"[{_key}]:");
    }
    
    static write_primitive = function(_value) {
        writer.write_line($" {_value ?? "N/A"}");
    }
    
    static begin_array = function(_value) {
        var _keys = array_create_ext(array_length(_value), function(i) { return i; });
        push_context(_value, _keys);
    }
    
    static begin_struct = function(_value) {
        var _keys = struct_get_names(_value);
        push_context(_value, _keys);
    }
    
    static push_context = function(_context, _keys) {
        array_push(pending_contexts, current_context);
        array_push(pending_keys, current_keys);
        array_push(pending_indices, current_index);
        
        if (!is_undefined(current_keys[0])) {
            writer.write_line();
            writer.push_indent();
        }
        
        current_context = _context;
        current_keys = _keys;
        current_index = 0;
    }
    
    get_progress = function() {
        if (status != 0)
            return "100%";
        
        var _from = 0;
        var _to = 1;
        for (var i = 0; i < array_length(pending_keys); i++) {
            var _keys_length = array_length(pending_keys[i]);
            var _key_index = pending_indices[i];
            var _newfrom = lerp(_from, _to, (_key_index - 1) / _keys_length);
            var _newto = lerp(_from, _to, _key_index / _keys_length);
            _from = _newfrom;
            _to = _newto;
        }
        
        {
            var _keys_length = array_length(current_keys);
            var _key_index = current_index;
            var _newfrom = lerp(_from, _to, (_key_index - 1) / _keys_length);
            var _newto = lerp(_from, _to, _key_index / _keys_length);
            _from = _newfrom;
            _to = _newto;
        }
        
        return $"{floor(_from * 100)}% (estimated)";
    }
}

