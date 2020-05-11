Shader "Custom/Wave"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Amplitude("Amplitude", Range(0, 5)) = 1
        _Frequency("Frequency", Range(0, 5)) = 1
        _Speed("Speed", Range(0, 10)) = 1 
        _WaveColorStrength("Wave Color Strength", Range(0, 5)) = 2
    }
    
    Subshader
    {
        CGPROGRAM
            #pragma surface surf Lambert vertex:vert
            
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex: POSITION;
                float3 normal : NORMAL;
                // since we are using custom vertex shader we'll need to make the appdata compatible with the internal vertex shader
                // so we'll have to use these names
                float4 texcoord : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            
            struct Input
            {
                float2 uv_MainTex;
                float3 color;
            };
            
            sampler2D _MainTex;
            float _Amplitude;
            float _Frequency;
            float _Speed;
            float _WaveColorStrength;
            
            
            void vert(inout appdata v, out Input o)
            {
                // Initializes o to zero.
                UNITY_INITIALIZE_OUTPUT(Input, o);
                float t = _Time * _Speed;
                float waveHeightX = sin(t + v.vertex.x * _Frequency) * _Amplitude;
                float waveHeightZ = sin(t + v.vertex.z * _Frequency) * _Amplitude;
                // Alter the height of the mesh with waveHeight.
                v.vertex.y = v.vertex.y + waveHeightX + waveHeightZ; 
                // Recalculate normals so the shadows are properly casted
                v.normal = normalize(float3(v.normal.x + waveHeightX, v.normal.y, v.normal.z + waveHeightZ));
                o.color = waveHeightX + waveHeightZ +_WaveColorStrength;
            }
            
            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = color.rgb * IN.color; 
            }
            
        ENDCG
    }
    
    Fallback "Diffuse"

}