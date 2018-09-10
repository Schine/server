#IFDEF force130
#version 130
#ELSE
#version 120
#ENDIF

#IFDEF force130
//no extension needed for using version 130
#ELSEIF shader4
#extension GL_EXT_gpu_shader4: enable
#ENDIF


#IMPORT data/shader/cube/cubeTextures.glsl


uniform float density;
uniform float selectTime;
uniform float extraAlpha;

uniform vec3 viewPos;
uniform vec3 lightPos;

#IFDEF virtual
uniform float uTime;
varying vec2 quadVar;
#ENDIF

#IMPORT data/shader/cube/cubeLightVars.glsl

varying vec3 vertexLight;
varying vec4 occlusion;


#IFDEF lightall
varying float noLight;
#ENDIF

#IFDEF force130
flat in int layer;
flat in float extraAlphaVert;

#ELSE
varying float layer;
varying float extraAlphaVert;
#ENDIF


const float LOG2 = 1.442695;



#IMPORT data/shader/shadow.glsl

vec3 gamma(vec3 color){
    return pow(color, vec3(1.0/2.0));
}
float rand(vec2 co) { 
 	return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
} 

vec4 scanline(vec4 oricol, vec4 col, vec2 uv, float uTime){
	//color tint
	col.xyz *= vec3(0.83, 1.0, 0.78);
	
	//scanline (last 2 constants are crawl speed and size)
	col.xyz *= 0.8 + 0.2 * sin(4.0 * uTime + uv.y * 100.0);
	
	//flickering (semi-randomized)
	col.xyz *= 1.0 - 0.025 * rand(vec2(uTime, tan(uTime)));
	
	vec4 finalColor = col * oricol * 1.6;
		
	return finalColor;
  }
vec4 getBlockTexture(sampler2D mainTex){
	#IFDEF virtual
		float shift = 0.004;
	 	vec2 uvScan;
		vec4 oricol;
		vec4 col;
		uvScan =  0.5 + (quadVar.st - 0.5) * (0.9 + 0.1 * sin(0.95 * uTime));
		oricol = texture2D(mainTex, gl_TexCoord[0].st);
		
		col.r = texture2D(mainTex, vec2(gl_TexCoord[0].s+shift*uvScan.x, gl_TexCoord[0].t)).x;
		col.g = oricol.g;
		col.b = texture2D(mainTex, vec2(gl_TexCoord[0].s-shift*uvScan.x, gl_TexCoord[0].t)).z;
		col.a = oricol.a;
		return scanline(oricol, col, uvScan, uTime);
	#ELSE
		return texture2D(mainTex, gl_TexCoord[0].st);
	#ENDIF
}
#IMPORT data/shader/cube/cubeLight.glsl


