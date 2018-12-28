

Shader "MyShader/Chapter10/Fresnel-Chapter10"{
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_FresnelScale ("Fresnel Scale", Range(0, 1)) = 1
		_Cubemap ("Reflection CubeMap", Cube) = "_Skybox" {}

		_MainTex("Main Tex", 2D) = "white"{}
		_BumpMap("Bump Map", 2D) = "bump"{}
		_BumpScale("Bump Scale", Float) = 1.0
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8, 256)) = 20
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
			#include "AutoLight.cginc"
			
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;
			float _FresnelScale;
			samplerCUBE _Cubemap;

			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			sampler2D _BumpMap;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				// float4 tangent :TANGENT;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				float3 worldViewDir : TEXCOORD3;
				float3 worldRefl : TEXCOORD4;
				SHADOW_COORDS(5)				

			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
				o.worldRefl = reflect(-o.worldViewDir, o.worldNormal);

				TRANSFER_SHADOW(o);

				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = normalize(i.worldViewDir);

				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldLightDir, worldNormal));
			
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(halfDir, worldNormal)), _Gloss);

				fixed3 reflection = texCUBE(_Cubemap, i.worldRefl).rgb;
                fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow(1 - dot(worldNormal, worldViewDir), 5);

				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

				fixed3 color = ambient + lerp(diffuse, reflection, saturate(fresnel)) * atten + specular * atten;

				return fixed4(color, 1);
			}
			ENDCG
		}

		// Pass{
		// 	Tags {"LightModel" = "ForwardAdd"}
		// 	Blend One One

		// 	CGPROGRAM
			
		// 	ENDCG
		// }
	}

	Fallback "Specular"
}