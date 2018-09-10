#version 120
#extension GL_EXT_gpu_shader4: enable

uniform vec4 col; 

varying vec2 mainTexCoords;

varying float layer;
varying float extraAlphaVert;

void main()
{
	gl_FragColor = col;//vec4(1.0,1.0,1.0,1.0);
}