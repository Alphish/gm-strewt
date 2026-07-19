var _enabled = true;
var _hovered = _enabled && position_meeting(mouse_x, mouse_y, id);

if (_hovered && mouse_check_button_pressed(mb_left))
    property.set_value(value);

style_manager.set_modifier("disabled", !_enabled);
style_manager.set_modifier("hover", _hovered);
style_manager.set_modifier("active", property.get_value() == value);
