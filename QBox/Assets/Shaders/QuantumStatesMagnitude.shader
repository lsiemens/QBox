Shader "QBox/QuantumStatesMagnitude"
{
    Properties
    {
        _States ("States", 2DArray) = "" {}
        // _Potential texture slot called _MainTex to keep unity from raising errors about missing _MainTex
        _MainTex ("Potential", 2D) = "white" {}
        // _MaxIndex ("Maximum Index", Range(0, 1023)) = 0
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
            #include "debug.cginc"

            #define NMAX 16
            #pragma multi_compile T32 T64 T128 T256 T512 T1024 T2048

            #ifdef T32
                #undef NMAX
                #define NMAX 32
            #endif

            #ifdef T64
                #undef NMAX
                #define NMAX 64
            #endif

            #ifdef T128
                #undef NMAX
                #define NMAX 128
            #endif

            #ifdef T256
                #undef NMAX
                #define NMAX 256
            #endif

            #ifdef T512
                #undef NMAX
                #define NMAX 512
            #endif

            #ifdef T1024
                #undef NMAX
                #define NMAX 1024
            #endif

            #ifdef T2048
                #undef NMAX
                #define NMAX 2048
            #endif

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

            float _Scale;
            int _MaxIndex;
            float4 _RealCoefficients[NMAX];
            float4 _ImaginaryCoefficients[NMAX];
            sampler2D _MainTex;
            UNITY_DECLARE_TEX2DARRAY(_States);

            float4 RealValue, ImaginaryValue;
            float2 Phi;
            float4 temp;

            fixed4 frag (v2f i) : SV_Target
            {
                RealValue = 0.0;
                ImaginaryValue = 0.0;
                for (int j = 0; j < _MaxIndex; j++) {
                    RealValue += _RealCoefficients[j]*UNITY_SAMPLE_TEX2DARRAY(_States, float3(i.uv.x, i.uv.y, j));
                    ImaginaryValue += _ImaginaryCoefficients[j]*UNITY_SAMPLE_TEX2DARRAY(_States, float3(i.uv.x, i.uv.y, j));
                }
                Phi.x = RealValue.r + RealValue.g + RealValue.b;
                Phi.y = ImaginaryValue.r + ImaginaryValue.g + ImaginaryValue.b;

                float pot = tex2D(_MainTex, i.uv);
                temp = float4((Phi.x*Phi.x + Phi.y*Phi.y)*exp(_Scale), 0.0, 0.0, 0.0) + pot/10;
                temp = DebugSCI(temp, i.uv, NMAX, 3, 0);
                //temp = DebugSCI(temp, i.uv, _MaxIndex, 3, 1);
                return temp;
                //return (Phi.x*Phi.x + Phi.y*Phi.y)*exp(_Scale);
            }
            ENDCG
        }
    }
}
