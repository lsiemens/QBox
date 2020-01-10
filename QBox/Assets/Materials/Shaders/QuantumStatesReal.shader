Shader "QBox/QuantumStatesReal"
{
    Properties
    {
        _States ("States", 2DArray) = "" {}
        // _Potential texture slot called _MainTex to keep unity from raising errors about missing _MainTex
        _MainTex ("Potential", 2D) = "white" {}
        _MaxIndex ("Maximum Index", Range(0, 1023)) = 0
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

            float _Scale;
            int _MaxIndex;
            float4 _RealCoefficients[1023];
            float4 _ImaginaryCoefficients[1023];
            sampler2D _MainTex;
            UNITY_DECLARE_TEX2DARRAY(_States);

            float4 RealValue, ImaginaryValue;
            float2 Phi;

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
                return float4(Phi.x, -Phi.x, 0.0, 0.0)*exp(_Scale) + pot/10;
            }
            ENDCG
        }
    }
}
