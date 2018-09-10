//
// Atmospheric scattering fragment shader
//
// Author: Sean O'Neil
//
// Copyright (c) 2004 Sean O'Neil
//

uniform vec3 v3LightPos;
const float g = -0.990;
const float g2 = 0.9801;
const float fExposure = 2.0;
uniform vec4 tint;
uniform float fCameraHeight;
uniform float fOuterRadius;
uniform float fInnerRadius;

varying vec3 v3Direction;

varying vec4 v4MieColor;


// Mie phase function
float getMiePhase(float fCos, float fCos2, float g, float g2)
{
	return 1.5 * ((1.0 - g2) / (2.0 + g2)) * (1.0 + fCos2) / pow(1.0 + g2 - 2.0*g*fCos, 1.5);
}

// Rayleigh phase function
float getRayleighPhase(float fCos2)
{
	//return 0.75 + 0.75 * fCos2;
	return 0.75 * (2.0 + 0.5 * fCos2);

}


void main (void)
{
	float fCos = dot(v3LightPos, v3Direction) / length(v3Direction);
	
	vec4 atmosphereBase = vec4(0.0, 0.0, 0.0, 1.0);
	float fMiePhase = 1.5 * ((1.0 - g2) / (2.0 + g2)) * (1.0 + fCos * fCos) / pow(1.0 + g2 - 2.0 * g * fCos, 0.75);
	atmosphereBase = tint / min(max(2.0, (fCameraHeight - fOuterRadius) / 30.0), 500.0) * (gl_Color + fMiePhase * gl_SecondaryColor) * (4.25 - min(3.0, ((fOuterRadius - fCameraHeight) / 25.0)));
	atmosphereBase.a = (atmosphereBase.b + atmosphereBase.r * 0.53) * 3.5;			
	atmosphereBase.a = max(max(atmosphereBase.r * 0.53, atmosphereBase.g * 0.53), atmosphereBase.b * 0.53) * min(max((fOuterRadius - fCameraHeight) / 5.0, 0.5), 5.5) * (1.0 - fCos - min(1.0, ((fOuterRadius - fCameraHeight) / (fOuterRadius - fInnerRadius))));
	//gl_FragColor.a = gl_FragColor.b; //original
	
	float fCos0 = dot(v3LightPos, v3Direction) / length(v3Direction);
	float fCos2 = fCos0*fCos0;
	vec4 color = atmosphereBase + getMiePhase(fCos0, fCos2, g, g2) * v4MieColor ; //secondary is miew, first is Rayleigh
	color.a = max(max(color.r, color.g), color.b);
	color = 1.0 - exp(-fExposure * color);
	
	gl_FragColor = color;
}
