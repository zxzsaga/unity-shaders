// 逐顶点光照
// 漫反射 + 环境光
Shader "Custom/Diffuse Vertex-Level"
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
				float3 color : COLOR;
			};

			
			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos); // 顶点位置

				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; // 环境光
				// 对法线进行 M 矩阵的逆矩阵的转置矩阵操作
				// 使用 (float3x3)unity_WorldToObject, 并调换 mul 中向量和矩阵的位置
				float3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				float3 worldLight = normalize(_WorldSpaceLightPos0.xyz); // _WorldSpaceLightPos0: 光源方向，只能有一个光源且是平行光
				float3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight)); // _LightColor0: 该 Pass 处理的光源颜色和强度信息
				o.color = ambient + diffuse;
				return o;
			}
			
			float4 frag(v2f i) : SV_Target
			{
				return float4(i.color, 1.0);
			}
			ENDCG
		}
	}

	Fallback Off
}
