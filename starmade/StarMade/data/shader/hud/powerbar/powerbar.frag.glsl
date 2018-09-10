#version 120

uniform sampler2D barTex;
uniform float[8] filled;
uniform float glowIntensity;
uniform vec4 barColor;
uniform float maxTexCoord;
uniform float minTexCoord;
uniform int sections;

void main()
{

	vec2 tc = vec2(gl_TexCoord[0].xy);
	
	
	vec2 tcFill = vec2(gl_TexCoord[0].x+0.25, gl_TexCoord[0].y);
	
	
	vec2 tcGlow = vec2(gl_TexCoord[0].x+0.5, gl_TexCoord[0].y);
	
	vec4 back = texture2D(barTex, tc);
	
	vec4 fill = texture2D(barTex, tcFill);

	vec4 glow = texture2D(barTex, tcGlow);
	
	float diff = maxTexCoord - minTexCoord;
	
	
	
	vec4 bar = glow*glowIntensity*barColor*2.0;
	
	bar = vec4(back*barColor);
	
	float secCoOne = (1.0 / float(sections));
	
	for(int i = 0; i < sections; i++){
		float perc = (1.0-filled[i]) * diff;
		
		

		float secCoMin = float(i) * secCoOne;
		float secCoMax = (float(i)+1.0) * secCoOne;
		
		float percNorm = secCoMin + perc * secCoOne;
		if(gl_TexCoord[0].y >= minTexCoord+secCoMin && 
			gl_TexCoord[0].y <= minTexCoord+secCoMax
			){
			if(gl_TexCoord[0].y > 0.03 && gl_TexCoord[0].y <= minTexCoord+(secCoMin+0.004)){
				bar = fill * vec4(1.0,1.0,1.0,1.0);
			}else if(gl_TexCoord[0].y > minTexCoord+percNorm){
				bar = (fill*barColor);
			}
		}
		
	}

	gl_FragColor = bar;
}