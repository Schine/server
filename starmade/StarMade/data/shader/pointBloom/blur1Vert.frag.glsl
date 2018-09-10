#version 120
	uniform sampler2D BlurTex;
	uniform float Height;
	
	// Weights and offsets for the Gaussian blur
	uniform float Weight[20];
	
	
	// First blur pass
	vec4 pass3()
	{
		float dy = 1.0 / Height;
		/*
		vec4 sum = texture2D(BlurTex, gl_TexCoord[0].st) * Weight[0];
		
		for( int i = 1; i < 20; i++ )
		{
			sum += texture2D( BlurTex, gl_TexCoord[0].st + vec2( 0.0, float(i)* dy )  ) * Weight[i] * 1.0;
			sum += texture2D( BlurTex, gl_TexCoord[0].st - vec2( 0.0, float(i)* dy )  ) * Weight[i] * 1.0;
			
		}
		*/
		
	   float blurSize = dy;
	   vec4 sum = vec4(0.0);
	   vec2 texCoord = gl_TexCoord[0].st;
	   // blur in y (vertical)
	   // take nine samples, with the distance blurSize between them
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y - 4.0*blurSize)) * 0.06;
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y - 3.0*blurSize)) * 0.09;
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y - 2.0*blurSize)) * 0.12;
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y - blurSize)) * 0.15;
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y)) * 0.16;
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y + blurSize)) * 0.15;
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y + 2.0*blurSize)) * 0.12;
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y + 3.0*blurSize)) * 0.09;
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y + 4.0*blurSize)) * 0.06;
		
		
		return sum;
	}
	
	
	
	void main()
	{
		// This will call pass1(), pass2(), pass3(), or pass4()
		//gl_FragColor = texture2D(BlurTex, gl_TexCoord[0].st);
		gl_FragColor = pass3();
	}