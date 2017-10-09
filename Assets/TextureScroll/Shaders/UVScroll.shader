Shader "ShaderLibrary/UVScroll"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ScrollX ("Scroll X", Float) = 0
		_ScrollY ("Scroll Y", Float) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			float _ScrollX;
			float _ScrollY;

			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed2 scroll = i.uv;
				scroll += fixed2(_ScrollX, _ScrollY) * _Time;
				fixed4 col = tex2D(_MainTex, scroll);
				return col;
			}
			ENDCG
		}
	}
}
