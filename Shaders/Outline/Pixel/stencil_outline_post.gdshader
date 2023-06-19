shader_type spatial;
render_mode depth_prepass_alpha, depth_draw_opaque, unshaded;

uniform float test = 1.0;
uniform sampler2D stencil_tex;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	POSITION = vec4(VERTEX, 1.0) * vec4(-1.0, -1.0, 1.0, 1.0);
}

void fragment() {
	ALBEDO = texture(stencil_tex, SCREEN_UV).rgb;
	ALPHA = texture(stencil_tex, SCREEN_UV).a;
}
