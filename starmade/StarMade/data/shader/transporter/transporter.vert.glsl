#version 120


void main()
{
	vec4 vpos = gl_Vertex;
	//vec3 nm = gl_NormalMatrix * gl_Normal;
	
	
	gl_Position = (gl_ModelViewProjectionMatrix * vpos);
	
	
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
}