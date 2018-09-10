#version 120
	uniform sampler2D inputTexture;
	uniform float inputTextureWidth;
	uniform float inputTextureHeight;
	#IFDEF withDepth
	uniform sampler2D depthTexture;
	#ENDIF
	
	
	// First blur pass
	vec4 avg()
	{
		float size = 1.0;
		float dx = 1.0 / inputTextureWidth;
		float dy = 1.0 / inputTextureHeight;
		
		
		vec4 sum = vec4(0.0);
		for(int x = -3; x < 4; x++){
			for(int y = -3; y < 4; y++){
				sum += texture2D( inputTexture, gl_TexCoord[0].st + vec2( float(x) * dx, float(y) * dy ) ) * (1.0/(7.0-(abs(float(x))+abs(float(y)))));
				
				
			}		
		}
		float k = length(sum.xyz) / max(1.0, (20.0 - sum.w));
		sum.xyz = normalize(sum.xyz)* k ;	
		return sum;
	}
	
	
	
	void main()
	{
		// This will call pass1(), pass2(), pass3(), or pass4()
		//gl_FragColor = texture2D(inputTexture, gl_TexCoord[0].st);
		gl_FragColor = avg();
	}