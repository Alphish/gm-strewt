var _from = display_line_offset;
var _to = min(display_line_offset + display_lines_count, array_length(lines));

var _xx = x;
var _yy = y;
for (var i = _from; i < _to; i++) {
    draw_line_segments(_xx, _yy, lines[i]);
    _yy += line_separation;
}

if (show_arrows) {
    var _arrow_x = panel.x + panel.sprite_width div 2;
    var _arrow_y_margin = 2 * panel.vertical_margin div 3;
    draw_sprite_ext(spr_LineViewer, 0, _arrow_x, panel.y + _arrow_y_margin, 1, 1, 0, #40BF55, display_line_offset > 0 ? 0.75 : 0.3);
    draw_sprite_ext(spr_LineViewer, 1, _arrow_x, panel.y + panel.sprite_height - _arrow_y_margin, 1, 1, 0, #40BF55, display_line_offset < max_display_line_offset ? 0.75 : 0.3);
}

draw_set_color(c_white);
draw_set_alpha(1);
