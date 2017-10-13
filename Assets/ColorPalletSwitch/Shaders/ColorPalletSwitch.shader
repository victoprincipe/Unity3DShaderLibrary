Shader "ShaderLibraryImageEffects/ColorPalletSwitch"
{
	Properties
	{
		[HideInInspector]_MainTex ("Texture", 2D) = "white" {}
		_Color1 ("Color 1", Color) = (1.0, 1.0, 1.0, 1.0)
		_Color2 ("Color 2", Color) = (1.0, 1.0, 1.0, 1.0)
		_Color3 ("Color 3", Color) = (1.0, 1.0, 1.0, 1.0)
		_Color4 ("Color 4", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float4 _Color1;
			float4 _Color2;
			float4 _Color3;
			float4 _Color4;
			float _Range;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed grayColor = (col.r + col.g + col.b) / 3;
				fixed4 grayColorResult = (grayColor, grayColor, grayColor);
				
				fixed4 result;

				if (grayColorResult.r <= 1.0)
					result = _Color4;
				if (grayColorResult.r <= 0.75)
					result = _Color3;
				if (grayColorResult.r <= 0.50)
					result = _Color2;
				if (grayColorResult.r <= 0.25)
					result = _Color1;

				return result;
			}
			ENDCG
		}
	}
}
