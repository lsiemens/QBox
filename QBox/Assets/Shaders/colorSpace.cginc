// conversion functions from http://www.chilliant.com/rgb2hsv.html

float3 hsv2rgb(float3 hsv)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(frac(hsv.xxx + K.xyz) * 6.0 - K.www);
    return hsv.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), hsv.y);
}

float3 hsl2rgb(in float3 hsl)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(frac(hsl.xxx + K.xyz) * 6.0 - K.www);
    float chroma = (1 - abs(2 * hsl.z - 1)) * hsl.y;
    return (clamp(p - K.xxx, 0.0, 1.0) - 0.5) * chroma + hsl.z;
}

float disk(float distance, float radius, float width, float sharpness) {
    return clamp(sharpness*(radius - distance - width)/width, 0, 1);
}

float annulus(float distance, float radius, float width, float sharpness) {
    return disk(distance, 1, width, sharpness) - disk(distance, radius, width, sharpness);
}

float ring(float distance, float width, float sharpness) {
    return annulus(distance - width, 1 - width, width, sharpness);
}

/*float disk(float distance, float radius, float width, float sharpness) {
    return clamp(sharpness*(radius - distance - width)/width, 0, 1);
}

float annulus(float distance, float radius, float width, float sharpness) {
    return disk(distance, 1, width, sharpness) - disk(distance, radius, width, sharpness);
}

float ring(float distance, float width, float sharpness) {
    return annulus(distance - width, 1 - width, width, sharpness);
}*/

static const float pi = 3.1415926535;
