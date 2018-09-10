#version 120
uniform sampler2D       firstPass;
uniform sampler2D       Texture;
uniform sampler2D       Scene;
uniform sampler2D       Dirt;
uniform vec4            Param1; // (SunPosX, SunPosY, 1.0/fbo.width, 0.5/FlareTexture.width)
uniform vec4            Param2; // (Radius, Stride, Bright, Scale
uniform vec4            tint; // (Radius, Stride, Bright, Scale)
uniform float			screenRatio; // GLFrame.getHeight() / GLFrame.getWidth()

//const float Sexposure = 0.0;
const float Sdecay = 0.96;
const float Sdensity = 0.86;
const float Sweight = 0.21;
const float exposure = 4.0;
const float decay = 0.2;
const float densityInv = 1.0;
const float weight1 = 0.015; 
const float weight2 = 0.035; 
//const float weight3 = 0.065;
//const float weight4 = 0.0;
//const float weight5 = 0.0;

const int NUM_SAMPLES = 80;

vec4 DoLenseFlare(vec2 ScreenLightPosition,vec2 texCoord,bool fwd, float weight, float xTC, float dist) 
	{
	    // Calculate vector from pixel to light source in screen space.
	    vec2 deltaTexCoord = (texCoord - ScreenLightPosition.xy);// Divide by number of samples and scale by control factor.
	    deltaTexCoord *= (dist) * densityInv;
	    deltaTexCoord.x /= screenRatio;
	 
	    // Store initial sample.
	    vec3 color = vec3(0.0);
	 
	    // Set up illumination decay factor.
	    float illuminationDecay = 1.0f;
	 
	    for (int i = 0; i < 3 ; i++)
	    {
	       	vec3  core = texture2D(firstPass, ScreenLightPosition.xy  - vec2(float(i)*0.33333,float(i)*0.33333) * Param2.w).rgb;
			
		            
	        float bright = dot(core, vec3(0.333));
	    
		        // Step sample location along ray.
		        if(fwd)
		            texCoord -= deltaTexCoord;
		        else
		            texCoord += deltaTexCoord;
		 
			 	if(texCoord.y > 1.0 || texCoord.y < 0.0 || texCoord.x > 1.0 || texCoord.x < 0.0){
			 		continue;
			 	}
			 	
		 		vec2 flareTC = texCoord;
		 		flareTC.x *= 0.5; //0.25 for 4 flare sprites
		 		flareTC.x += xTC;
		 		
		        // Retrieve sample at new location.
		        vec4 sample = texture2D(Texture, flareTC);
		 
		        // Apply sample attenuation scale/decay factors.
		        sample *= illuminationDecay * weight;
		        
		        // Accumulate combined color.
		        color += sample.xyz * bright ;
		 
		        // Update exponential decay factor.
		        illuminationDecay *= decay;
	    }
	 
	    return vec4(color,1);
	}

void main() 
	{
		vec2 deltaTextCoord = vec2( gl_TexCoord[0].st - Param1.xy );
		vec2 textCoo = gl_TexCoord[0].st;
		deltaTextCoord *= 1.0 / float(NUM_SAMPLES) * Sdensity;
		
		float illuminationDecay = 1.0f;
		
		vec4 fragCol = vec4(0.0,0.0,0.01,0.0);
		
		for(int i = 0; i < NUM_SAMPLES; i++) 
		{
			textCoo -= deltaTextCoord;
			vec4 sample = texture2D(firstPass, textCoo);
			sample *= illuminationDecay * Sweight;
			sample *= Sweight;
			fragCol += sample;
			illuminationDecay *= (Sdecay);
		}	
		
		fragCol *= tint*1.5;
		
		//vec2 coord = gl_TexCoord[0].st;
		
		vec4 lf = DoLenseFlare(	Param1.xy, textCoo,	false, weight1, 0.0, 15.0);//flare far 
		     lf += DoLenseFlare(Param1.xy, textCoo,	false, weight1, 0.0, 30.0); // flare close
			 lf += DoLenseFlare(Param1.xy, textCoo,	false, weight2, 0.5, 1.75); //ring
			 //lf += DoLenseFlare(Param1.xy, textCoo,	false, weight3, 0.75, 10.0); //dot
		     //lf += DoLenseFlare(Param1.xy, textCoo,	false, weight4, 0.0, 35.0);
		    
		
		vec4 col = ( lf * exposure);// * 5.0;
				
		//vec4 dirt = fragCol*texture2D(Dirt, -gl_TexCoord[0].st);
		//vec4 Ldirt = col*texture2D(Dirt, -gl_TexCoord[0].st)*2;
		//vec4 Sdirt = fragCol*texture2D(Dirt, -gl_TexCoord[0].st)*0.33;
		
		vec4 dirt = (col*texture2D(Dirt, -gl_TexCoord[0].st))+(fragCol*texture2D(Dirt, gl_TexCoord[0].st)*0.3);
			
		fragCol += col;
		
		gl_FragColor = texture2D(Scene, gl_TexCoord[0].st) +fragCol+dirt;
		//gl_FragColor = (fragCol+dirt); //uncomment for Sun shader only
		
	}

