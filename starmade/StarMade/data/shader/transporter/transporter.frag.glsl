#version 120

float hash (float v) {
  return smoothstep(0.3, 0.8, abs(sin(v))) * 20.0;
}

uniform float time;
uniform float intensity;
uniform vec3 colorMain;

void main(void) {
	vec2 resolution = vec2(1.0, 0.2);

	float alph = 1.0-gl_TexCoord[0].y;//	2.0 * gl_TexCoord[0].y - 1.0;
	alph = pow((1.0-abs(alph)), 1.4) ;
	vec2 tt = gl_TexCoord[0].xy;
	tt.x *= 1.2588;
    vec2 q = tt / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;		
    p.x *= resolution.x / resolution.y;	
	
    float v = p.x + cos(time + p.y);
    	
    vec3 col = colorMain;
    vec3 c = vec3(0.0);	
    c += col / (abs(tan(hash(p.x) + cos(time + p.y)))); 
    c += col / (abs(tan(hash(p.y) + cos(time + p.x))));

	c *= (0.6 + intensity * 12.0);
	
    gl_FragColor = vec4(c*alph, min(1.0, length(c)* alph));
}