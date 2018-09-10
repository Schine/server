//----------------------------------------------------------------------------------
// File:   shadow_single_hl_fragment.glsl
// Author: Rouslan Dimitrov
// Email:  sdkfeedback@nvidia.com
// Cascaded shadows maps, highlight layers using different colors
// Copyright (c) NVIDIA Corporation. All rights reserved.
//----------------------------------------------------------------------------------
#version 120
#extension GL_EXT_texture_array : enable

uniform sampler2D tex;
uniform vec4 far_d;

varying vec4 vPos;

uniform vec4 color[4] = vec4[4](	vec4(0.7, 0.7, 1.0, 1.0),
									vec4(0.7, 1.0, 0.7, 1.0),
									vec4(1.0, 0.7, 0.7, 1.0),
									vec4(1.0, 1.0, 1.0, 1.0));
									
uniform sampler2DArray stex;
vec4 shadowCoef()
{
	int index = 3;
	
	if(gl_FragCoord.z < far_d.x)
		index = 0;
	else if(gl_FragCoord.z < far_d.y)
		index = 1;
	else if(gl_FragCoord.z < far_d.z)
		index = 2;
	
	vec4 shadow_coord = gl_TextureMatrix[index]*vPos;
	
	shadow_coord.w = shadow_coord.z;
	shadow_coord.z = float(index);
	
	float shadow_d = texture2DArray(stex, shadow_coord.xyz).x;
	float diff = shadow_d - shadow_coord.w;
	return clamp( diff*250.0 + 1.0, 0.0, 1.0)*color[index];
}

void main()
{
    const float shadow_ambient = 0.9;
	vec4 color_tex = vec4(1.0); //texture2D(tex, gl_TexCoord[0].st);
	vec4 shadow_coef = shadowCoef();
	float fog = clamp(gl_Fog.scale*(gl_Fog.end + vPos.z), 0.0, 1.0);
	gl_FragColor = mix(gl_Fog.color, (shadow_ambient * shadow_coef * gl_Color * color_tex + (1.0 - shadow_ambient) * color_tex), fog);
}