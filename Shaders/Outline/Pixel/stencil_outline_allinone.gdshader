shader_type spatial;

render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

uniform float depth_threshold;
uniform float outline_pixel_width;
uniform float cam_near;
uniform float cam_far;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

float get_depth(vec2 uv, mat4 inv_proj_matrix) {
	float depth = texture(depth_texture, uv).x;
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth);
	vec4 view = inv_proj_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z/10.0;
	float normalized_depth = (linear_depth - cam_near)/(cam_far - cam_near);
	return normalized_depth;
}

void fragment() {
	bool is_outline = false;
	vec2 screen_pixel_size = 1.0 / VIEWPORT_SIZE;
	
	if (outline_pixel_width > 0.0) {
		vec4 cur_pixel = texture(screen_texture, SCREEN_UV);
		float cur_depth = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
		
		for (lowp float x = -outline_pixel_width; x <= outline_pixel_width; x += 1.0) {
			for (lowp float y = -outline_pixel_width; y <= outline_pixel_width; y += 1.0) {
				float len = length(vec2(x, y));
				if (len > outline_pixel_width) {
					continue;
				}
				//COLOR.a = 1.0/len;
				vec2 this_pixel_uv = SCREEN_UV - screen_pixel_size.xy * vec2(x,y);
				vec4 this_pixel = texture(screen_texture, this_pixel_uv);
				float this_pixel_depth = get_depth(this_pixel_uv, INV_PROJECTION_MATRIX);
				if ((cur_pixel.a == 0.0 && this_pixel.a != 0.0) || (cur_pixel.a != 0.0 && this_pixel.a != 0.0 && cur_depth - this_pixel_depth > depth_threshold)) {
					is_outline = true;
				}
			}
		}
	}
	
	if (is_outline) {
		ALBEDO.rgb = vec3(1.0, 0.5, 1.0);
		//ALPHA = 1.0;
	} else {
		ALPHA = 0.0;
	}
}
