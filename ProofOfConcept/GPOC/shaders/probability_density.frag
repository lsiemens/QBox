#version 330 core

#define num_states // this will be redefined at compile time

in vec2 TextureCoords;
out vec4 color;

uniform sampler2DArray texture0;
uniform float shader_range;
uniform float time;
uniform vec2 qcoefficients[num_states];
uniform float energy[num_states];

vec3 color_rgb = vec3(0.0);
vec2 state = vec2(0.0);
vec2 time_phase = vec2(0.0);

void main() {
    for (int i = 0; i < num_states; i++) {
        time_phase = vec2(cos(-energy[i]*time), sin(-energy[i]*time));
        state += vec2(qcoefficients[i].x*time_phase.x - qcoefficients[i].y*time_phase.y, qcoefficients[i].x*time_phase.y + qcoefficients[i].y*time_phase.x)*texture(texture0, vec3(TextureCoords, i)).x;
    }
    color_rgb = vec3(1.0, 1.0, 1.0)*dot(state, state)/(shader_range*shader_range);
    color = vec4(color_rgb, 1.0);
}
