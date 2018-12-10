// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "MyShader/Chapter7/RampTexture-Chapter7"{
	Properties{
		_Color("Color", Color) = (1, 1, 1, 1)
		_RampTex("Ramp Tex", 2D) = "white"{}
		_Specualr("Specualr", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8, 256)) = 20		
	}

	SubShader{
		Pass{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;
			sampler2D _RampTex;
			fixed4 _RampTex_ST;
			fixed4 _Specualr;
			float _Gloss;

			struct a2v{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.uv = TRANSFORM_TEX(v.texcoord, _RampTex);

				return o;
			};

			fixed4 frag(v2f i) : SV_TARGET
			{
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed halfLambert = 0.5 * dot(worldNormal, worldLightDir) + 0.5;
				fixed3 diffuseColor = tex2D(_RampTex, fixed2(halfLambert, halfLambert)).xyz * _Color.rgb;
				fixed3 diffuse = _LightColor0.rgb * diffuseColor;

				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specualr * pow(saturate(dot(worldNormal, halfDir)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1);
			}
			


			ENDCG
		}
	}

	Fallback "Specular"
}