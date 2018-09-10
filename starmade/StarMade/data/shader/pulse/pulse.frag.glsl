#version 120


const float pi = 3.141592;
const float e = 2.71828183;


//uniform vec4 m_Color;
uniform sampler2D m_ShieldTex;
uniform sampler2D m_Distortion;
uniform sampler2D m_Noise;
uniform float m_Time;
//uniform vec3 m_Color;
uniform float m_Alpha;
uniform vec4 m_Color;

void main(void) {
	vec4 color = vec4(m_Color.rgb, m_Alpha);
	
	
	
	color.a = m_Alpha;


	vec4 noise = texture2D(m_Noise, (gl_TexCoord[0].st + m_Time)/30.0); 	//load du/dv normalmap //+noise.xy/2.0
	vec4 distort = texture2D(m_Distortion, noise.xy*color.a * gl_TexCoord[0].st/10.0); 	//load du/dv normalmap //+noise.xy/2.0
	


	color *= texture2D(m_ShieldTex, noise.xz*0.3+(distort.xy*0.1*color.a)+gl_TexCoord[0].st);
	if(color.a < 0.02){
		discard;
	}
	float alf = clamp(color.a*0.1, 0.0, 0.3);
	color.r = min(1.0, color.r + alf);
	color.g = min(1.0, color.g + alf);
	color.b = min(1.0, color.b + alf);
	
	
	gl_FragColor = color;   
}