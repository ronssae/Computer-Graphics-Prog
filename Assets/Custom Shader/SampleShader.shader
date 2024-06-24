    Shader "Unlit/SampleShader"
{
    Properties
    {
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
            };

            //sampler2D _MainTex;
            //float4 _MainTex_ST;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag (VertexOutput i) : SV_Target
            {
                float2 uv = i.uv0;
                float3 lightDir = normalize(float3(1, 1, 1));
                float SimpleLight = dot(lightDir, i.normal);
                float3 LightColor = float3(0.1, 0.1, 0.1);
                return float4(LightColor * SimpleLight, 0);
            }
            ENDCG
        }
    }
}
