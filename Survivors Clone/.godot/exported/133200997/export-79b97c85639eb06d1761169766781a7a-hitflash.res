RSRC                    VisualShader            ��������                                            =      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    parameter_name 
   qualifier    default_value_enabled    default_value    script    input_name    hint    min    max    step 	   constant    op_type 	   operator    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections     	   -   local://VisualShaderNodeColorParameter_m8qrh �      /   local://VisualShaderNodeBooleanParameter_4o4k4 u      !   local://VisualShaderNodeIf_nk82v �      $   local://VisualShaderNodeInput_4eptk q	      -   local://VisualShaderNodeFloatParameter_esai8 �	      ,   local://VisualShaderNodeFloatConstant_fece6 �	      '   local://VisualShaderNodeVectorOp_o2wr1 
      '   local://VisualShaderNodeVectorOp_tmscn A
         local://VisualShader_gen1n �
         VisualShaderNodeColorParameter                             tint                ��@?��O?��V?  �?	      !   VisualShaderNodeBooleanParameter             enabled          	         VisualShaderNodeIf                                      �?      )   �h㈵��>                                                               	         VisualShaderNodeInput    
         color 	         VisualShaderNodeFloatParameter             ALPHA 	         VisualShaderNodeFloatConstant    	         VisualShaderNodeVectorOp    	         VisualShaderNodeVectorOp                                                                                  	         VisualShader          �  shader_type canvas_item;
render_mode blend_mix;

uniform bool enabled = false;
uniform float ALPHA;
uniform vec4 tint : source_color = vec4(0.752941, 0.811765, 0.839216, 1.000000);



void fragment() {
// Input:5
	vec4 n_out5p0 = COLOR;


// BooleanParameter:3
	bool n_out3p0 = enabled;


// FloatParameter:6
	float n_out6p0 = ALPHA;


// ColorParameter:2
	vec4 n_out2p0 = tint;
	float n_out2p4 = n_out2p0.a;


// VectorOp:11
	vec4 n_out11p0 = vec4(n_out6p0) * vec4(n_out2p4);


// FloatConstant:9
	float n_out9p0 = 0.000000;


	vec3 n_out4p0;
// If:4
	float n_in4p1 = 1.00000;
	float n_in4p2 = 0.00001;
	if(abs((n_out3p0 ? 1.0 : 0.0) - n_in4p1) < n_in4p2)
	{
		n_out4p0 = vec3(n_out11p0.xyz);
	}
	else if((n_out3p0 ? 1.0 : 0.0) < n_in4p1)
	{
		n_out4p0 = vec3(n_out9p0);
	}
	else
	{
		n_out4p0 = vec3(n_out9p0);
	}


// VectorOp:10
	vec3 n_out10p0 = vec3(n_out5p0.xyz) + n_out4p0;


// Output:0
	COLOR.rgb = n_out10p0;


}
                       
     �D  D                
     �  HD               
     \C  �C             !   
     D  *D"            #   
     D  �C$            %   
     ��  D&            '   
     �C  pD(            )   
     WD   D*            +   
     \C  /D,       $                 	             	                                               
                  
                      
       	      RSRC