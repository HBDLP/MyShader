Shader "MyShader/Chapter8/AlphaTest-Chapter7"
{
	Properties{
		_Color ("Color", Color) = (1, 1, 1, 1)
		_MainTex ("Main Tex", 2D) = "white"{}
		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
	}

	SubShader{
		Tags {"Queue" = "AlphaTeset" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		pass{
			Tags {}
		}
	}
}