#version 120

#IFDEF shadow
#extension GL_EXT_gpu_shader4: enable
#ELSEIF texarray
#extension GL_EXT_gpu_shader4: enable
#ELSEIF normaltexarray
#extension GL_EXT_gpu_shader4: enable
#ENDIF


void main()
{
	gl_FragColor = gl_FragCoord.zzzw;
}