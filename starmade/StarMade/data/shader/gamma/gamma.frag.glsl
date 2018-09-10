#version 120

uniform float gammaInv;
uniform sampler2D fbTex;

void main()
{
	
	vec4 color = texture2D(fbTex, gl_TexCoord[0].st);
	
    color.xyz = pow(color.xyz, vec3(gammaInv));
    
    gl_FragColor = color;
}

