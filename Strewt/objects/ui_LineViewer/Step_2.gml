max_display_line_offset = max(0, array_length(lines) - display_lines_count);
display_line_offset = clamp(display_line_offset, 0, max_display_line_offset);
