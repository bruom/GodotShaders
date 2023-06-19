shader_type spatial;
render_mode depth_prepass_alpha, depth_draw_opaque, unshaded;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float distance_falloff : hint_range(0, 5) = 1;
uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D depth_texture: hint_depth_texture;

float linear_depth(in vec2 screen_uv, in mat4 inv_projection_matrix){
	float raw_depth = texture(depth_texture, screen_uv)[0];
	vec3 normalized_device_coordinates = vec3(screen_uv * 2.0 - 1.0, raw_depth);
	vec4 view_space = inv_projection_matrix * vec4(normalized_device_coordinates, 1.0);	
    return -view_space.z;
}

float abs_diff(float depth_a, float depth_b){
	return abs(abs(depth_a)-abs(depth_b));
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	ALBEDO = outline_color.rgb;
	float d = linear_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
	vec2 screen_size = vec2(textureSize(screen_texture, 1));
	vec2 pixel_size = (distance_falloff / d) / vec2(screen_size.x, screen_size.y);
	
	float du = linear_depth(SCREEN_UV+vec2(0.0, pixel_size.y), INV_PROJECTION_MATRIX);
	float dd = linear_depth(SCREEN_UV+vec2(0.0, -pixel_size.y), INV_PROJECTION_MATRIX);
	float dr = linear_depth(SCREEN_UV+vec2(pixel_size.x, 0.0), INV_PROJECTION_MATRIX);
	float dl = linear_depth(SCREEN_UV+vec2(-pixel_size.x, 0.0), INV_PROJECTION_MATRIX);

	// combine all the abs differences in depth of neighbors
	ALPHA = 
		abs_diff(d, du) +
		abs_diff(d, dl) +
		abs_diff(d, dd) +
		abs_diff(d, dr) 
	;
	
	//ALPHA = smoothstep(smoothing_cutoff, max(smoothing_cutoff, smoothing_max), ALPHA);
	ALPHA *= outline_color.a;
	ALPHA = clamp(ALPHA, 0.0, 1.0);
}
