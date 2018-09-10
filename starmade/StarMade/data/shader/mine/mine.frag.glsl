#version 120
#IFDEF shadow
#extension GL_EXT_gpu_shader4: enable
#ENDIF

uniform sampler2D diffuseMap;
uniform sampler2D emissiveMap;
uniform vec4 tint;

varying vec4 diffuse,ambientGlobal, ambient, ecPos, vPos;
varying vec3 normal,halfVector;
varying vec3 lightDirSpot;
varying float spotAtt;
varying vec3 viewDirection;

const float cos_outer_cone_angle = 0.95; // 36 degrees
#IMPORT data/shader/shadow.glsl


vec4 getLight()
{
    vec3 n,halfV,viewV,lightDir;
    float NdotL,NdotHV;
    vec4 color = ambientGlobal;
    float att, dist;
     
    /* a fragment shader can't write a verying variable, hence we need
    a new variable to store the normalized interpolated normal */
    n = normalize(normal);
     
    // Compute the ligt direction
    lightDir = vec3(gl_LightSource[0].position-ecPos);
     
    /* compute the distance to the light source to a varying variable*/
    dist = length(lightDir);
 
     
    /* compute the dot product between normal and ldir */
    NdotL = max(dot(n,normalize(lightDir)),0.0);
 
    if (NdotL > 0.0) {
     
        att = 1.0;
        //make sure not to devide by zero (causes brightness in specular)
        //att = 1.0 / (gl_LightSource[0].constantAttenuation +
                //gl_LightSource[0].linearAttenuation * dist +
                //gl_LightSource[0].quadraticAttenuation * dist * dist);
        color += att * (diffuse * NdotL + ambient);
     
         
        halfV = normalize(halfVector);
        NdotHV = max(dot(n,halfV),0.0);
        color += att * 0.4 * gl_LightSource[0].specular * pow(NdotHV, 16.0); //0.3 is material specukar, 8 is material shininess
    }
 
    return color;
}

vec3 spotLight (vec4 diffuse, vec2 tCords, vec3 lDir, float att, int lightIndex){


	vec3 normalDirection = normal;
	//vec3 viewDirection = normal;

	/*
	vec4 final_color =
	(gl_FrontLightModelProduct.sceneColor * gl_FrontMaterial.ambient) +
	(gl_LightSource[lightIndex].ambient * gl_FrontMaterial.ambient);
	*/
	vec4 final_color = vec4(0.0);//(gl_LightSource[lightIndex].ambient * 0.0) * att; //0.0 is ambient

	vec3 L = normalize(lDir);
	vec3 D = normalize(gl_LightSource[lightIndex].spotDirection);

	float cos_cur_angle = dot(-L, D);

	float cos_inner_cone_angle = 0.9;//gl_LightSource[lightIndex].spotCosCutoff;

	float cos_inner_minus_outer_angle = 
	      cos_inner_cone_angle - cos_outer_cone_angle;
	
	//****************************************************
	// Don't need dynamic branching at all, precompute 
	// falloff(i will call it spot)
	float spot = 0.0;
	spot = 1.0-clamp((cos_cur_angle - cos_outer_cone_angle) / 
	       cos_inner_minus_outer_angle, 0.0, 1.0);
	//****************************************************

	vec3 N = normalize(normalDirection);

	float lambertTerm = max( dot(N,L), 0.0);
	if(lambertTerm > 0.0)
	{
		/*final_color += gl_LightSource[lightIndex].diffuse *
			gl_FrontMaterial.diffuse *
			lambertTerm * spot;
		*/
		//final_color += gl_LightSource[lightIndex].diffuse * diffuse *
		//	lambertTerm * spot * att;
		final_color += vec4(0.5,0.5,0.5,1) * diffuse *
			lambertTerm * spot * att;
		

		vec3 E = normalize(viewDirection);
		vec3 R = reflect(-L, N);

		float specular = pow( max(dot(R, E), 0.0), 4.0); //8.0 is material specular

		/*final_color += gl_LightSource[lightIndex].specular *
			gl_FrontMaterial.specular *
			specular * spot;
		*/
		//final_color += gl_LightSource[lightIndex].specular *
		//	specular * spot * att;
		final_color += vec4(0.3,0.3,0.3,1) *
		 specular * spot * att;
	}
	return final_color.xyz;
}

void main()
{
    // diffuse material color
    float emission = length(texture2D(emissiveMap, gl_TexCoord[0].xy).rgb);
    vec4 clr = texture2D(diffuseMap, gl_TexCoord[0].xy);
    vec4 diffMaterial = clr;
	diffMaterial.rgb *= getLight().rgb + emission;
   

    // modulate specular ligh ting by fringe color, combine with regular lighting
    gl_FragColor = diffMaterial;
    
    
    #IFDEF shadow
	const float shadow_ambient = 0.9;
	float shadow_coef = min(1.0, shadowCoef()+emission);
	gl_FragColor.rgb *= min(1.0, (shadow_coef+0.17) * shadow_ambient);
	#ENDIF
	
	#IFDEF nospotlight
	#ELSE
	vec3 spot = spotLight( clr, gl_TexCoord[0].st, lightDirSpot, spotAtt, 1);
	gl_FragColor.rgb = clamp((gl_FragColor.rgb + spot), 0.0, 1.0);
	#ENDIF
	
	gl_FragColor *= tint;
	
	
}