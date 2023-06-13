shader_type canvas_item;

render_mode unshaded, blend_mul;

uniform float depth_threshold;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 c = texture(screen_texture, UV);
	
	vec4 l = texture(screen_texture, UV - vec2(SCREEN_PIXEL_SIZE.x, 0.0));
	vec4 r = texture(screen_texture, UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0));
	vec4 u = texture(screen_texture, UV - vec2(0.0, SCREEN_PIXEL_SIZE.y));
	vec4 d = texture(screen_texture, UV + vec2(0.0, SCREEN_PIXEL_SIZE.y));
	
	if (c.r > 0.0) {
		float max_diff = max(max(abs(l.r - c.r), abs(r.r - c.r)), max(abs(u.r - c.r), abs(d.r - c.r)));
		if (max_diff > depth_threshold) {
			COLOR.rgb = vec3(1.0, 1.0, 0.0);
		} else {
			COLOR.a = 0.0;
		}
	} else {
		COLOR.a = 0.0;
	}
	
//	vec4 background_color = vec4(0.0, 0.0, 0.0, 1.0);
//	if (c != background_color) {
//		if (l == background_color || r == background_color || u == background_color || d == background_color) {
//			COLOR.rgb = vec3(1.0, 0.0, 1.0);
//		} else {
//			COLOR.a = 0.0;
//		}
//	} else {
//		COLOR.a = 0.0;
//	}
}
