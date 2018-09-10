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
uniform vec4 tint;
uniform float fCameraHeight;
uniform float fOuterRadius;
uniform float fInnerRadius;

varying vec3 v3Direction;


void main (void)
{
	float fCos = dot(v3LightPos, v3Direction) / length(v3Direction);
	
	float fMiePhase = 1.5 * ((1.0 - g2) / (2.0 + g2)) * (1.0 + fCos * fCos) / pow(1.0 + g2 - 2.0 * g * fCos, 0.75);
	vec4 color = tint / min(max(2.0, ((fCameraHeight - fOuterRadius) / 30.0)), 500.0) * (vec4(1.0, 1.0, 1.0, 1.0) + fMiePhase * gl_SecondaryColor) * (4.25 - min(3.0, ((fOuterRadius - fCameraHeight) / 25.0)));
	color.a = max(max(color.r * 0.53, color.g * 0.53), color.b * 0.53) * min(max((fOuterRadius - fCameraHeight) / 5.0, 0.5), 5.5) * (1.0 - fCos - min(1.0, ((fOuterRadius - fCameraHeight) / (fOuterRadius - fInnerRadius))));
	gl_FragColor = color;
}
