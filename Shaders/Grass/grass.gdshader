shader_type spatial;

render_mode cull_disabled, diffuse_toon, specular_toon;

uniform vec4 color_a: source_color;
uniform vec4 color_b: source_color;
global uniform vec3 player_position;
uniform sampler2D wind_noise;
uniform sampler2D grass_mask;

varying float height;
varying float should_discard;

vec3 wind_direction(vec2 wind_uv, mat4 model_matrix) {
	ivec2 noise_size = textureSize(wind_noise, 0);
	float x_wind = texture(wind_noise, mod(wind_uv, float(noise_size.x))).r - 0.5;
	float z_wind = texture(wind_noise, mod(wind_uv + (vec2(noise_size) / 2.0), float(noise_size.x))).r - 0.5;
	return (vec4(x_wind, 0.0, z_wind, 1.0) * model_matrix).xyz;
}

void vertex() {
	should_discard = 0.0;
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	//NODE_POSITION_WORLD, when accessed in vertex, corresponds to each instance
	//in fragment it is the whole multiMeshInstance as one
	vec3 vector_from_ref_pos = NODE_POSITION_WORLD - player_position;
	vec3 dir = normalize(vector_from_ref_pos * vec3(1.0,0.0,1.0));
	vec3 local_dir = (vec4(dir,1.0) * MODEL_MATRIX).xyz;
	float dist = length(vector_from_ref_pos);
	if (dist < 0.5) {
		should_discard = 1.0;
	}
	vec2 mask_uv = vec2(NODE_POSITION_WORLD.x, NODE_POSITION_WORLD.z) / 10.0;
	float mask_alpha = texture(grass_mask, mask_uv).r;
	if (mask_alpha > 0.5) {
		should_discard = 1.0;
	} else {
		VERTEX.y *= 1.0 - smoothstep(0.2, 0.5, mask_alpha);
	}
	VERTEX += (local_dir * (VERTEX.y * VERTEX.y)) / (dist / 2.0);
	VERTEX += wind_direction(vec2(TIME * 0.005), MODEL_MATRIX) * (VERTEX.y * VERTEX.y) * 3.0;
	height = VERTEX.y;
}

void fragment() {
	if (should_discard > 0.5) {
		discard;
	}
	ALBEDO = mix(color_a, color_b, height).rgb;
}
