#IFDEF force130
#version 130
#ELSE
#version 120
#ENDIF

#IFDEF shadow
#extension GL_EXT_gpu_shader4: enable
#ELSEIF texarray
#extension GL_EXT_gpu_shader4: enable
#ELSEIF normaltexarray
#extension GL_EXT_gpu_shader4: enable
#ENDIF

uniform vec3 viewPos;
uniform vec3 lightPos;

#IMPORT data/shader/cube/cubeLightVars.glsl

#IMPORT data/shader/cube/cubeLight.glsl



uniform vec3 lightVec[4];
uniform vec4 lightDiffuse[4];
uniform bool emissiveOn;

uniform sampler2D mainTex;
uniform sampler2D emissiveTex;

varying vec3 normal;

#IFDEF normalmap
uniform sampler2D normalTex;
#ENDIF

#IMPORT data/shader/shadow.glsl

void main()
{
	vec4 tex;
	
	float shininess = 30.0;
	
	
	
	tex = texture2D(mainTex, gl_TexCoord[0].st);
	
	float specular = 0.5;
	
	float extraLight = 8.0;
	
	vec4 lig0 = vec4(lightDiffuse[0].rgb, min(1.0, lightDiffuse[0].w * extraLight));// *0.8;
	vec4 lig1 = vec4(lightDiffuse[1].rgb, min(1.0, lightDiffuse[1].w * extraLight));// *0.8;
	vec4 lig2 = vec4(lightDiffuse[2].rgb, min(1.0, lightDiffuse[2].w * extraLight));// *0.8;
	vec4 lig3 = vec4(lightDiffuse[3].rgb, min(1.0, lightDiffuse[3].w * extraLight));// *0.8;
	
	#IFDEF normalmap
		vec3 bump = texture2D(normalTex, gl_TexCoord[0].st).xyz;
		float totOcc = (lightDiffuse[0].w+lightDiffuse[1].w+lightDiffuse[2].w+lightDiffuse[3].w)*0.36;
		vec4 lightedColor = vec4(calculateLight( lightPos, shininess, specular, tex, vec4(0.0,0.0,0.0,totOcc), gl_TexCoord[0].xy, bump),1.0);
		lightedColor += vec4(calculateLight( lightVec[0], shininess, specular, tex, lig0, gl_TexCoord[0].xy, bump),1.0);
		lightedColor += vec4(calculateLight( lightVec[1], shininess, specular, tex, lig1, gl_TexCoord[0].xy, bump),1.0);
		lightedColor += vec4(calculateLight( lightVec[2], shininess, specular, tex, lig2, gl_TexCoord[0].xy, bump),1.0);
		lightedColor += vec4(calculateLight( lightVec[3], shininess, specular, tex, lig3, gl_TexCoord[0].xy, bump),1.0);
	#ELSE
		float totOcc = (lightDiffuse[0].w+lightDiffuse[1].w+lightDiffuse[2].w+lightDiffuse[3].w)*0.36;
		vec4 lightedColor = vec4(calculateLight( lightPos, shininess, specular, tex, vec4(0.0,0.0,0.0,totOcc), gl_TexCoord[0].xy),1.0);
		lightedColor += vec4(calculateLight( lightVec[0], shininess, specular, tex, lig0	, gl_TexCoord[0].xy),1.0);
		lightedColor += vec4(calculateLight( lightVec[1], shininess, specular, tex, lig1, gl_TexCoord[0].xy),1.0);
		lightedColor += vec4(calculateLight( lightVec[2], shininess, specular, tex, lig2, gl_TexCoord[0].xy),1.0);
		lightedColor += vec4(calculateLight( lightVec[3], shininess, specular, tex, lig3, gl_TexCoord[0].xy),1.0);
	#ENDIF
	
	
	
	lightedColor *= 0.2; //normalize
	
	
	
	gl_FragColor = lightedColor;
	gl_FragColor.a = tex.a;
	
	#IFDEF shadow
		float shadow_coef = totOcc*(1.0-shadowCoef());
		//shadow_coef += occLight;
		gl_FragColor.rgb *=  min(1.0, ((1.0-shadow_coef)+0.17))*1.2;
	#ENDIF
	
	if(emissiveOn){
		float emissive = texture2D(emissiveTex, gl_TexCoord[0].st).r;
		gl_FragColor.rgb = max(emissive*tex.rgb, lightedColor.rgb);
	}
}