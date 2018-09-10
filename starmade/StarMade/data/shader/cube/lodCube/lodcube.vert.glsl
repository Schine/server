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


varying vec3 normal;

varying vec3 viewDirection;

varying vec3 lightDir;





#IFDEF force130

out vec4 vPos;
out vec3 vertexPos;

flat out vec3 normalVec;
flat out vec3 binormalVec;
flat out vec3 tangentVec;

#ELSE
varying vec4 vPos;
varying vec3 normalVec;
varying vec3 tangentVec;
varying vec3 binormalVec;
varying vec3 vertexPos;
#ENDIF


void main()
{
	
	
	normal = gl_Normal.xyz;
	
	#IFDEF owntangent
		tangentVec = gl_NormalMatrix *gl_Color.xyz;
		binormalVec = gl_NormalMatrix *normalize(cross(gl_Normal.xyz, gl_Color.xyz));
	#ENDIF
	
	
	
	lightDir = normalize(gl_LightSource[0].position.xyz);
	gl_TexCoord[0].st = gl_MultiTexCoord0.st ;
	vertexPos = gl_Vertex.xyz;
	vPos = gl_ModelViewMatrix * gl_Vertex;//vec4(vertexPos,1.0); 
	normalVec = gl_NormalMatrix * normal;
	viewDirection = normalize(gl_ModelViewProjectionMatrix[3].xyz - vPos.xyz);
	gl_Position =  gl_ProjectionMatrix * vPos;
}