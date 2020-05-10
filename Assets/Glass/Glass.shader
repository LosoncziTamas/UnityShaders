Shader "Custom/Glass"
{
     Properties
    {
        _MainTexture ("Main Texture", 2D) = "white" {}
        _BumpTexture ("Bump Texture", 2D) = "white" {}
        _ScaleUV ("Scale UV", Range(1, 100)) = 1
    }
    
    Subshader
    {
        Tags {"Queue" = "Transparent"}
    
        GrabPass {}
        
        Pass
        {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                
                #include "UnityCG.cginc"
                
                struct appdata
                {
                    float4 uv : TEXCOORD0;
                    float4 vertex : POSITION;
                };
    
                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 uvgrab: TEXCOORD1;
                    float2 uvbump: TEXCOORD2;
                    float4 vertex : SV_POSITION;
                };
                
                // Texture of the glass 
                sampler2D _MainTexture;
                // The values for this are provided in the inspector with the Tiling/Offset.
                float4 _MainTexture_ST;
                
                // Bump map of the glass
                sampler2D _BumpTexture;
                float4 _BumpTexture_ST;
                
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
                
                float _ScaleUV;
                
                v2f vert(appdata v)
                {
                    v2f o;
                    // Transforms a point from object space to the camera’s clip space in homogeneous coordinates. 
                    // This is the equivalent of mul(UNITY_MATRIX_MVP, float4(pos, 1.0))
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    // Calculating the proper UV values of the grabbed texture for the geometry.
                    o.uvgrab.xy = (float2(o.vertex.x, -o.vertex.y) + o.vertex.w) * 0.5f;
                    o.uvgrab.zw = float2(o.vertex.z, o.vertex.w);
                    // Transforms 2D UV by scale/bias property equivalent to v.uv * _MainTexture_ST.xy + _MainTexture_ST.zw;
                    o.uv = TRANSFORM_TEX(v.uv, _MainTexture);
                    o.uvbump = TRANSFORM_TEX(v.uv, _BumpTexture);
                    return o;
                }
                
                fixed4 frag(v2f i) : SV_Target
                {
                    // Retriving the normals from the compressed format.
                    half2 bump = UnpackNormal(tex2D(_BumpTexture, i.uvbump)).rg;
                    // Use the bump values to alter the grab texture UV.
                    // The texel size is provided by unity.
                    float2 offset = bump * _ScaleUV * _GrabTexture_TexelSize.xy;
                    i.uvgrab.xy += offset;
                    
                    // Returns a Texture coordinate suitable for projected Texture reads. On most platforms this returns the given value directly.
                    float4 projectedTexCoord = UNITY_PROJ_COORD(i.uvgrab);
                    // Performs a projected texture lookup: coordinates are divided by the last component of the coordinate vector and then used in the lookup.
                    fixed4 color = tex2Dproj(_GrabTexture, projectedTexCoord);
                    fixed4 tint = tex2D(_MainTexture, i.uv);
                    color *= tint;
                    return color;
                }
            ENDCG
        }
    }
}
