    Shader"Unlit/SampleShader"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 0)
        _Gloss("Gloss", float) = 1
        _LightFallOffController("LightFallOffController", Range(0.1, 1.0)) = 0.5
        _SpecularFallOffController("SpecularFallOffController", Range(0.1, 1.0)) = 0.1
        //_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            //Mesh Data: Position, Color, Tangent, UV's, Normals
            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };
            
            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD1;
            };

            //sampler2D _MainTex;
            //float4 _MainTex_ST;
            float4 _Color;
            float _Gloss;
            float _LightFallOffController;
            float _SpecularFallOffController;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag (VertexOutput i) : SV_Target
            {
                float2 uv = i.uv0;
                float3 normal = normalize(i.normal);
    
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 LightColor = _LightColor0.rgb;
                float LightFallOff = max(0, dot(lightDir, normal));
                LightFallOff = step(_LightFallOffController, LightFallOff);
                float3 DirectDiffuseLight = LightColor * LightFallOff;
    
                float3 AmbientLight = float3(0.1, 0.1, 0.1);
                float3 CamPos = _WorldSpaceCameraPos;
                float3 FragToCam = CamPos - i.worldPos;
                float3 ViewDir = normalize(FragToCam);
    
                float3 ViewReflect = reflect(-ViewDir, normal);
    
                float3 SpecularFallOff = max(0, dot(ViewReflect, lightDir));
                SpecularFallOff = pow(SpecularFallOff, _Gloss);
                SpecularFallOff = step(_SpecularFallOffController, SpecularFallOff);
    
                float3 DirectSpecular = SpecularFallOff * LightColor;
    
                float3 DiffuseLight = AmbientLight + DirectDiffuseLight;
                float3 FinalSurfaceColor = DiffuseLight * _Color.rgb + DirectSpecular;
    
                return float4(FinalSurfaceColor, 0);
            }
            ENDCG
        }
    }
}
