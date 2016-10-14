// 逐像素光照
// 漫反射 + 环境光
Shader "Custom/Diffuse Pixel-Level"
{
	Properties
	{
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Pass
		{
			Tags { "LightMode" = "ForwardBase" } // 为了使用 _LightColor0

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc" // 为了使用 _LightColor0

			float4 _Diffuse;

			struct a2v
			{
				float4 pos : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION; 
				float3 worldNormal : TEXCOORD0;
			};

			
			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				float3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(i.worldNormal, worldLight));
				fixed3 color = ambient + diffuse;
				return fixed4(color, 1.0);
			}
			ENDCG
		}
	}
}
