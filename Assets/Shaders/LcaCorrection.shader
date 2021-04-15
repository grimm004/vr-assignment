Shader "Custom/LcaCorrection"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        shift_r ("Red Shift", float) = -0.01
        shift_g ("Green Shift", float) = 0.00
        shift_b ("Blue Shift", float) = 0.01
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

            struct vf
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            vf vert (const appdata v)
            {
                vf o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float shift_r;
            float shift_g;
            float shift_b;

            fixed4 frag(const vf i) : SV_Target
            {
            	// i.uv.x (0.0 to 1.0) -> correction.x (-1.0 to 1.0)
                const float correction = float2(2.0f * i.uv.x - 1.0f, 0.0f);
            	
	            const float2 pos_r = i.uv + shift_r * correction;
                const float2 pos_g = i.uv + shift_g * correction;
                const float2 pos_b = i.uv + shift_b * correction;
            	
				float col_r = tex2D(_MainTex, pos_r).r;
                float col_g = tex2D(_MainTex, pos_g).g;
                float col_b = tex2D(_MainTex, pos_b).b;
            	
                return fixed4(col_r, col_g, col_b, 1.0f);
            }
            ENDCG
        }
    }
}
