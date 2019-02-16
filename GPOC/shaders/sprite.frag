#version 330 core
in vec2 TextureCoords;
out vec4 color;

uniform sampler2D texture0;

void main() {
    color = vec4(0.2, 1.0, 0.5, 1.0)*texture(texture0, TextureCoords, 1.0).x;
}
