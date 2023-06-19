shader_type spatial;

uniform vec3 reference_position;
uniform float max_distance;

render_mode depth_draw_always, unshaded;

void fragment() {
	if (length((INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz - reference_position) > max_distance) {
		ALBEDO *= 0.05;
	} else {
		discard;
	}
}
