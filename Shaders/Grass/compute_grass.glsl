#[compute]
#version 460

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 0, binding = 0, rgba8) restrict uniform image2D inout_image;

layout(set = 0, binding = 1, std430) restrict readonly buffer CoordBuffer {
    float coords[];
}
coord_buffer;

void main() {
    ivec2 texel = ivec2(gl_GlobalInvocationID.xy);
    vec4 existing_color = imageLoad(inout_image, texel);
    vec4 color = existing_color - 0.005;
    imageStore(inout_image, texel, color);
    bool should_draw = false;
    for (int i = 0; i < coord_buffer.coords.length(); i += 3) {
        vec2 draw_coord = vec2(coord_buffer.coords[i], coord_buffer.coords[i+1]);
        if (length(texel - draw_coord) < coord_buffer.coords[i+2]) {
            should_draw = true;
            break;
        }
    }
    if (should_draw) {
        imageStore(inout_image, texel, vec4(0.0, 0.0, 0.0, 1.0));
    }
}
