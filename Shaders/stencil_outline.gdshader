shader_type canvas_item;

render_mode unshaded, blend_mul;

uniform float depth_threshold;
uniform float outline_pixel_width;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

float diff(vec4 center, vec4 other) {
	return center.r - other.r;
}

void fragment() {
	bool is_outline = false;
	if (outline_pixel_width > 0.0) {
		
		vec4 cur_pixel = texture(screen_texture, UV);
		for (lowp float x = -outline_pixel_width; x <= outline_pixel_width; x += 1.0) {
			for (lowp float y = -outline_pixel_width; y <= outline_pixel_width; y += 1.0) {
				float len = length(vec2(x, y));
				if (len > outline_pixel_width) {
					continue;
				}
				//COLOR.a = 1.0/len;
				vec4 this_pixel = texture(screen_texture, UV - SCREEN_PIXEL_SIZE.xy * vec2(x,y));
				if ((cur_pixel.r == 0.0 && this_pixel.r != 0.0) || (cur_pixel.r != 0.0 && this_pixel.r != 0.0 && diff(cur_pixel, this_pixel) > depth_threshold)) {
					is_outline = true;
				}
			}
		}
	}
	if (is_outline) {
		COLOR.rgb = vec3(1.0, 0.5, 1.0);
		COLOR.a = 1.0;
	} else {
		COLOR.a = 0.0;
	}
}
