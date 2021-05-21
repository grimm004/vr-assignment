Shader "Custom/LateralChromaticAberration"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
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
            
            uniform float shift_r;
            uniform float shift_g;
            uniform float shift_b;

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

            struct polar2
            {
                float r;
                float theta;
            };

            polar2 uv_to_polar(const float2 uv)
            {
                // Convert UV positions to polar coordinates
                const float2 pos = 2.0f * uv - 1.0f;
                polar2 p;
                p.r = length(pos);
                p.theta = atan2(pos.y, pos.x);
                return p;
            }

            float2 polar_to_uv(const polar2 polar)
            {
                // Convert polar coordinates back to UV space
                return 0.5f * (polar.r * float2(cos(polar.theta), sin(polar.theta)) + 1.0f);
            }

            vf vert (const appdata v)
            {
                vf o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            uniform sampler2D _MainTex;

            fixed4 frag(const vf i) : SV_Target
            {
            	// Convert the texture UV position to polar coorindates
                // i.uv.x (0.0 to 1.0) -> correction.x (-1.0 to 1.0)
                const polar2 polar = uv_to_polar(i.uv);

            	// Shift the red posiiton linearly by shift_r
				polar2 r;
                r.r = polar.r + polar.r * shift_r;
                r.theta = polar.theta;

                // Shift the green position linearly by shift_g
				polar2 g;
                g.r = polar.r + polar.r * shift_g;
                g.theta = polar.theta;

                // Shift the blue position linearly by shift_b
				polar2 b;
                b.r = polar.r + polar.r * shift_b;
                b.theta = polar.theta;

            	// Convert the red, green and blue polar coordinates back to UV space
                const float2 pos_r = polar_to_uv(r);
                const float2 pos_g = polar_to_uv(g);
                const float2 pos_b = polar_to_uv(b);

            	// Sample the colour from each respective colour position
				const float col_r = tex2D(_MainTex, pos_r).r;
                const float col_g = tex2D(_MainTex, pos_g).g;
                const float col_b = tex2D(_MainTex, pos_b).b;

            	// Return the combined colour
                return fixed4(col_r, col_g, col_b, 1.0f);
            }
            ENDCG
        }
    }
}
