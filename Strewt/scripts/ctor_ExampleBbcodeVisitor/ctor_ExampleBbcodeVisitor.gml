function BbcodeVisitor() constructor {
    found_elements = [];
    current_tags = [];
    
    static visit_text = function(_text) {
        var _previous = array_last(found_elements);
        if (is_undefined(_previous) || _previous.type != "text")
            array_push(found_elements, { type: "text", content: _text });
        else
            _previous.content += _text;
    }
    
    static visit_open_tag = function(_tag) {
        array_push(current_tags, _tag);
        array_push(found_elements, { type: "open", content: _tag });
    }
    
    static visit_tag_argument = function(_arg) {
        array_last(found_elements).arg = _arg;
    }
    
    static visit_close_tag = function(_tag, _parser, _position) {
        if (array_length(current_tags) == 0)
            return _parser.fail($"Could not close '{_tag}' tag, because there isn't any matching opening tag.'", _position);
        
        var _counterpart = array_pop(current_tags);
        if (string_lower(_counterpart) != string_lower(_tag))
            return _parser.fail($"Could not close '{_tag}' tag, because the latest opening tag is '{_counterpart}'.", _position);
        
        array_push(found_elements, { type: "close", content: _tag });
    }
    
    static visit_symbol = function(_symbol) {
        array_push(found_elements, { type: "symbol", content: _symbol });
    }
    
    static build_result = function(_parser) {
        if (array_length(current_tags) > 0)
            return _parser.fail($"Cannot complete parsing, because the '{array_pop(current_tags)}' tag hasn't been closed.");
        
        return found_elements;
    }
}
