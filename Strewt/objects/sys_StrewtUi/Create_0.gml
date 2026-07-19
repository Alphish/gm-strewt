// Inherit the parent event
event_inherited();

styles_provider.add_value("button_strewt", new DecolStylesheet(["hover", "active", "disabled"])
    .with_base_overrides({ image_blend: merge_color(c_white, #60F278, 0.5) })
    .with_style("hover", { image_blend: #60F278 })
);

styles_provider.add_value("button_danger", new DecolStylesheet(["hover", "active", "disabled"])
    .with_base_overrides({ image_blend: merge_color(c_white, #C04040, 0.7) })
    .with_style("hover", { image_blend: #C04040 })
    .with_style("disabled", { image_blend: merge_color(#404040, #C04040, 0.5) })
);

styles_provider.add_value("button_example", new DecolStylesheet(["hover", "active", "disabled"])
    .with_base_overrides({ image_blend: merge_color(c_white, #4080E0, 0.7) })
    .with_style("hover", { image_blend: #4080E0 })
);

styles_provider.add_value("button_custom", new DecolStylesheet(["hover", "active", "disabled"])
    .with_base_overrides({ image_blend: merge_color(c_white, #FFD020, 0.7) })
    .with_style("hover", { image_blend: #FFD020 })
    .with_style("disabled", { image_blend: merge_color(#404040, #FFD020, 0.5) })
);
