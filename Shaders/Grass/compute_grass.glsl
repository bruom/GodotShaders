#[compute]
#version 460

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 0, binding = 0, rgba8) restrict uniform image2D inout_image;

void main() {
    ivec2 texel = ivec2(gl_GlobalInvocationID.xy);
    vec4 existing_color = imageLoad(inout_image, texel);
    vec4 color = vec4(min(1.0, existing_color.a + 0.1) ,existing_color.gba);
    imageStore(inout_image, texel, color);
}
