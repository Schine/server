#version 120
varying float distance;
varying float time;
varying vec4 color;
uniform float zoomFac;
void main()
{
	vec4 pos = gl_ModelViewMatrix * vec4(gl_Vertex.xyz, 1.0);
	vec3 dir = normalize(-pos.xyz);
	pos.xyz += dir * (zoomFac * 0.001);
	gl_Position = gl_ProjectionMatrix * pos; 
	gl_TexCoord[0].x = mod(floor(gl_MultiTexCoord0.w * 2.0), 2.0);
	gl_TexCoord[0].y = gl_MultiTexCoord0.y; //percent
	gl_TexCoord[0].z = gl_MultiTexCoord0.y; //percent
	color = gl_Color;
	time = 0.0; //some drivers expect write
}