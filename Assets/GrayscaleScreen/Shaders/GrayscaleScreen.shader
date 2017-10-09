Shader "ShaderLibraryImageEffects/GrayscaleScreen"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			fixed4 frag (v2f_img i) : SV_Target
			{
				float4 col = tex2D(_MainTex, i.uv);
				float grayColor = (col.r + col.g + col.b) / 3.0;
				half4 grayScale = (grayColor, grayColor, grayColor);
				return grayScale;
			}
			ENDCG
		}
	}
}
