#version 120

uniform sampler2D barTex;
uniform float filled;
uniform float glowIntensity;
uniform vec4 barColor;
uniform float maxTexCoord;
uniform float minTexCoord;


void main()
{

	vec2 tc = vec2(gl_TexCoord[0].xy);
	vec2 tcFill = vec2(gl_TexCoord[0].x, gl_TexCoord[0].y+0.75);
	vec2 tcGlow = vec2(gl_TexCoord[0].x, gl_TexCoord[0].y+0.5);
	vec4 back = texture2D(barTex, tc);
	
	vec4 fill = texture2D(barTex, tcFill);

	
	float diff = maxTexCoord - minTexCoord;
	float perc = (filled) * diff;
	
	
	vec4 bar  = vec4(back*barColor);
	
	if(gl_TexCoord[0].x < minTexCoord+perc){
		bar = (fill*barColor);
	}
	
	


	gl_FragColor = bar;
}