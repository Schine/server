#version 120

uniform sampler2D mainTexA;
uniform vec4 selectionColor;
uniform float texMult;
void main()
{
	
	vec4 color = texture2D(mainTexA, -(texMult-1.0)*0.5+gl_TexCoord[0].st*texMult); 
	if(color.a <= 0.01){
		discard;
	}
	gl_FragColor = color * selectionColor;
}