




	uniform vec3 specular = vec3(0.45,0.45,0.45);
	uniform vec4 zo = vec4(0.0, 0.0, 0.0, 1.0);
	uniform vec3 daa =  vec3(1.4,1.4,1.4);
	uniform vec3 dsa = vec3(2.20,2.20,1.60);
	uniform vec3 ambient = vec3(0.45,0.45,0.45);
	uniform vec3 diffuse = vec3(1.0,1.0,1.0);

vec3 vertexLightFunc(vec3 normalVec, vec3 lightDirection, vec3 vPos, vec3 viewDirection, vec4 occlusionVec){

	
	
	
	
	vec3 normalDirection = normalize(normalVec);
	
	
	vec3 norm = normalDirection;
	
	
	
	
	#IFDEF singledraw
		vec3 viewDir = normalize( -vPos.xyz);
		vec3 lightDir = normalize( vPos.xyz);
		vec3 textu = vec3(1.0,1.0,1.0);
		float shininess = 32.0;
		float specPower = 1.0;
    	float sunOcclusionStrength = 3.1; //since usually half the rays miss on average on a flat wall
		float sunOcclusion = occlusionVec.w  * sunOcclusionStrength;
	#ELSE
		vec3 viewDir = normalize( -vPos.xyz);
		vec3 lightDir = normalize(gl_LightSource[0].position.xyz - vPos.xyz);
		vec3 textu = vec3(1.0,1.0,1.0);
		float shininess = 32.0;
		float specPower = 1.0;
		float sunOcclusionStrength = 1.1; //since usually half the rays miss on average on a flat wall
		float sunOcclusion = occlusionVec.w  * sunOcclusionStrength;
	#ENDIF
	
	
	vec3 color = textu.rgb; //use this for equal colored: vec3(0.5,0.5,0.5);
    // Ambient
    float staticAmbient = 0.05;
    float occStrength = 0.2;
    float diffuseStrength = 1.3; //color that is shined on by the sun
    float blockLightSourceItensity = 1.0;
   
   
    
    vec3 ambient = ((blockLightSourceItensity*occlusionVec.rgb*color.rgb)) + (staticAmbient*color.rgb) + (occStrength*sunOcclusion *color.rgb );
 	
 	float diff = min(1.0, max(dot(norm, lightDir), 0.0) * diffuseStrength);
   
    vec3 diffuse = diff * color * sunOcclusion;
	
  	
  	
  	vec3 reflectDir = normalize(-reflect(lightDir, norm));
    float spec = 0.0;
  	
  	//vec3 halfwayDir = normalize(lightDir + viewDir);  
    spec = pow(max(dot(reflectDir, viewDir), 0.0), shininess); //shininess
  	
  	float totSpec = specPower * spec * sunOcclusion;
	vec3 specular = vec3(totSpec)*0.3 + totSpec*0.7*color; // assuming bright white light color
	specular.r *= 1.0;
	specular.g *= 0.95;
	specular.b *= 0.85;
    
	return vec3(ambient + diffuse + specular);
}



