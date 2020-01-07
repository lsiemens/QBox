Shader "QBox/QuantumStates"
{
    Properties
    {
        _States ("States", 2DArray) = "" {}
        _Potential ("Potential", 2D) = "white" {}
        _Index ("index", Range(0, 4)) = 0
        _Color ("color", Color) = (1.0, 0.0, 0.0, 0.0)
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            int _Index;
            float4 _Color;
            sampler2D _Potential;
            UNITY_DECLARE_TEX2DARRAY(_States);

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = UNITY_SAMPLE_TEX2DARRAY(_States, float3(i.uv.x, i.uv.y, _Index)); // integer indexing
                float pot = tex2D(_Potential, i.uv);
                col.a = pot; // since the alpha channel is empty anyway
                col = col*_Color;
                return col*col + col.a;
            }
            ENDCG
        }
    }
}
