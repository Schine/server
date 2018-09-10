//https://github.com/mrdoob/glsl-sandbox

#version 120
#extension GL_EXT_gpu_shader4 : enable

uniform float time;

varying vec4 viewPos;
uniform vec4 viewport;
uniform vec4 color;
uniform vec4 color2; //default vec4(1.3, 1.8, 1.0, 1.0)
uniform vec2 resolution; //default 26
uniform vec2 invResolution; //default 26
uniform int fieldIteration; //default 26
uniform int field2Iteration; //default 18
float field(in vec3 p,float s) {
	float strength = 7. + .03 * log(1.e-6 + fract(sin(time) * 12000.11));
	float accum = s*0.166666; // = 1/6
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < fieldIteration; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) * 0.192857); // = 1/7 (0.142857)
		accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
		tw += w;
		prev = mag;
	}
	return max(0., 5. * accum / tw - .7);
}

// Less iterations for second layer
float field2(in vec3 p, float s) {
	float strength = 7. + .03 * log(1.e-6 + fract(sin(time) * 4373.11));
	float accum = s*0.25;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < field2Iteration; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) * 0.162857); // = 1/7 (0.142857)
		accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
		tw += w;
		prev = mag;
	}
	return max(0., 5. * accum / tw - .7);
}

vec3 nrand3( vec2 co )
{
	vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
	vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
	vec3 c = mix(a, b, 0.5);
	return c;
}
varying mat4 model;

void main() {
	vec2 res;
	vec2 uv;
	vec2 tCoord;
	if(length(resolution) > 0){
		res = resolution;
		tCoord = gl_FragCoord.xy * invResolution.xy;
		uv = 2. * tCoord  - 1.;
		//tCoord = 2.0*(tCoord-0.5);
	}else{
		tCoord = gl_TexCoord[0].st;
		res = viewport.zw*2.3;
		uv = 2.0*(gl_TexCoord[0].st-0.5);//2. * gl_TexCoord[0].xy / res.xy - 1.;
	}
	

	
	vec2 uvs = uv;// (thats one normally) original: * res.xy / max(res.x, res.y);
	vec3 p = vec3(uvs * 0.25, 0) + vec3(1., -1.3, 0.);
	p += .2 * vec3(sin(time * 0.0625), sin(time * 0.083333),  sin(time * 0.0078125));
	
	
	float freqs[4];
	freqs[0] = 0.04;
	freqs[1] = color.x;
	freqs[2] = color.y;
	freqs[3] = color.z;
	
	float t = field(p,freqs[2]);
	float v = (1. - exp((abs(uv.x) - 1.) * 6.)) * (1. - exp((abs(uv.y) - 1.) * 6.));
	
    //Second Layer
	vec3 p2 = vec3(uvs / (4.+sin(time*0.11)*0.2+0.2+sin(time*0.15)*0.3+0.4), 1.5) + vec3(2., -1.3, -1.);
	p2 += 0.25 * vec3(sin(time * 0.0625), sin(time * 0.083333),  sin(time * 0.0078125));
	float t2 = field2(p2,freqs[3]);
	
	vec4 c2 = mix(.4, 1., v) * vec4(color2.r * t2 * t2 * t2 ,color2.g  * t2 * t2 * t2 * t2, color2.b*t2* freqs[0], color2.a*t2);
	
	

	float a = min(1.0, pow(abs((abs(tCoord.y-0.5)-0.5)),2.0)*5.0);
	float b = min(1.0, abs((abs(tCoord.x-0.5)-0.5))*10.0);
	
	gl_FragColor =  a*b*(color.a*mix(freqs[3]-.3, 1., v) * vec4(1.5*freqs[2] * t * t* t , 1.1*freqs[1] * t * t, freqs[3]*t, 1.0)+color.a*c2);
}