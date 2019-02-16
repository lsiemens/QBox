#version 330 core
in vec2 TextureCoords;
out vec4 color;

uniform sampler2D image;

void main() {
    color = texture(image, vec3(TextureCoords, 1.0));
}
