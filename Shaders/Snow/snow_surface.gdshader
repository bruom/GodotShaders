shader_type spatial;

uniform float snow_amount;
uniform sampler2D noise_tex;

varying vec3 local_pos;
varying vec3 world_normal;

void vertex() {
	local_pos = VERTEX.xyz;
	world_normal = (MODEL_MATRIX * vec4(NORMAL, 1.0)).xyz;
	float dot_prod = dot(world_normal, vec3(0.0,1.0,0.0));
	if (dot_prod > 0.2) {
		VERTEX.y += (texture(noise_tex, VERTEX.xz).r * 0.3 * dot_prod) - 0.1;
	}
}

void fragment() {
	float dot_prod = dot(world_normal, vec3(0.0,1.0,0.0));
	if (local_pos.y < 0.0 || dot_prod <= 0.2) {
		discard;
	}
}
