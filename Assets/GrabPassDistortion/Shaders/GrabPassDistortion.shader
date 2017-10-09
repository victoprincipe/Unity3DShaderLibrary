// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderLibrary/GrabPassDistortion"
{
	Properties{
		_DisplacementMap("Displacement Map", 2D) = "white" {}
		_Intensity("Intensity", Range(0, 1)) = 0
	}
		SubShader{
		GrabPass{ "_GrabTexture" }

		Pass{
		Tags{ "Queue" = "Transparent" }
		Cull Off
		ZWrite Off

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

			struct v2f {
				half4 pos : SV_POSITION;
				half4 uvGrab : TEXCOORD0;
			};

			sampler2D _DisplacementMap;
			sampler2D _GrabTexture;
			half _Intensity;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uvGrab = ComputeGrabScreenPos(o.pos);
				return o;
			}

			half4 frag(v2f i) : COLOR {
				fixed2 dist = tex2D(_DisplacementMap, i.uvGrab).xy;
				i.uvGrab.xy += (sin(dist) - cos(dist)) * _Intensity;
				fixed4 color = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvGrab));
				return color;
			}
		ENDCG
		}
	}
		FallBack "Diffuse"
}