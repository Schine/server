#version 120

uniform float time;

varying vec4 col;


void main()
{
	vec4 vpos = gl_Vertex;
	//vec3 nm = gl_NormalMatrix * gl_Normal;
	
	float cgt = time * 210.0;
	float tsin = sin((cgt + vpos.x*150.0)/100.0)*1.0;
	float tcos = cos((cgt + vpos.y*150.0)/100.0)*1.0;
	
	gl_Position = (gl_ModelViewProjectionMatrix * vpos);
	
	col = vec4(1.0,1.0,1.0,1.0);
	
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
}