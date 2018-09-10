#version 120
varying vec4 viewPos;
varying mat4 model;
uniform vec4 viewport;
void main(void)
{   
	model = gl_ProjectionMatrix * gl_ModelViewMatrix;
	gl_Position = ftransform();
	//viewPos.xy = (vec2(1024,1024)*gl_Position.xz/gl_Position.w) * 0.5;
	viewPos.xy = viewport.xy + viewport.zw * (1 + gl_Position.xy / gl_Position.w)/2;
	gl_TexCoord[0] = gl_MultiTexCoord0;
  	
}