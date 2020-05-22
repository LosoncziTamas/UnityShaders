Shader "Custom/RayMarching"
{

    SubShader
    {
        Tags { "Queue"="Transparent" }
        
        // Use default transparency 
        Blend SrcAlpha OneMinusSrcAlpha

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
                // Pass world position 
                float3 wPos : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // Transform from object to world coordinates
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }
            
            #define STEP_COUNT 64
            #define STEP_SIZE 0.01
            
            int InsideSphere(float3 center, float radius, float3 vec)
            {
                return distance(center, vec) < radius;
            }
            
            int RayMarch(float3 worldPos, float3 direction)
            {
                for (int i = 0; i < STEP_COUNT; ++i)
                {
                    if (InsideSphere(float3(0, 0, 0), 0.5, worldPos))
                    {
                        return i;
                    }
                    worldPos += direction * STEP_SIZE;
                }
                
                return 0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Direction of the ray
                float3 direction = normalize(i.wPos - _WorldSpaceCameraPos);
                int result = RayMarch(i.wPos, direction);
                
                fixed4 col = result > 0 ? fixed4(1, 0, 0, 1) : fixed4(1, 1, 1, 0);
                return col;
            }
            ENDCG
        }
    }
}
