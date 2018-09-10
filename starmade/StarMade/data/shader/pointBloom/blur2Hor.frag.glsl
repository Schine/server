#version 120

// Weights and offsets for the Gaussian blur
	uniform sampler2D RenderTex;
	uniform sampler2D BlurTex;
	uniform float Width;
	uniform float gammaInv;
	
	uniform float Weight[30];
	
	// Second blur and add to original
	vec4 pass4()
	{
		float size = 2.0;
		float dx = 1.0 / Width ;
		
		
		/*
		vec4 sum = texture2D(BlurTex, gl_TexCoord[0].st) * Weight[0];
		
		for( int i = 1; i < 30; i++ )
		{
			sum += texture2D( BlurTex, gl_TexCoord[0].st + vec2(float(i),0.0) * dx ) * Weight[i];
					
			sum += texture2D( BlurTex, gl_TexCoord[0].st - vec2(float(i),0.0) * dx ) * Weight[i];
		}
		*/
	    
	   float blurSize = dx;
	   vec4 sum = vec4(0.0);
	
		vec2 texCoord = gl_TexCoord[0].st;
	   // blur in y (vertical)
	   // take nine samples, with the distance blurSize between them
	   
	   sum += texture2D(BlurTex, vec2(texCoord.x- 15.0*blurSize, texCoord.y )) * 0.001;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 14.0*blurSize, texCoord.y )) * 0.002;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 13.0*blurSize, texCoord.y )) * 0.004;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 12.0*blurSize, texCoord.y )) * 0.005;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 11.0*blurSize, texCoord.y )) * 0.006;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 10.0*blurSize, texCoord.y )) * 0.007;
	   
	   sum += texture2D(BlurTex, vec2(texCoord.x- 9.0*blurSize, texCoord.y )) * 0.008;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 8.0*blurSize, texCoord.y )) * 0.009;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 7.0*blurSize, texCoord.y )) * 0.01;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 6.0*blurSize, texCoord.y )) * 0.05;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 5.0*blurSize, texCoord.y )) * 0.07;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 4.0*blurSize, texCoord.y )) * 0.10;
	   sum += texture2D(BlurTex, vec2(texCoord.x- 3.0*blurSize, texCoord.y )) * 0.18;
	   sum += texture2D(BlurTex, vec2(texCoord.x - 2.0*blurSize, texCoord.y)) * 0.24;
	   sum += texture2D(BlurTex, vec2(texCoord.x- blurSize, texCoord.y )) * 0.28;
	   sum += texture2D(BlurTex, vec2(texCoord.x, texCoord.y)) * 0.365;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ blurSize, texCoord.y )) * 0.28;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 2.0*blurSize, texCoord.y )) * 0.24;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 3.0*blurSize, texCoord.y )) * 0.18;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 4.0*blurSize, texCoord.y )) * 0.10;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 5.0*blurSize, texCoord.y )) * 0.07;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 6.0*blurSize, texCoord.y )) * 0.05;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 7.0*blurSize, texCoord.y )) * 0.01;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 8.0*blurSize, texCoord.y )) * 0.009;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 9.0*blurSize, texCoord.y )) * 0.008;
	   
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 10.0*blurSize, texCoord.y )) * 0.007;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 11.0*blurSize, texCoord.y )) * 0.006;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 12.0*blurSize, texCoord.y )) * 0.005;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 13.0*blurSize, texCoord.y )) * 0.004;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 14.0*blurSize, texCoord.y )) * 0.002;
	   sum += texture2D(BlurTex, vec2(texCoord.x+ 15.0*blurSize, texCoord.y )) * 0.001;
	    
	    //sum *= texture2D(BlurTex, vec2(texCoord.x, texCoord.y)).a*0.5;
		return sum;
	}
	
	void main() {
	
		vec4 colorAndBloom = pass4();
		
		vec4 col = texture2D(RenderTex, gl_TexCoord[0].st); //vec4(0.0);//
		
		//add total blur to render texture
		colorAndBloom += col ;
    
    	gl_FragColor = colorAndBloom;
    	//gl_FragColor = texture2D(BlurTex, gl_TexCoord[0].st);
	}