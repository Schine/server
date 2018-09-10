#version 120

varying vec4 vColor;

uniform float uTime;
//uniform vec2 uResolution;
uniform sampler2D uDiffuseTexture;

//TE scanline effect
//some code by iq, extended to make it look right
//ported to Rajawali by Davhed

varying vec4 tCol;

float rand(vec2 co) { 
 	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
} 

void main() { 

	//vec2 uResolution = vec2(10.0, 300.0);


   vec2 q = gl_TexCoord[0].xy;// / uResolution.xy; 

 // subtle zoom in/out 
   vec2 uv =  0.5 + (q-0.5);//*(0.999 + 0.001*sin(0.95*uTime));

   vec4 oricol = texture2D(uDiffuseTexture,vec2(q.x,1.0-q.y)) ;
   
//   vec4 oricol = texture2D(uDiffuseTexture,q);
   vec4 col;

 // start with the source texture and misalign the rays it a bit
 // TODO animate misalignment upon hit or similar event
   col.r = texture2D(uDiffuseTexture,vec2(uv.x+0.002,uv.y)).x;
   col.g = texture2D(uDiffuseTexture,vec2(uv.x+0.0000,uv.y)).y;
   col.b = texture2D(uDiffuseTexture,vec2(uv.x-0.002,uv.y)).z;
   col.a = texture2D(uDiffuseTexture,q).a;

 // contrast curve
   //col.xyz = clamp(col.xyz*0.5+0.5*col.xyz*col.xyz*1.2,0.0,1.0);

 //vignette
  // col.xyz *= 0.9 + 0.4*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y);

 //color tint
   //col.xyz *= vec3(0.93,0.95,0.95);

 //scanline (last 2 constants are crawl speed and size)
 //TODO make size dependent on viewport
   col.xyz *= 1.0+0.2*sin(6.0*uTime+uv.y*500.0);

 //flickering (semi-randomized)
   //col.xyz *= 1.0-0.02*rand(vec2(uTime, tan(uTime)));

 //smoothen
 //  float comp = smoothstep( 0.2, 0.7, sin(uTime) );
//   col.xyz = mix( col.xyz, oricol.xyz, clamp(-2.0+2.0*q.x+3.0*comp,0.0,1.0) );

	vec4 finalColor = col*tCol;
	
	if(finalColor.a < 0.1){
		discard;
	}
   gl_FragColor = finalColor;
   //gl_FragColor = vec4(col.xyz,oricol.a);
  // gl_FragColor = texture2D(uDiffuseTexture,q);

}