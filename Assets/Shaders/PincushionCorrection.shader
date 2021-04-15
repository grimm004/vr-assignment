Shader "Custom/PuncushionCorrection"
{
	Properties
	{
		main_tex("Texture", 2D) = "white" {}
		c1("c1", float) = 1
		c2("c2", float) = 1
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

			vf vert(const appdata v)
			{
				vf o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D main_tex;
			float c1;
			float c2;

			float forward_radial(const float r)
			{
				// r + c1 r^3 + c2 r^5
				const float r_2 = r * r;
				const float r_4 = r_2 * r_2;
				return
					r +
					c1 * r_2 * r + // c1 r^3
					c2 * r_4 * r; // c2 r^5
			}

			float2 forward_point(const float2 frag)
			{
				return normalize(frag) * forward_radial(length(frag));
			}

			float inverse_radial(const float r)
			{
				// (c1 r^2 + c2 r^4 + c1^2 r^4 + c2^2 r^8 + 2 c1 c2 r^6) / (1 + 4 c1 r^2 + 6 c2 r^4)
				const float r_2 = r * r;
				const float r_4 = r_2 * r_2;
				const float r_8 = r_4 * r_4;
				return
					(
						c1 * r_2 + // c1 r^2
						c2 * r_4 + // c2 r^4
						c1 * c1 * r_4 + // c1^2 r^4
						c2 * c2 * r_8 + // c2^2 r^8
						2.0f * c1 * c2 * r_4 * r_2 // 2 c1 c2 r^6
					) /
					(
						1.0f +
						4.0f * c1 * r_2 + // 4 c1 r^2
						6.0f * c2 * r_4 // 6 c2 r^4
					);
			}

			float2 inverse_point(const float2 pos)
			{
				float r = length(pos);
				const float theta = atan2(pos.y, pos.x);
				
				r = inverse_radial(r);

				// return 0.5f * (rNew * pos / r + 1.0f);

				return 0.5f * (r * float2(cos(theta), sin(theta)) + 1.0f);
			}

			fixed4 frag(vf i) : SV_Target
			{
				// i.uv (0.0 to 1.0) to vec (-1.0 to 1.0)
				const float2 pos = 2.0f * i.uv - 1.0f;

				// pos (-1.0 to 1.0) to i.uv (0.0 to 1.0)
				i.uv = inverse_point(pos);

				if (i.uv.x < 0.0f || i.uv.x > 1.0f || i.uv.y < 0.0f || i.uv.y > 1.0f)
					discard;
				
				// Sample colour from transfomed position
				return tex2D(main_tex, i.uv);
			}
			ENDCG
		}
	}
}