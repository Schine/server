#version 120

varying vec4 diffuse,ambient;
varying vec3 normal,lightDir,halfVector;

uniform float time;
void main()
	{
		vec3 n,halfV,viewV,ldir;
		float NdotL,NdotHV;
		vec4 color = ambient;
		
		float glow = 0.5 - abs(1.0 - time - gl_TexCoord[0].x);
		
		vec4 cEnd = vec4(0,pow(gl_TexCoord[0].x,10.0)*0.8,pow(1.0f-gl_TexCoord[0].x,10.0)*0.8,20.0);
		
		color -= 0.3;
		color.rg *= max(1.0,  pow(0.66+glow,16));
		
		/* a fragment shader can't write a verying variable, hence we need
		a new variable to store the normalized interpolated normal */
		n = normalize(normal);
		
		/* compute the dot product between normal and ldir */
		NdotL = max(dot(n,lightDir),0.0);
	
		if (NdotL > 0.0) {
			halfV = normalize(halfVector)*0.97;
			NdotHV = max(dot(n,halfV),0.0);
			color += gl_FrontMaterial.specular * gl_LightSource[0].specular * pow(NdotHV,gl_FrontMaterial.shininess);
			color += diffuse*NdotL*0.45;
		}
	
		
		
		gl_FragColor = color+cEnd;
	}
