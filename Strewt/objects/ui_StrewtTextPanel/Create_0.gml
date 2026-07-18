segments = [[]];
horizontal_margin = 16;
vertical_margin = show_arrows ? 20 : 4;
separation = 24;
inner_width = sprite_width - 2 * horizontal_margin;
inner_height = sprite_height - 2 * vertical_margin;

if (role != "")
    par_StrewtProcessorDemo.id[$ role] = id;

clear = function() {
    array_resize(segments, 0);
    array_push(segments, []);
}

replace_content = function(_content, _color) {
    clear();
    add_text_block(_content, _color);
}

replace_split_content = function(_content, _color, _splitidx, _color2) {
    clear();
    draw_set_font(fnt_Output);
    
    var _left = string_copy(_content, 1, _splitidx);
    add_text_block(_left, _color);
    
    var _right = string_delete(_content, 1, _splitidx);
    if (_right != "")
        add_text_block(_right, _color2);
    else
        add_text_line("--- end of content ---", _color2, /* newline */ true);
}

add_text_block = function(_text, _color) {
    static newline_sequences = ["\r\n", "\r", "\n"];
    
    var _lines = string_split_ext(_text, newline_sequences);
    add_text_line(_lines[0], _color, /* newline */ false);
    for (var i = 1, _count = array_length(_lines); i < _count; i++) {
        add_text_line(_lines[i], _color, /* newline */ true);
    }
}

add_text_line = function(_text, _color, _newline = false) {
    var _words = string_split(_text, " ", false);
    for (var i = 0, _count = array_length(_words); i < _count; i++) {
        var _word = i + 1 < _count ? _words[i] + " " : _words[i];
        add_segment(_word, _color, _newline);
        _newline = false;
    }
}

add_segment = function(_text, _color, _newline = false) {
    var _previous_segment = array_last(array_last(segments)) ?? { x: 0, width: 0 };
    var _segment = { x: _previous_segment.x + _previous_segment.width, width: string_width(_text), text: _text, color: _color };
    var _trim_width = string_width(string_trim_end(_text));
    if (_newline || _segment.x + _trim_width > inner_width) {
        array_push(segments, []);
        _segment.x = 0;
    }
    array_push(array_last(segments), _segment);
}

instance_create_depth(x + horizontal_margin, y + vertical_margin, depth - 1, ui_LineViewer, { panel: id, show_arrows });
