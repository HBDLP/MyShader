// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShader/Chapter5/SimpleShader-Chapter5"
{
	Properties{
		_Color ("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	SubShader
	{
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;

			struct a2v {
				//POSITON, 用模型空间的顶点坐标填充vertex
				float4 vertex : POSITION;
				//NORMAL, 用模型空间的法线坐标填充normal
				float3 normal : NORMAL;
				//TEXCOORD0, 用模型的第一套纹理坐标填充texcoord
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				//SV_POSITION, pos里包含了顶点在裁剪空间中的位置信息
				float4 pos : SV_POSITION;
				//COLOR0,用于存储颜色信息
				fixed3 color : COLOR0;
			};

			//语义POSITION，表示将模型的顶点坐标填充到输入参数v中
			//语义SV_POSITION，表示顶点着色器输出的是裁剪坐标空间中的顶点坐标
			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);

				return o;
			}

			//语义SV_TARGET，告诉渲染器，将输出颜色存储到渲染目标中(颜色缓冲)
			fixed4 frag(v2f i) :SV_TARGET{
				fixed3 c = i.color;
				c *= _Color.rgb;
				return fixed4(c, 1.0);
			}
			ENDCG
		}
	}

	Fallback "Diffuse"
}