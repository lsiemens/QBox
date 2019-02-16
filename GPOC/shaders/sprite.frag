#version 330 core
in vec2 TextureCoords;
out vec4 color;

uniform sampler2DArray texture0;

void main() {
    vec4 state = texture(texture0, vec3(TextureCoords, 0));
    color = (100.0f*100.0f)*state*state;
    if (abs((state*state).x - 0.0001) < 0.00001) {
        color = vec4(1.0, 1.0, 1.0, 1.0);
    }
}
