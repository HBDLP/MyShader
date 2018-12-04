﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "MyShader/Chapter6/Specular Pixel-Level"
{
	Properties{
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}

	SubShader{
		Pass{
			Tags {"LightModel" = "ForwardBase"}
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Diffuse;
			fixed4 _Specular;
			fixed _Gloss;

			struct a2v{
				float4 vertex : POSITION;
				float4 normal : NORMAL;

			};

			struct v2f{
				float4 pos : SV_POSITION;
				float4 worldNormal : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul(v.normal, unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				return o;
			};

			fixed4 frag(v2f i) : SV_TARGET{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
				fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 specualr = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(viewDir, reflectDir)), _Gloss);

				fixed3 color = ambient + diffuse + specualr;

				return fixed4(color, 1.0);
			}
			ENDCG

		}
	}

	Fallback "Specular"

}