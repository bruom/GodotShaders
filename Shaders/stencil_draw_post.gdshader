shader_type spatial;

render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

uniform float cam_near;
uniform float cam_far;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z/10.0;
	float normalized_depth = (linear_depth - cam_near)/(cam_far - cam_near);
	ALBEDO = vec3(normalized_depth, 0.0, 0.0);
	ALPHA = texture(screen_texture, SCREEN_UV).a;
}
