display_line_offset = 0;
max_display_line_offset = 0;

lines = panel.segments;
line_separation = panel.separation;
display_lines_count = round(panel.inner_height / line_separation);

draw_line_segments = function(_x, _y, _line) {
    draw_set_font(fnt_Output);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    for (var i = 0, _count = array_length(_line); i < _count; i++) {
        var _segment = _line[i];
        draw_set_color(_segment.color);
        draw_set_alpha(1);
        draw_text(_x + _segment.x, _y, _segment.text);
    }
}
