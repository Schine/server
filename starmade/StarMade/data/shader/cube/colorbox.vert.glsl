#version 120

varying vec4 distColor;
	
void main()
{
	vec4 pos = vec4(gl_Vertex.xyz, 1.0);
  	gl_Position = gl_ModelViewProjectionMatrix * pos;		
	distColor = vec4(1.0-gl_Vertex.w, gl_Vertex.w, 0.0, 0.3);
}