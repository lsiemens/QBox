#version 330 core
in vec2 TextureCoords;
out vec4 color;

uniform sampler2DArray texture0;

void main() {
    color = texture(texture0, vec3(TextureCoords, 0.0));
}
