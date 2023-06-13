shader_type spatial;

render_mode cull_disabled, unshaded;

uniform sampler2D screen_texture : hint_screen_texture; 

void vertex() {
    POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	ALBEDO = vec3(1.0);
	ALPHA = texture(screen_texture, SCREEN_UV).a;
}