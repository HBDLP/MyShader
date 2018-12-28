

Shader "MyShader/Chapter10/Mirror-Chapter10"{
	Properties {
		// _Color ("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Tex", 2D) = "white"{}
	}

	SubShader{
		Tags {

		}

		Pass{
			Tags{
				"LightModel" = "ForwardBase"
			}

			CGPROGRAM
			#include "Lighting.cginc"
			
			#pragma vertex vert
			#pragma fragment frag

			// fixed4 _Color;

			sampler2D _MainTex;
			fixed4 _MainTex_ST;


			struct a2v{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;		
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				// o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv = v.texcoord;
                o.uv.x = 1 - o.uv.x;

				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb;

				return fixed4(albedo, 1);
			}
			ENDCG
		}

	}

	Fallback "Specular"
}