Shader "ShaderLibrary/SnowShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SnowTex ("Snow Tex", 2D) = "white" {}
		_NoiseTex ("Noise Tex", 2D) = "white" {}
		_Direction ("Direction Vector", Vector) = (0, 1, 0, 0)
		_Threshold ("Threshold", Range(0, 1)) = 0.0
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _SnowTex;
		sampler2D _NoiseTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SnowTex;
			float2 uv_NoiseTex;
			float3 worldNormal;
		};

		half _Glossiness;
		half _Metallic;
		float _Threshold;
		fixed3 _Direction;
		fixed4 _Color;

		UNITY_INSTANCING_BUFFER_START(Props)

		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 s = tex2D (_SnowTex, IN.uv_SnowTex);
			fixed4 n = tex2D (_NoiseTex, IN.uv_NoiseTex);

			s.a = 0.3;
			float v = dot(IN.worldNormal, _Direction);
			fixed4 col;

			if(v > _Threshold) {
				col = lerp(c, s, n.r);
			} else {
				col = c;
			}

			o.Albedo = col;

			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = col.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
