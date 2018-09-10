#IFDEF force130
#version 130
#ELSE
#version 120
#ENDIF


const float pi = 3.141592;
const float e = 2.71828183;


//uniform vec4 m_Color;
uniform sampler2D m_ShieldTex;
uniform sampler2D m_Distortion;
uniform sampler2D m_Noise;
uniform float m_Time;
uniform float m_MinAlpha;





void main(void) {
	vec4 color = vec4(0.7, 0.7, 1.0, m_MinAlpha);
	
	

	vec4 noise = texture2D(m_Noise, gl_TexCoord[0].st+m_Time*0.005); 	//load du/dv normalmap //+noise.xy/2.0
	vec4 distort = texture2D(m_Distortion, gl_TexCoord[0].st+m_Time*0.011); 	//load du/dv normalmap //+noise.xy/2.0
	


	color *= texture2D(m_ShieldTex, noise.xz*0.2+((noise.xz+distort.xy)*0.2)+(gl_TexCoord[0].st)+m_Time*0.1);
	//color *= texture2D(m_ShieldTex, gl_TexCoord[0].st);
	/*
	if(color.a < 0.02){
		discard;
	}
	*/
	float alf = clamp(color.a*0.1, 0.0, 0.3);
	color.r = min(1.0, color.r + alf);
	color.g = min(1.0, color.g + alf);
	color.b = min(1.0, color.b + alf);
	
	
	gl_FragColor = color;//+vec4(1.0,1.0,1.0,1.0);   
}