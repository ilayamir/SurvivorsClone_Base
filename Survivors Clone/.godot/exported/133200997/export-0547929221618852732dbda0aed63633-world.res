RSRC                    VisualShader            ��������                                            \      resource_local_to_scene    resource_name    noise_type    seed 
   frequency    offset    fractal_type    fractal_octaves    fractal_lacunarity    fractal_gain    fractal_weighted_strength    fractal_ping_pong_strength    cellular_distance_function    cellular_jitter    cellular_return_type    domain_warp_enabled    domain_warp_type    domain_warp_amplitude    domain_warp_frequency    domain_warp_fractal_type    domain_warp_fractal_octaves    domain_warp_fractal_lacunarity    domain_warp_fractal_gain    script    width    height    invert    in_3d_space    generate_mipmaps 	   seamless    seamless_blend_skirt    as_normal_map    bump_strength 
   normalize    color_ramp    noise    output_port_for_preview    default_input_values    expanded_output_ports    source    texture    texture_type    op_type 	   function 	   operator    parameter_name 
   qualifier    hint    min    max    step    default_value_enabled    default_value    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections     	      local://FastNoiseLite_irtjk $
         local://NoiseTexture2D_2ubbx r
      &   local://VisualShaderNodeTexture_o4s55 �
      )   local://VisualShaderNodeVectorFunc_quqan       '   local://VisualShaderNodeVectorOp_u5rw7 h      &   local://VisualShaderNodeFloatOp_vo23g �      -   local://VisualShaderNodeFloatParameter_kds7t       -   local://VisualShaderNodeColorParameter_n32fl O         local://VisualShader_17rrx �         FastNoiseLite                   
         ��1@
        �?         NoiseTexture2D             !          #                      VisualShaderNodeTexture    &                (                     VisualShaderNodeVectorFunc    %                
           *          +                  VisualShaderNodeVectorOp    %                
                 
           *          ,                  VisualShaderNodeFloatOp             VisualShaderNodeFloatParameter    -         FloatParameter          VisualShaderNodeColorParameter    -         ColorParameter 3         4      ��0=���=+��=  �?         VisualShader    5        shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D tex_frg_3;
uniform float FloatParameter;



void fragment() {
// Texture2D:3
	vec4 n_out3p0 = texture(tex_frg_3, UV);


// VectorFunc:4
	vec2 n_out4p0 = round(vec2(n_out3p0.xy));


// VectorOp:5
	vec2 n_in5p0 = vec2(0.00000, 0.00000);
	vec2 n_out5p0 = n_in5p0 * n_out4p0;


// FloatParameter:7
	float n_out7p0 = FloatParameter;


// FloatOp:6
	float n_out6p0 = n_out4p0.x + n_out7p0;


// Output:0
	COLOR.rgb = vec3(n_out5p0, 0.0);
	COLOR.a = n_out6p0;


}
 7         ;          >   
     /D  pC?            @   
     �  �CA            B   
     4C  �CC            D   
   f��Co CE            F   
     �C  �CG            H   
      �  DI            J   
     \�   CK                                                                                                   RSRC