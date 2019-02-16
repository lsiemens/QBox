#version 330 core
layout (location = 0) in vec4 vertex; //  <vec2 position, vec2 TextureCoords>

out vec2 TextureCoords;

void main() {
    TextureCoords = vertex.zw;
    gl_Position = vec4(vertex.xy, 0.0, 1.0);
}
