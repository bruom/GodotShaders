shader_type canvas_item;

render_mode unshaded;

uniform vec2 size = vec2(32.0, 28.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 c = texture(screen_texture, UV);
	
	if (c != vec4(0.0, 0.0, 0.0, 1.0)) {
		COLOR.rgb = vec3(1.0, 1.0, 1.0);
	}
	else {
		COLOR.a = 0.0;
	}
}
