#version 120

uniform sampler2D tex;
uniform vec4 tint;
uniform float wrapX;
uniform float wrapY;
void main()
{
	vec2 tcord;
	tcord.s = mod(gl_TexCoord[0].s, wrapX);
	tcord.t = mod(gl_TexCoord[0].t, wrapY);
	gl_FragColor = texture2D(tex, tcord.st) * tint; 
}