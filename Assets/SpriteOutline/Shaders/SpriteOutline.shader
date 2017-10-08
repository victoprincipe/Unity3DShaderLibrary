Shader "Unlit/SpriteOutline"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineColor ("Outline Color", Color) = (1.0, 1.0, 1.0, 1.0)

	}
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		Cull Off
		Blend One OneMinusSrcAlpha

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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _OutlineColor;
			float4 _MainTex_TexelSize;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *= col.a;
				float4 outlineColor = _OutlineColor;
				outlineColor.a *= col.a;
				outlineColor.rgb *= col.a;

				float up_pixel = tex2D(_MainTex, i.uv + float2(0, _MainTex_TexelSize.y)).a;
				float down_pixel = tex2D(_MainTex, i.uv - float2(0, _MainTex_TexelSize.y)).a;
				float right_pixel = tex2D(_MainTex, i.uv + float2(_MainTex_TexelSize.x, 0)).a;
				float left_pixel = tex2D(_MainTex, i.uv - float2(_MainTex_TexelSize.x, 0)).a;

				return lerp(outlineColor, col, ceil(up_pixel * down_pixel * right_pixel * left_pixel));
			}
			ENDCG
		}
	}
}
