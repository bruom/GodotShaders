shader_type spatial;
render_mode cull_disabled, unshaded;

uniform float liquid_cutoff_point;
uniform float intersection_height;
uniform vec4 liquid_color: source_color;
uniform vec4 top_color: source_color;
uniform vec4 fresnel_color: source_color;
uniform vec2 surface_motion;
uniform float fresnel_strength;

varying vec3 relative_pos;

vec3 rotate_about_x(vec3 input, float angle_deg) {
	float angle_rad = radians(angle_deg);
	float sine = sin(angle_rad);
	float cosine = cos(angle_rad);
	
	mat3 rot_mat = mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, cosine, -sine),
		vec3(0.0, sine, cosine)
	);
	
	return rot_mat * input;
}

vec3 rotate_about_z(vec3 input, float angle_deg) {
	float angle_rad = radians(angle_deg);
	float sine = sin(angle_rad);
	float cosine = cos(angle_rad);
	
	mat3 rot_mat = mat3(
		vec3(cosine, -sine, 0.0),
		vec3(sine, cosine, 0.0),
		vec3(0.0, 0.0, 1.0)
	);
	
	return rot_mat * input;
}

void vertex() {
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	relative_pos = world_pos - NODE_POSITION_WORLD;
	//apply rotation matrix here for surface movement
	vec3 x_rotated = rotate_about_x(relative_pos, 90);
	vec3 z_rotated = rotate_about_z(relative_pos, 90);
	relative_pos += (x_rotated * surface_motion.x) + (z_rotated * surface_motion.y);
}

void fragment() {
	if (relative_pos.y > liquid_cutoff_point) {
		discard;
	}
	
	vec3 world_normal = (INV_VIEW_MATRIX * vec4(NORMAL,1.0)).xyz;
	float fresnel = pow(1.0 - dot(world_normal, VIEW), fresnel_strength);
	
	if (FRONT_FACING) {
		ALBEDO = liquid_color.rgb;
		if (relative_pos.y > liquid_cutoff_point - intersection_height) {
			ALBEDO = liquid_color.rgb + vec3(0.3);
		}
		//ALBEDO += (fresnel_color * fresnel).rgb;
	} else {
		ALBEDO = top_color.rgb;
	}
}