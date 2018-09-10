#version 120

// Weights and offsets for the Gaussian blur

	varying vec3 Position;
	varying vec3 Normal;
	varying vec2 TexCoord;
	
	uniform sampler2D RenderTex;
	uniform sampler2D BlurTex;
	uniform float Width;
	uniform float gammaInv;
	
	
	
	uniform float Weight[10];
	
	float luma( vec3 color ) {
		return 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
	}
	
	// Second blur and add to original
	vec4 pass4()
	{
		float size = 2.0;
		float dx = 1.0 / Width;
		vec4 val = texture2D(RenderTex, TexCoord);
		vec4 sum = texture2D(BlurTex, TexCoord) * Weight[0];
		
		
		for( int i = 1; i < 10; i++ )
		{
			sum += texture2D( BlurTex, TexCoord + vec2(float(i),0.0) * dx ) * Weight[i]*0.5;
					
			sum += texture2D( BlurTex, TexCoord - vec2(float(i),0.0) * dx ) * Weight[i]*0.5;
		}
		
	    
		return val + sum;
	}
	
	void main() {
	
		vec4 colorAndBloom = pass4();
		/*
		float exposure = 1.201;
		float bright = 1.201;
		
	    float YD = exposure * (exposure / bright + 1.0) / (exposure + 1.0);
	    colorAndBloom *= YD;
	    */
		
		colorAndBloom.xyz = pow(colorAndBloom.xyz, vec3(gammaInv));
    
    	gl_FragColor = colorAndBloom;
	}