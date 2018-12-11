﻿Shader "MyShader/Chapter7/MaskTexture-Chapter7"
{
	Properties {
		_Color ("Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Tex", 2D) = "white"{}
		_BumpMap("Bump Map", 2D) = "bump"{}
		_BumpScale("Bump Scale", Float) = 1
		_SpecularMask("Specular Mask", 2D) = "white"{}
		_SpecularScale("Specular Scale", Float) = 1
		_Specular("Color", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8, 256)) = 20
	}

	SubShader{
		pass{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;
			sampler2D _MainTex;
			float4  _MainTex_ST;
			sampler2D _BumpMap;
			float _BumpScale;
			sampler2D _SpecularMask;
			float _SpecularScale;
			fixed4 _Specular;
			float _Gloss;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float3 lightDir : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				TANGENT_SPACE_ROTATION;
				o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
				o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				fixed3 tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);

				fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, i.uv));
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				fixed3 diffus = _LightColor0 * albedo * saturate(dot(tangentLightDir, tangentNormal));
				fixed3 specularMask = tex2D(_SpecularMask, i.uv).r * _SpecularScale;
				fixed3 halfDir = normalize(tangentViewDir + tangentLightDir);
				fixed3 specular = _LightColor0 * albedo * _Specular * pow(saturate(dot(tangentNormal, halfDir)), _Gloss) * specularMask;

				return fixed4(ambient + diffus + specular, 1);
			}
			ENDCG
		}
	}
}