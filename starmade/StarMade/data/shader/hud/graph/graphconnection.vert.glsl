#version 120


varying vec2 vert;
varying vec2 clipPlaneX;
varying vec2 clipPlaneY;
uniform vec4 clipPlane;
uniform vec2 scrollPos;
void main()
{
	
	gl_Position = ftransform();
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_FrontColor = gl_Color;
	vert = vec2(gl_Vertex.xy);
	
	
	clipPlaneX.x = clipPlane.x + scrollPos.x;
	clipPlaneX.y = clipPlane.y + scrollPos.x;
	
	clipPlaneY.x = clipPlane.z + scrollPos.y;
	clipPlaneY.y = clipPlane.w + scrollPos.y;
	
}