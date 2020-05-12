Shader "Custom/PlasmaVF"
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
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                fixed4 color: COLOR;
            };
            
            struct appdata
            {
                float4 vertex: POSITION;
            };
            
            float4 _Tint;
            float _Speed;
            float _Scale1;
            float _Scale2;
            float _Scale3;
            float _Scale4;
            
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                const float PI = 3.14159265;
                float t = _Time * _Speed;
                
                float vertical = sin(t + o.pos.x * _Scale1);
                float horizontal = cos(t * o.pos.z * _Scale2);
                float diagonal = sin(_Scale3 * (o.pos.x * sin(t * 0.5) + o.pos.z * cos(t * 0.33) + t));
                
                float circular1 = pow(o.pos.x + 0.5f * sin(t * 0.2), 2);
                float circular2 = pow(o.pos.z + 0.5f * cos(t * 0.33), 2);
                float circular = sin(sqrt(_Scale4 * (circular1 + circular2) + 1 + t));
                
                float plasma = sin((vertical + horizontal + diagonal + circular) * PI);
                
                o.color.r = sin(plasma * 0.25 * PI);
                o.color.g = sin(plasma * 0.25 * PI + 0.25 * PI);
                o.color.b = sin(plasma * 0.25 * PI + 0.5 * PI);
                
                return o;
            }
             
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = i.color * _Tint;
                return color;
            }
            
            ENDCG
        }
   }
   
   Fallback "Diffuse"

}