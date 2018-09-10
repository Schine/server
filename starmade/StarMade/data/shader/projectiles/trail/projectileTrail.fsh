#version 120

uniform sampler2D tex;
varying float time;
uniform vec4 trailColor;
void main()
{
	vec4 color = texture2D(tex,   vec2(gl_TexCoord[0].x, gl_TexCoord[0].z+time*0.5));
	
	float tt = abs(gl_TexCoord[0].s - 0.5);
	
	float alpha = pow(max(0.0,(0.5-tt)), 1.2) * 5.0;
	
		
	float p = min(1.0, pow(gl_TexCoord[0].t , 0.8));
	float p2 = min(1.0, pow(1.0-gl_TexCoord[0].t, 1.4) * 10.0);
	
	alpha *= p*p2;//max(0.0,(alpha - (p)));
	//alpha *= p2;
	
	if(time > 5.0){
		float fade = 1.0 - ((time - 5.0) * 0.1);
		alpha *= fade;
	}
	
	if(alpha < 0.1){
		discard;
	}
	gl_FragColor =  vec4((color*2.0).xyz, max(0.0, alpha-0.1)) * trailColor;//vec4(1,1,1,0.5f);
}