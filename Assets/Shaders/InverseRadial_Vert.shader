Shader "Custom/InverseRadial_Vert"
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

			float2 inverse_point(const float2 pos)
			{
				// Get r^2 (where r is the distance from (0.0, 0.0) to pos)
				// There is no need to calculate r as the formula contains no odd powers.
				const float r_2 = dot(pos, pos);
				// const float r = sqrt(r_2);

				// Powers of r are calculated by repeated multiplication for efficiency (over the floating-point pow() function)
				// pos - pos (c1 r^2 + c2 r^4 + c1^2 r^4 + c2^2 r^8 + 2 c1 c2 r^6) / (1 + 4 c1 r^2 + 6 c2 r^4)
				const float r_4 = r_2 * r_2; // pow(r, 4.0f)
				const float r_8 = r_4 * r_4; // pow(r, 8.0f)
				return pos * (
					1.0f - (
						c1 * r_2 + // c1 r^2 or c1 * pow(r, 2.0f)
						c2 * r_4 + // c2 r^4 or c2 * pow(r, 4.0f)
						c1 * c1 * r_4 + // c1^2 r^4 or pow(c1, 2) * pow(r, 4.0f)
						c2 * c2 * r_8 + // c2^2 r^8 or pow(c2, 2) * pow(r, 8.0f)
						2.0f * c1 * c2 * r_4 * r_2 // 2 c1 c2 r^6 or 2.0f * c1 * c2 * pow(r, 6.0f)
						) /
					(
						1.0f +
						4.0f * c1 * r_2 + // 4 c1 r^2 or 4.0f * c1 * pow(r, 2.0f)
						6.0f * c2 * r_4 // 6 c2 r^4 or 6.0f * c2 * pow(r, 2.0f)
						));
			}

			vf vert(const appdata v)
			{
				vf o;
				const float4 vertex = UnityObjectToClipPos(v.vertex);
				// Perform Brown's simplified inverse radial transform for the vertex position of this vertex in clip space
				// (-1.0 to 1.0) for xy, (0.0) for z, (1.0) for w
				o.vertex = float4(inverse_point(vertex.xy), vertex.zw);
				o.uv = v.uv;
				return o;
			}

			uniform sampler2D _MainTex;

			fixed4 frag(const vf i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}