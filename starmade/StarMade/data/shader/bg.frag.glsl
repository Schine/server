#version 120

uniform sampler2D tex;
uniform float alpha;

void main() {
	vec4 color = texture2D(tex, gl_TexCoord[0].st);
	color *= alpha;
	gl_FragColor = color;
}