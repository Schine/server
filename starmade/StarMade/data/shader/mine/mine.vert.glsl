#version 120


varying vec4 diffuse,ambientGlobal, ambient, ecPos, vPos;
varying vec3 normal,halfVector;
varying vec3 lightDirSpot;
varying vec3 viewDirection;
varying float spotAtt;


void main()
{


	vPos = gl_Vertex;
	vec4 normalN = vec4(gl_Normal.x, gl_Normal.y, gl_Normal.z, 1);
	
	vec3 aux;
     
    /* first transform the normal into eye space and normalize the result */
    normal = normalize(gl_NormalMatrix * gl_Normal);
 
    /* compute the vertex position  in camera space. */
    ecPos = gl_ModelViewMatrix * vPos;
 
    /* Normalize the halfVector to pass it to the fragment shader */
    halfVector = gl_LightSource[0].halfVector.xyz;
     
    /* Compute the diffuse, ambient and globalAmbient terms */
    diffuse = vec4(0.8);//gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse;
    ambient = vec4(0.13);//gl_FrontMaterial.ambient * gl_LightSource[0].ambient;
    ambientGlobal = vec4(0.1);//gl_LightModel.ambient * gl_FrontMaterial.ambient;
	
	vPos = ecPos;
	
	
	viewDirection = -vPos.xyz;
	
	lightDirSpot =  gl_LightSource[1].position.xyz - (vPos).xyz;
	
	float d = length(lightDirSpot);
	
	spotAtt = min(1.0, 1.0 / ( gl_LightSource[1].constantAttenuation + 
	(gl_LightSource[1].linearAttenuation*d) + 
	(0.02*d*d) ));
//	(gl_LightSource[1].quadraticAttenuation*d*d) ));
	
	gl_Position =  gl_ProjectionMatrix * vPos;
   
    gl_TexCoord[0] = gl_MultiTexCoord0;
}