Shader "QBox/CoefficientGUI"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        width ("Width", Range(0.0, 0.05)) = 0.03
        sharpness ("Sharpness", Range(1, 5)) = 5
        radius ("Radius", Range(0, 2)) = 1.0
        tint ("Tint", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "colorSpace.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float width;
            float sharpness;
            float radius;
            float4 tint;

            fixed4 frag (v2f i) : SV_Target
            {
                radius = clamp(radius + width, 0.0, 1.0);
                float dist = 2*distance(i.uv, float2(0.5, 0.5));
                float hue = 0.5 + atan2(0.5 - i.uv.y, 0.5 - i.uv.x)/(2*pi);
                float4 color = float4(hsv2rgb(float3(hue, 0.95, dist)), 1);
                color = tint*ring(dist, width, sharpness) + color*disk(dist, radius, width, sharpness) + float4(dist.xxx, 1)*annulus(dist, radius, width, sharpness);
                return color;
            }
            ENDCG
        }
    }
}
