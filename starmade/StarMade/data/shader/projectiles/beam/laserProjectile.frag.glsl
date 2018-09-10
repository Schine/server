#version 120
uniform sampler2D tex;
varying float distance;
varying float time;
varying vec4 color;
uniform float zoomFac;
const float margin = 0.13;

void main()
{
	vec4 pColor = texture2D(tex,   vec2(gl_TexCoord[0].x, gl_TexCoord[0].y));
	
	float tt = abs(gl_TexCoord[0].x - 0.5);
	
	float alpha = pow(max(0.0,(0.5-tt)), 1.2+(zoomFac*2.0)) * (5.0+(zoomFac*1.0));
	
		
	float p = min(1.0, pow(gl_TexCoord[0].y , 0.6));
	float p2 = min(1.0, pow(1.0-gl_TexCoord[0].y, 0.6));
	
	if(gl_TexCoord[0].y > margin+(zoomFac*0.13)){
		alpha = alpha * pow((gl_TexCoord[0].y-margin)*1.1, 2.15+(zoomFac*0.03))*(2.0+(zoomFac*7.6));
	}
	
	alpha *= p;
	alpha *= p2;
	
	
	if(alpha < 0.1 || time > 0.0000001){
		discard;
	}
	alpha -= 0.1;
	//pColor *= 2.0;
	pColor.xyz += (zoomFac *-0.85);
	gl_FragColor =  vec4(pColor.x,pColor.y,pColor.z, alpha)*(alpha+0.4)*color;//vec4(1,1,1,0.5f);
}