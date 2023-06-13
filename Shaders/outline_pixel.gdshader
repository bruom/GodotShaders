shader_type spatial;

render_mode unshaded, cull_front, skip_vertex_transform;

uniform float outline_width;
uniform vec4 outline_color: source_color = vec4(1.0);

void vertex() {
	mat4 matrix_m = MODEL_MATRIX;
	mat4 matrix_vp = PROJECTION_MATRIX * VIEW_MATRIX;
	
	vec4 clip_position = matrix_vp * (matrix_m * vec4(VERTEX, 1.0));
	vec3 clip_normal = mat3(matrix_vp) * (mat3(matrix_m) * NORMAL);

	vec2 screen_size = VIEWPORT_SIZE;
	vec2 offset = normalize(clip_normal.xy) / screen_size.xy * outline_width * clip_position.w * 2.0;
	clip_position.xy += offset;
	
	VERTEX = (INV_PROJECTION_MATRIX * clip_position).xyz;
}

void fragment() {
	ALBEDO = outline_color.xyz;
}
