#version 120


uniform float m_MinAlpha;
uniform float m_MaxDistance;
const float pi = 3.141592;
const float e = 2.71828183;


//uniform vec4 m_Color;
uniform sampler2D m_ShieldTex;
uniform sampler2D m_Distortion;
uniform sampler2D m_Noise;
uniform float m_Time;
uniform int m_CollisionNum;
uniform float m_Damages[8]; //between 0 and 1 (dmg/1000)
uniform float m_Percent[8]; //between 0 and 1 
uniform float m_CollisionAlphas[8];

//some crappy ATI cards do not support varying arrays. sometimes even without giving compiling errors
varying float dist0;
varying float dist1;
varying float dist2;
varying float dist3;
varying float dist4;
varying float dist5;
varying float dist6;
varying float dist7;

vec2 hit(float dist, vec2 alphaIn, int i){

	vec2 alphaOut = vec2(alphaIn);
	if(i < m_CollisionNum){
		  float x = dist / (m_MaxDistance);
		  float x2 = dist / (m_MaxDistance) / 2.0;
		  
		  float collAlpha = m_CollisionAlphas[i];
		  
		  float y = collAlpha;
		  float z = clamp(1.3 - collAlpha, 0.0, 1.0);
		  
		
		  alphaOut.x += pow(e,(-1.0*((x2-z)*(x2-z))*20.0))*(1.0-z)*2.0 * m_Damages[i]*2.0;
		  
		  alphaOut.x = max(0.0,min(1.0, alphaOut.x));
		  alphaOut.y += m_Percent[i];
	}
	return alphaOut;
	  
}

void main(void) {
	vec4 color = vec4(0.55, 1.10, 1.8, m_MinAlpha);
	
	
	
	vec2 alphaPerc = vec2(color.a, 0.0);
	alphaPerc = hit(dist0*0.000001, alphaPerc, 0);
	alphaPerc = hit(dist1, alphaPerc, 1);
	alphaPerc = hit(dist2, alphaPerc, 2);
	alphaPerc = hit(dist3, alphaPerc, 3);
	alphaPerc = hit(dist4, alphaPerc, 4);
	alphaPerc = hit(dist5, alphaPerc, 5);
	alphaPerc = hit(dist6, alphaPerc, 6);
	alphaPerc = hit(dist7, alphaPerc, 7);

	color.a = alphaPerc.x;


	vec4 noise = texture2D(m_Noise, (gl_TexCoord[0].st + m_Time*0.1)*4.0); 	//load du/dv normalmap //+noise.xy/2.0
	//removed distortion offset breaks tiling
	//vec4 distort = texture2D(m_Distortion, noise.xy * gl_TexCoord[0].st*0.01100.0); 	//load du/dv normalmap //+noise.xy/2.0
	


	color *= texture2D(m_ShieldTex, noise.xz*0.2+gl_TexCoord[0].st); //+(distort.xy*0.0)
	color.gb *= min(1.0, alphaPerc.y*1.5);
	if(color.a < 0.012){
		discard;
	}
	float alf = clamp(color.a*0.4, 0.0, 0.80);
	color.r = min(1.0, color.r + alf);
	color.g = min(1.0, color.g + alf);
	color.b = min(1.0, color.b + alf);
	
	
	gl_FragColor = color*3.0;//vec4(texture2D(m_ShieldTex, gl_TexCoord[0].st).rgba);;
  	
}