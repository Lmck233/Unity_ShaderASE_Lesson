// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "03.硬边溶解"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Dlssolve("Dlssolve", 2D) = "white" {}
		_Float0("Float 0", Range( 0 , 1.05)) = 0.05113791
		_guangbiandaxiao("guangbiandaxiao", Float) = 0.02
		[HDR]_guangbiancolor("guangbiancolor", Color) = (1,0.2207547,0.6114066,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _Float0;
			uniform sampler2D _Dlssolve;
			uniform float4 _Dlssolve_ST;
			uniform float _guangbiandaxiao;
			uniform float4 _guangbiancolor;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
				float2 uv_Dlssolve = i.ase_texcoord1.xy * _Dlssolve_ST.xy + _Dlssolve_ST.zw;
				float4 tex2DNode2 = tex2D( _Dlssolve, uv_Dlssolve );
				float temp_output_5_0 = step( _Float0 , ( tex2DNode2.r + _guangbiandaxiao ) );
				float temp_output_9_0 = ( temp_output_5_0 - step( _Float0 , tex2DNode2.r ) );
				float4 lerpResult13 = lerp( tex2DNode1 , ( tex2DNode1.a * temp_output_9_0 * _guangbiancolor ) , temp_output_9_0);
				float4 appendResult12 = (float4(lerpResult13.rgb , ( tex2DNode1.a * temp_output_5_0 )));
				
				
				finalColor = appendResult12;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
6.4;11.2;1523.2;783.8;710.8297;453.2808;1.516207;True;False
Node;AmplifyShaderEditor.SamplerNode;2;-939.5998,308.7999;Inherit;True;Property;_Dlssolve;Dlssolve;1;0;Create;True;0;0;0;False;0;False;-1;27ecea98717a9184797af05969f0181e;27ecea98717a9184797af05969f0181e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-945.3477,716.5634;Inherit;False;Property;_guangbiandaxiao;guangbiandaxiao;3;0;Create;True;0;0;0;False;0;False;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-665.8482,686.6638;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-913.471,166.1634;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.05113791;0.1401813;0;1.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;3;-415.7634,277.776;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;5;-410.5627,561.1761;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-486,-155.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;b1d7988a5186b0b43861593a58249dee;b1d7988a5186b0b43861593a58249dee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;21.92293,379.0611;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;62.52121,818.8998;Inherit;False;Property;_guangbiancolor;guangbiancolor;4;1;[HDR];Create;True;0;0;0;False;0;False;1,0.2207547,0.6114066,0;0.3059428,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;399.5515,383.8194;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;13;445.0316,-92.61777;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;107.3358,10.59808;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;744.051,-88.93452;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1021.208,-74.93274;Float;False;True;-1;2;ASEMaterialInspector;100;1;03.硬边溶解;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;8;0;2;1
WireConnection;8;1;7;0
WireConnection;3;0;4;0
WireConnection;3;1;2;1
WireConnection;5;0;4;0
WireConnection;5;1;8;0
WireConnection;9;0;5;0
WireConnection;9;1;3;0
WireConnection;10;0;1;4
WireConnection;10;1;9;0
WireConnection;10;2;11;0
WireConnection;13;0;1;0
WireConnection;13;1;10;0
WireConnection;13;2;9;0
WireConnection;14;0;1;4
WireConnection;14;1;5;0
WireConnection;12;0;13;0
WireConnection;12;3;14;0
WireConnection;0;0;12;0
ASEEND*/
//CHKSM=4D1EE0362ADC7526A77296D202DC08A358B5FE86