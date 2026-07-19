if (layer_exists("Instructions") && layer_get_visible("Instructions")) {
    if (mouse_check_button_pressed(mb_left))
        layer_set_visible("Instructions", false);
    
    return;
}

with (par_DecolComponent) event_user(0);
with (ui_LineViewer) event_user(0);
with (par_StrewtProcessorDemo) event_user(0);
