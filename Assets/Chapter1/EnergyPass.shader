Shader "Unlit/EnergyPass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_TexelNumber("TexelNumber",Int) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			int _TexelNumber;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                //fixed4 col = tex2D(_MainTex, i.uv);
				float _Temprature = 0.0f;
				float _TexelSize = 1.0f / _TexelNumber;
				if (i.uv.x < _TexelSize && i.uv.y< _TexelSize)//左边界条件
					_Temprature = 0.7f;
				else if (i.uv.x >= 1 - _TexelSize && i.uv.y >= 1 - _TexelSize)//右边界条件
					_Temprature = 0.3f;
				else if (i.uv.x >= 1 - _TexelSize && i.uv.y < _TexelSize)//右边界条件
					_Temprature = 0.3f;
				else if (i.uv.x < _TexelSize && i.uv.y >= 1 - _TexelSize)//右边界条件
					_Temprature = 0.3f;
				else {
					//按道理来说应该是周围所有
					float2	leftuv = float2(i.uv.x - _TexelSize, i.uv.y);
					float	leftT = tex2D(_MainTex, leftuv).g;

					float2	bottomuv = float2(i.uv.x, i.uv.y - _TexelSize);
					float	bottomT = tex2D(_MainTex, bottomuv).g;

					float2	rightuv = float2(i.uv.x + _TexelSize, i.uv.y);
					float	rightT = tex2D(_MainTex, rightuv).g;

					float2	upuv = float2(i.uv.x, i.uv.y + _TexelSize);
					float	upT = tex2D(_MainTex, upuv).g;

					_Temprature = (leftT + rightT  + bottomT + upT) / 4.0f;
				}
				return(float4(1.0f, _Temprature, 0.0f, 1.0f));
                //return col;
            }
            ENDCG
        }
    }
}
