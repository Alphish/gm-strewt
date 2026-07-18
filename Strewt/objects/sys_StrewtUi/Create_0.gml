// Inherit the parent event
event_inherited();

styles_provider.add_value("button_strewt", new DecolStylesheet(["hover", "active", "disabled"])
    .with_base_overrides({ image_blend: merge_color(c_white, #60F278, 0.5) })
    .with_style("hover", { image_blend: #60F278 })
);
