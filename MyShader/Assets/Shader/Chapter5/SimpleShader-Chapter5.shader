// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Chapter5/SimpleShader-Chapter5"
{
	SubShader
	{
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//语义POSITION，表示将模型的顶点坐标填充到输入参数v中
			//语义SV_POSITION，表示顶点着色器输出的是裁剪坐标空间中的顶点坐标
			float4 vert(float4 v : POSITION) : SV_POSITION{
				return UnityObjectToClipPos(v);
			}

			//语义SV_TARGET，告诉渲染器，将输出颜色存储到渲染目标中(颜色缓冲)
			fixed4 frag() :SV_TARGET{
				return fixed4(1.0, 0.0, 0.0, 1.0);
			}
			ENDCG
		}
	}
}