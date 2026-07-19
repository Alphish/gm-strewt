draw_self();

draw_set_color(text_color);
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(text_font);
draw_text(x + sprite_width div 2, y + sprite_height div 2, text);

draw_set_color(c_white);
