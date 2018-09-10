#version 120



uniform bool handheld;
uniform float size;
uniform float zoomFac;
varying vec3 outOrigPos;
varying vec3 outNormal;


void main()
{
	
	
	
	
	outOrigPos = gl_Vertex.xyz;

    //Width of beam scales with size
    float maxCount = 1000.0;
    float minSize = 0.75+ (zoomFac * -0.3);
    float maxSize = 1.5+ (zoomFac * -0.6);
    if(handheld){
        minSize = 0.1+ (zoomFac * -0.07);
        maxSize = 0.1 + (zoomFac * -0.07);
    }
	outOrigPos.x *= maxSize - max((maxCount - size) / maxCount,0.0) * (maxSize - minSize);
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
	outNormal = normalize( gl_NormalMatrix * gl_Normal );
	
	
	
	outOrigPos.xyz += gl_Normal.xyz * (zoomFac * 0.01);
	
	vec4 pos = gl_ModelViewMatrix * vec4(outOrigPos, 1.0);
	vec3 dir = normalize(-pos.xyz);
	pos.xyz += dir * (zoomFac * 0.001);
	
	
	gl_Position = gl_ProjectionMatrix * vec4(pos.xyz, 1.0);
	
	
}

