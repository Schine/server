#version 120

const int NUM_BONES = #NUM_BONES;

attribute vec4 indices;
attribute vec4 weights;
uniform mat4 m_BoneMatrices[NUM_BONES];

varying vec4 diffuse,ambientGlobal, ambient, ecPos, vPos;
varying vec3 normal,halfVector;
varying vec3 lightDirSpot;
varying vec3 viewDirection;
varying float spotAtt;

void skin(inout vec4 position, inout vec4 normal){
    vec4 index  = indices;
    vec4 weight = weights;

    vec4 newPos    = vec4(0.0);
    vec4 newNormal = vec4(0.0);

    for (float i = 0.0; i < 4.0; i += 1.0){
    
        mat4 skinMat = m_BoneMatrices[int(index.x)];
        newPos    += weight.x * (skinMat * position);
        newNormal += weight.x * (skinMat * normal);
        
        //rotate coordinates
        index = index.yzwx;
        weight = weight.yzwx;
    }

    position = newPos;
    normal = newNormal;
}

void main()
{


	vPos = gl_Vertex;
	vec4 normalN = vec4(gl_Normal.x, gl_Normal.y, gl_Normal.z, 1);
	
	skin(vPos, normalN);
	
	
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