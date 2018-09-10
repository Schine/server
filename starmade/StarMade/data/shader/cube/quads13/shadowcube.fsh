#version 120
#extension GL_EXT_gpu_shader4: enable

varying vec2 mainTexCoords;

varying float layer;
varying float extraAlphaVert;

uniform sampler2D mainTex0;
uniform sampler2D mainTex1;
uniform sampler2D mainTex2;
uniform sampler2D mainTex7;

void main()
{

	
	#IFDEF blended
		vec4 tex;
		if(layer < 0.01){
			tex = texture2D(mainTex0, mainTexCoords.st);
		}else if(layer < 1.5){
			tex = texture2D(mainTex1, mainTexCoords.st);
		}else if(layer < 2.5){
			tex = texture2D(mainTex2, mainTexCoords.st);
		}else{
			tex = texture2D(mainTex7, mainTexCoords.st);
		}
		if(tex.a + extraAlphaVert < 0.3){
			discard;
		}
	#ELSE
		if(extraAlphaVert < -0.0001){
			discard;
		}
	#ENDIF
	
	#IFDEF VSM
		float depth = gl_FragCoord.z / gl_FragCoord.w ;
		depth = depth * 0.5 + 0.5;			//Don't forget to move away from unit cube ([-1,1]) to [0,1] coordinate system
	
		float moment1 = depth;
		float moment2 = depth * depth;
	
		// Adjusting moments (this is sort of bias per pixel) using partial derivative
		float dx = dFdx(depth);
		float dy = dFdy(depth);
		moment2 += 0.25*(dx*dx+dy*dy) ;
		
		gl_FragColor = vec4( moment1,moment2, 0.0, 1.0 );
		/*
		float depth = gl_FragCoord.z;
		float dx = dFdx(depth);
		float dy = dFdy(depth);
		gl_FragColor = vec4(depth, pow(depth, 2.0) + 0.25*(dx*dx + dy*dy), 0.0, 0.0);
		*/
	
	#ELSE
		//it's pretty useless if fbo only has a depth attachment 
		gl_FragColor = gl_FragCoord.zzzw;
	#ENDIF
}