#IFDEF normalmap
vec3 getSpot(vec4 mixTex, int spots, vec3 bump){
#ELSE
vec3 getSpot(vec4 mixTex, int spots){
#ENDIF
	vec3 spot = vec3(0.0);
	for(int i = 1; i <= spots; i++){
	
		vec3 lightDirSpot =  gl_LightSource[i].position.xyz - (vPos).xyz;
		
		float d = length(lightDirSpot);
		
		float spotAtt = min(1.0, 1.0 / ( gl_LightSource[i].constantAttenuation + 
		(gl_LightSource[i].linearAttenuation*d) + 
		(0.02*d*d) ));
		#IFDEF normalmap
		spot += spotLight( shininess, mixTex, gl_TexCoord[0].st, lightDirSpot, spotAtt, i, bump);
		#ELSE
		spot += spotLight( shininess, mixTex, gl_TexCoord[0].st, lightDirSpot, spotAtt, i);
		#ENDIF
	}
	return clamp(spot, 0.0, 1.0);
}

void main()
{

 	

	vec4 tex;
	float emissionAndShine = 0.0;
	#IFDEF normaltexarray
		tex = texture2DArray(cTex, vec3(gl_TexCoord[0].st, layer));
		vec3 bump = normalize(texture2DArray(cTexNormal, vec3(gl_TexCoord[0].st, extraAlphVsLayerNoLight.y)).xyz * 2.0 - 1.0); 
	#ELSEIF texarray
		tex = texture2DArray(cTex, vec3(gl_TexCoord[0].st, layer));
	#ELSEIF normalmap
		vec4 bTex;
		vec3 bump;
		#DELAYEDIFDEF force130
			switch(layer){
				case 0:
		#DELAYEDELSE
			if(layer <= 0.1){
		#DELAYEDENDIF
				bTex = texture2D(normalTex0, gl_TexCoord[0].st);
				tex = getBlockTexture(mainTex0);
				bump = (bTex.xyz * 2.0 - 1.0); // from [0, 1] space to [-1,1] 
				emissionAndShine = bTex.a;
		#DELAYEDIFDEF force130
				break;
				case 1:
		#DELAYEDELSE
				}else if(layer <= 1.5){
		#DELAYEDENDIF
				bTex = texture2D(normalTex1, gl_TexCoord[0].st);
				tex = getBlockTexture(mainTex1);
				bump = (bTex.xyz * 2.0 - 1.0);
				emissionAndShine = bTex.a;
		#DELAYEDIFDEF force130
				break;
				case 2:
		#DELAYEDELSE
				}else if(layer <= 2.5){
		#DELAYEDENDIF
				bTex = texture2D(normalTex2, gl_TexCoord[0].st);
				tex = getBlockTexture(mainTex2);
				bump = (bTex.xyz * 2.0 - 1.0);
				emissionAndShine = bTex.a;
		#DELAYEDIFDEF force130
				break;
				default:
		#DELAYEDELSE
				}else{
		#DELAYEDENDIF
				bTex = texture2D(normalTex7, gl_TexCoord[0].st);
				tex = getBlockTexture(mainTex7);
				bump = (bTex.xyz * 2.0 - 1.0);
				emissionAndShine = bTex.a;
		#DELAYEDIFDEF force130
				break;
				}
		#DELAYEDELSE
				}
		#DELAYEDENDIF
		
	
		
	
		
	#ELSE
	
		#DELAYEDIFDEF force130
			switch(layer){
				case 0:
		#DELAYEDELSE
			if(layer <= 0.1){
		#DELAYEDENDIF
				tex = getBlockTexture(mainTex0);
		#DELAYEDIFDEF force130
				break;
				case 1:
		#DELAYEDELSE
				}else if(layer <= 1.5){
		#DELAYEDENDIF
				tex = getBlockTexture(mainTex1);
		#DELAYEDIFDEF force130
				break;
				case 2:
		#DELAYEDELSE
				}else if(layer <= 2.5){
		#DELAYEDENDIF
				tex = getBlockTexture(mainTex2);
		#DELAYEDIFDEF force130
				break;
				default:
		#DELAYEDELSE
				}else{
		#DELAYEDENDIF
				tex = getBlockTexture(mainTex7);
		#DELAYEDIFDEF force130
				break;
				}
		#DELAYEDELSE
				}
		#DELAYEDENDIF
	#ENDIF
	
	//tex = vec4(0.5,0.5,0.5,1.0); //uncomment this for greyscale
	
	float shininess = 30.0;
	float emission = 0.0;
	float specular = 1.0;
	#IFDEF noemission
		emissionAndShine = 0.0;
	#ELSE
		if(emissionAndShine > 0.5){
			emission = ((emissionAndShine - 0.5) * 2.0);
			specular = 0.0;
		}else{
			specular = max(0.0, (emissionAndShine * 2.0));
			emission = 0.0;
		}
	#ENDIF
	
	
	float alphMod = extraAlphaVert+(extraAlpha * ( tex.a));
	
	#IFDEF blended
	if(alphMod < 0.01){
		discard;
	}
	#ENDIF

	vec4 mixTex;
	
	vec4 oTex = texture2D(overlayTex, gl_TexCoord[1].st);
	vec4 oreTex = texture2D(overlayTex, gl_TexCoord[2].st);
	
	shininess = max(1.0, texture2D(overlayTex, 
	vec2(
		layer * 0.25 + 0.25 * fract(gl_TexCoord[0].x), 
		0.125 + 0.25 * fract(gl_TexCoord[0].y))
		).g*512.0);
			
	
	
	
	
	#IFDEF blended
		mixTex = mix(tex , oTex, oTex.a);
	#ELSE
		vec4 mixTexOre = mix(tex , oreTex, oreTex.a);
		mixTex = mix(mixTexOre , oTex, oTex.a);
	#ENDIF
	
	
	
	vec4 lightedColor;
	
	#IFDEF lightall
	if(noLight > 0.0001){
		lightedColor.xyz = vertexLight.xyz * mixTex.xyz;
	}else{
	#ENDIF
	
	
	float dist = length(vPos.xyz);
	#IFDEF vertexLighting
		lightedColor.xyz = vertexLight.xyz * mixTex.xyz;
		//lightedColor.xyz = vec3(1.0);
	#ELSEIF normalmap
		if(dist > 32.0){
			float p = pow((64.0-dist)*0.03125, 3.2);
			vec3 neutral = vec3(0.0, 0.0, 1.0);
			bump = mix(neutral, bump, max(0.1, p));
		}
		
		lightedColor.xyz = calculateLight( lightPos, shininess, specular, mixTex, occlusion, gl_TexCoord[0].st, bump);
		if(dist >= 68.0){
			float p = pow((100.0-dist)*0.03125, 4.2); // div 32
			vec3 vLight = vertexLight.xyz * mixTex.xyz;
			//vertexLight = vec3(1.0);
			lightedColor.xyz = mix(vLight, lightedColor.xyz, max(0.0, p));
		}
	#ELSE
	
	
		lightedColor.xyz = calculateLight( lightPos, shininess, specular, mixTex, occlusion, gl_TexCoord[0].st);
		if(dist >= 68.0){
			float p = pow((100.0-dist)*0.03125, 4.2); // div 32
			vec3 vLight = vertexLight.xyz * mixTex.xyz;
			lightedColor.xyz = mix(vLight, lightedColor.xyz, max(0.0, p));
		}
		
	#ENDIF
		
	
	#IFDEF lightall
	}
	#ENDIF
	
	#IFDEF blended
		lightedColor.a = alphMod;
	#ELSE
		lightedColor.a = 1.0;
	#ENDIF
	
	if (selectTime > 0) {
		lightedColor.rgb += (sin(selectTime / 100.0) + 1.0) * 0.125;
	}
	
	
	gl_FragColor = lightedColor;
	
	#IFDEF shadow
		float shadow_coef = occlusion.w*(1.0-shadowCoef());
		//shadow_coef += occLight;
		gl_FragColor.rgb = gl_FragColor.rgb * min(1.0, ((1.0-shadow_coef)+0.17))*1.2;
	#ENDIF
	
	#IFDEF nospotlights
		gl_FragColor.rgb = max(emission*mixTex.rgb, gl_FragColor.rgb );
	#ELSEIF vertexLighting
		gl_FragColor.rgb = max(emission*mixTex.rgb, gl_FragColor.rgb );
	#ELSEIF normalmap
		vec3 spot = getSpot(lightedColor, spotCount, bump);
		gl_FragColor.rgb = max(emission*lightedColor.rgb, gl_FragColor.rgb + spot);
	#ELSE
		vec3 spot = getSpot(mixTex, spotCount);
		gl_FragColor.rgb = max(emission*mixTex.rgb, gl_FragColor.rgb + spot);
	#ENDIF
	//gl_FragColor.rgb = tex.xyz;//vertexLight.xyz * mixTex.xyz;//vec3(>300.0 ? 1.0 : 0.0);//vec3(shininess/1024.0);
}