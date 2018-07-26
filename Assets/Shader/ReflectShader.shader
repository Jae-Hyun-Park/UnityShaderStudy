Shader "Unlit/ReflectShader"
{
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f
			{
				half3 worldReflect : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(float4 vertex : POSITION, float3 normal : NORMAL)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(vertex);

				float3 worldPos = mul(unity_ObjectToWorld, vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				float3 worldNormal = UnityObjectToWorldNormal(normal);

				o.worldReflect = reflect(-worldViewDir, worldNormal);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldReflect);
				half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);
				// sample the texture
				fixed4 col = 0;
				col.rgb = skyColor;
				return col;
			}
			ENDCG
		}
	}
}
