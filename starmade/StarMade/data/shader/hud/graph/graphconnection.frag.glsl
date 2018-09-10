#version 120

uniform vec4 boxA;
uniform vec4 boxB;
uniform sampler2D barTex;
varying vec2 vert;
varying vec2 clipPlaneX;
varying vec2 clipPlaneY;

void main()
{

	
	
	vec2 val = vert;
	if(
		(val.x > boxA.x && val.x < boxA.y && val.y > boxA.z && val.y < boxA.w) ||
		(val.x > boxB.x && val.x < boxB.y && val.y > boxB.z && val.y < boxB.w) ||
		val.x < clipPlaneX.x || val.x > clipPlaneX.y || 
		val.y < clipPlaneY.x || val.y > clipPlaneY.y )
	{
		//this discards a pixel if it overlaps with either box the connection is inbetween 
		discard;
	} 
	vec4 back = texture2D(barTex, gl_TexCoord[0].st);

	gl_FragColor = back * gl_Color;
}