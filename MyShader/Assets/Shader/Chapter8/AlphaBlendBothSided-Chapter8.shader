Shader "MyShader/Chapter8/AlphaBlendBothSided-Chapter8"{
	Properties{
		_Color("Main Tint", Color) = (1, 1, 1, 1)
		_MainTex("Main Tex", 2D) = "white"{}
		_AlphaScale("Alpha Scale", Float) = 1
	}

	SubShader{
		Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		Pass{
			Tags {"LightMode" = "ForwardBase"}
			ZWrite Off
			Cull Front
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
            #include "Lighting.cginc"
            #pragma vertex vert
            #pragma fragment frag
			
            fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _AlphaScale;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET{
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed3 albedo = texColor.rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.xyz * albedo * saturate(dot(worldNormal, worldLightDir));

                return fixed4(ambient + diffuse, texColor.a * _AlphaScale);

            }
			ENDCG
		}

		Pass{
			Tags {"LightMode" = "ForwardBase"}
			ZWrite Off
			Cull Back
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
            #include "Lighting.cginc"
            #pragma vertex vert
            #pragma fragment frag
			
            fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _AlphaScale;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET{
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed3 albedo = texColor.rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse = _LightColor0.xyz * albedo * saturate(dot(worldNormal, worldLightDir));

                return fixed4(ambient + diffuse, texColor.a * _AlphaScale);

            }
			ENDCG
		}
	}

	Fallback "Transparent/VertexLit"
}