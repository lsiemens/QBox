// Utility for printing basic debug info on the screen

//#define DEBUG

// display a number n (value) in the range [0, 10] by drawing n bands.
float4 _basicDebug(float4 color, float2 uv, float value, int offsetx, int offsety, float4 tint) {
    #ifdef DEBUG
    float pi = 3.1415926535;
    float boarder = 0.01;
    float2 size = float2(0.1, 0.05);
    float2 offset = float2(offsetx*(boarder*2 + size.x) + boarder, offsety*(boarder*2 + size.y) + boarder);

    float x = (uv.x - offset.x)/size.x;

    if (uv.x > offset.x && uv.x < (offset.x + size.x)) {
        if (uv.y > offset.y && uv.y < (offset.y + size.y)) {
            color = (0.5 - 0.5*cos(2*pi*x*value))*tint;
            if (value < 0) {
                color = float4(1, 0, 0, 1);
            }
            if (value > 10) {
                color = float4(0, 1, 0, 1);
            }
        }
    }
    #endif
    return color;
}

// display a floating point number in scientific notation. the exponent is the last number.
float4 DebugSCI(float4 color, float2 uv, float value, int significantDigits, int offsety) {
    #ifdef DEBUG
    bool isPositive = true;
    bool expIsPositive = true;
    if (value < 0) {
        isPositive = false;
    }
    value = abs(value);
    float tmp = log(value)/log(10);
    float digit = exp((tmp - floor(tmp))*log(10));
    if (tmp < 0) {
        expIsPositive = false;
    }
    float exponent = abs(floor(tmp));
    float4 digTint = float4(1, 1, 1, 1);
    if (!isPositive) {
        digTint = float4(1, 0, 0, 1);
    }

    float4 expTint = float4(0, 0, 1, 1);
    if (!expIsPositive) {
        expTint = float4(1, 0, 1, 1);
    }

    for (int i = 0; i < significantDigits; i++) {
        if (i < significantDigits - 1) {
            color = _basicDebug(color, uv, floor(digit), i, offsety, digTint);
        } else {
            color = _basicDebug(color, uv, digit, i, offsety, digTint);
        }
        digit = 10*(digit - floor(digit));
    }
    return _basicDebug(color, uv, exponent, i, offsety, expTint);
    #else
    return color;
    #endif
}
