if (position_meeting(mouse_x, mouse_y, panel)) {
    display_line_offset += mouse_wheel_down() - mouse_wheel_up();
    
    if (mouse_check_button(mb_left)) {
        display_line_offset += (mouse_y >= y + panel.inner_height - 40) - (mouse_y < y + 40);
    }
}

display_line_offset += keyboard_check(vk_down) - keyboard_check(vk_up);
display_line_offset += display_lines_count * (keyboard_check_pressed(vk_pagedown) - keyboard_check_pressed(vk_pageup));
