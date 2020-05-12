Shader "Custom/Plasma"
{
    Properties
    {
        _Speed("Speed", Range(0, 5)) = 1
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _Scale1("Scale 1", Range(0, 5)) = 1
        _Scale2("Scale 2", Range(0, 5)) = 1
        _Scale3("Scale 3", Range(0, 5)) = 1
        _Scale4("Scale 4", Range(0, 5)) = 1
    }
    
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert
        
        struct Input
        {
            float3 worldPos;
        };
        
        float4 _Tint;
        float _Speed;
        float _Scale1;
        float _Scale2;
        float _Scale3;
        float _Scale4;
        
        void surf(Input IN, inout SurfaceOutput o)
        {
            const float PI = 3.14159265;
            float t = _Time * _Speed;
            
            float vertical = sin(t + IN.worldPos.x * _Scale1);
            float horizontal = cos(t * IN.worldPos.z * _Scale2);
            float diagonal = sin(_Scale3 * (IN.worldPos.x * sin(t * 0.5) + IN.worldPos.z * cos(t * 0.33) + t));
            
            float circular1 = pow(IN.worldPos.x + 0.5f * sin(t * 0.2), 2);
            float circular2 = pow(IN.worldPos.z + 0.5f * cos(t * 0.33), 2);
            float circular = sin(sqrt(_Scale4 * (circular1 + circular2) + 1 + t));
            
            float plasma = sin((vertical + horizontal + diagonal + circular) * PI);
            
            o.Albedo.r = sin(plasma * 0.25 * PI);
            o.Albedo.g = sin(plasma * 0.25 * PI + 0.25 * PI);
            o.Albedo.b = sin(plasma * 0.25 * PI + 0.5 * PI);
            
            o.Albedo *=_Tint;
        }
        ENDCG
    }
    
    Fallback "Diffuse"
}