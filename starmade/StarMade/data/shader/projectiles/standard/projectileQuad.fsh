#version 120
uniform sampler2D tex;
varying float time;
varying vec3 clr;
void main()
{
	vec4 diffuse = texture2D(tex, gl_TexCoord[0].st);
	
	// use color.r*vColor.a to make black transparent
	//float distance = length(gl_TexCoord[0].st - vec2(0.5)) * 1.0;
	
	diffuse.rgb *= clr;
	
	if(diffuse.a < 0.001){
		discard;
	}
	
	gl_FragColor = diffuse;
}