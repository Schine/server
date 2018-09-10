#version 120

uniform float time;
uniform sampler2D lavaTex;


varying vec4 col;

void main()
{
	float mx = 0.25;
	float my = 0.25;
	
	mx += sin(time + cos(gl_TexCoord[0].y*1.0)*0.1)/166.0;
	my += cos(time + sin(gl_TexCoord[0].x*1.0)*0.1)/166.0;
	
	float dx = mx;
	float dy = my;
	
	vec4 tex = texture2D(lavaTex,gl_TexCoord[0].xy*7.0);
	vec4 distort = texture2D(lavaTex,(gl_TexCoord[0].xy * 0.2) + vec2(dx,dy));
	
	dx += time/60.0;
	dy -= time/60.0;
	
	vec4 distort2 = texture2D(lavaTex,(gl_TexCoord[0].xy * 0.8) + vec2(dx,dy));
	
	float omx = sin(time/80.0 + (distort.r + distort2.g)/5.0)/2.0;
	float omy = cos(time/80.0 + (distort.g + distort2.r)/5.0)/2.0;
	
	vec4 tex2 = texture2D(lavaTex,(gl_TexCoord[0].xy * 2.0) + vec2(mx+omx,my+omy));
	
	gl_FragColor = mix(tex2 * col,tex,0.1);
	
	gl_FragColor.r = mix(gl_FragColor.r,1.0,1.0 - tex.a);
	gl_FragColor.g = mix(gl_FragColor.g,1.0,1.0 - tex.a);
	gl_FragColor.b = mix(gl_FragColor.b,1.0,1.0 - tex.a);
	//gl_FragColor.a = mix(gl_FragColor.a,1.0,1.0 - tex.a);
	
	gl_FragColor.rgb -= mx*0.6 *(distort.r+distort.g)*0.5;
	gl_FragColor.rgb -= my*0.6 *(distort.r+distort.b)*0.5;
	//gl_FragColor.rgb += pow(gl_FragColor.r, 1.1);
	gl_FragColor.a = tex.a;
	
	gl_FragColor *= col;
	
	//gl_FragColor.r += 1.0 - tex.a*1.2;
	//gl_FragColor.g += 1.0 - tex.a*1.2;
	//gl_FragColor.b += 1.0 - tex.a*1.2;
}