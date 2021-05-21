Shader "Custom/ForwardsRadial_Frag"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		c1 ("c1", float) = 0.0
		c2 ("c2", float) = 0.0
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

			uniform float c1;
			uniform float c2;

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

			float forward_radial(const float r)
			{
				// Powers of r are calculated by repeated multiplication for efficiency (over the floating-point pow() function)
				// r + c1 r^3 + c2 r^5
				const float r_2 = r * r; // pow(r, 2.0f)
				const float r_4 = r_2 * r_2; // pow(r, 4.0f)
				return
					r +
					c1 * r_2 * r + // c1 r^3 or c1 * pow(r, 3.0f)
					c2 * r_4 * r; // c2 r^5 or c2 * pow(r, 5.0f)
			}

			float2 forward_point(const float2 pos)
			{
				// Get the distance from (0.0, 0.0) to pos
				const float r_old = length(pos);

				// If r_old == 0.0, r_new == 0.0, hence return 0.0 (to prevent division by zero)
				if (r_old == 0.0f) return float2(0.0f, 0.0f);

				// Perform the Brown's simplified forwards radial transformation
				const float r_new = forward_radial(r_old);

				// Scale the coordinates by the adjusted r
				return pos * r_new / r_old;
			}

			float2 forward_uv(const float2 uv)
			{
				// Normalise the UV to between -1.0 and 1.0
				// Calculate the forwards transform of the normalised UV
				// Unnormalise the transformed point back to UV between 0.0 and 1.0
				// (0.0 to 1.0) to (-1.0 to 1.0) to (0.0 to 1.0)
				return 0.5f * (forward_point(2.0f * uv - 1.0f) + 1.0f);
			}

			vf vert(const appdata v)
			{
				vf o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			uniform sampler2D _MainTex;

			fixed4 frag(const vf i) : SV_Target
			{
				// Perform Brown's forwards radial transform for the texture UV position of this fragment
				const float2 uv = forward_uv(i.uv);

				// Discard the fragment if the distorted UV position is out of texture bounds
				if (uv.x < 0.0f || uv.x > 1.0f ||
					uv.y < 0.0f || uv.y > 1.0f)
					discard;

				// Sample colour from transfomed position
				return tex2D(_MainTex, uv);
			}
			ENDCG
		}
	}
}