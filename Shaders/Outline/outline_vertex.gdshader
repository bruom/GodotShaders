shader_type spatial;

render_mode unshaded, cull_front;

uniform float outline_width;
uniform vec4 outline_color: source_color = vec4(1.0);

void vertex() {
	VERTEX += VERTEX * outline_width;
}

void fragment() {
	ALBEDO = outline_color.xyz;
}
