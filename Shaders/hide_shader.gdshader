shader_type spatial;

uniform vec3 ref_position;

varying float dist;

void vertex() {
	vec3 pos = VERTEX.xyz;
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	dist = length(ref_position - world_position);
}

void fragment() {
	if (dist > 2.0){
		ALPHA = 0.0;
	}
	else {
		ALPHA = 1.0;;
	}
}
