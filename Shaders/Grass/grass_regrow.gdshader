shader_type canvas_item;

uniform sampler2D current_texture;

void vertex() {
	
}

void fragment() {
	//float new_red = min(1.0, texture(current_texture, UV).r + 0.0);
	//COLOR = vec4(new_red, texture(current_texture, UV).gba);
	COLOR = texture(current_texture, UV);
}
