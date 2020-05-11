Shader "Custom/Water"
{

    Properties
    {
        _WaterTex("Water Texture", 2D) = "white" {}
        _FoamTex("Foam Texture", 2D) = "white" {}
        _ScrollX("Scroll X", Range(0, 10)) = 1
        _ScrollY("Scroll Y", Range(0, 10)) = 1
        _Speed("Speed", Range(0, 10)) = 1
    }
    
    Subshader
    {
        CGPROGRAM
        #pragma surface surf Lambert
                
        sampler2D _WaterTex;
        sampler2D _FoamTex;
        float _ScrollX;
        float _ScrollY;
        float _Speed;
        
        struct Input
        {
            float2 uv_WaterTex;
            float2 uv_FoamTex;
        };
        
        void surf(Input IN, inout SurfaceOutput o)
        {
            float2 uvOffset = float2(_ScrollX, _ScrollY) * _Time * _Speed;
            IN.uv_WaterTex += uvOffset;
            // Set half the rate for the foam.
            IN.uv_FoamTex += uvOffset * 0.5f;
            float3 waterColor = tex2D(_WaterTex, IN.uv_WaterTex).rgb;
            float3 foamColor = tex2D(_FoamTex, IN.uv_FoamTex).rgb;
            // Average the two colors
            o.Albedo = (waterColor + foamColor) * 0.5f;
        }
        
        ENDCG
    }
    
    Fallback "Diffuse"

}