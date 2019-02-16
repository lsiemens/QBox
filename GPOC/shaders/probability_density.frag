#version 330 core
in vec2 TextureCoords;
out vec4 color;

uniform sampler2DArray texture0;
uniform float shader_range;

vec3 color_rgb;

void main() {
    float state = texture(texture0, vec3(TextureCoords, 3)).x;
    color_rgb = vec3(1.0, 1.0, 1.0)*state*state/(shader_range*shader_range);
    color = vec4(color_rgb, 1.0);
}
