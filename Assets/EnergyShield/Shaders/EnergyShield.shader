Shader "ShaderLibrary/EnergyShield" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Rim ("Rim", Range(0, 1)) = 0.5 
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		
		CGPROGRAM
		#pragma surface surf Lambert alpha

		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
			float3 worldNormal;
		};

		fixed4 _Color;
		fixed _Rim;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			float3 vDir = normalize(IN.viewDir);
			float3 wNormal = normalize(IN.worldNormal);
			float val = 1 - abs(dot(vDir, wNormal));
			float rim = val * _Rim;

			o.Albedo = _Color;
			o.Alpha = c.a * rim;			
		}
		ENDCG
	}
	FallBack "Diffuse"
}
