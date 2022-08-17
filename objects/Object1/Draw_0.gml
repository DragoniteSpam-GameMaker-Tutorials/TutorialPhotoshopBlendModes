if (keyboard_check_pressed(vk_left)) {
    self.mode = (self.mode + array_length(self.mode_names) - 1) % array_length(self.mode_names);
}
if (keyboard_check_pressed(vk_right)) {
    self.mode = (self.mode + 1) % array_length(self.mode_names);
}

draw_clear(c_black);

var surface_src = surface_create(160, 90);
surface_set_target(surface_src);
draw_clear_alpha(c_black, 0);
draw_sprite(spr_duck, 0, mouse_x, mouse_y);
surface_reset_target();

draw_surface(surface_src, 0, 0);

var surface_dest = surface_create(160, 90);
surface_set_target(surface_dest);
draw_sprite_tiled(spr_checkerboard, 0, 0, 0);
draw_sprite(spr_tree, 0, 32, 32);
surface_reset_target();

shader_set(shd_fancy_blending);
shader_set_uniform_i(shader_get_uniform(shd_fancy_blending, "u_BlendMode"), self.mode);
texture_set_stage(shader_get_sampler_index(shd_fancy_blending, "samp_dst"), surface_get_texture(surface_dest));
draw_surface(surface_src, 0, 0);
shader_reset();

surface_free(surface_src);
surface_free(surface_dest);