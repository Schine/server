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

const float tiling = 0.0625;
const float adi = 0.00485;

uniform float innerTexId;
varying float layer;
varying vec3 normal;

varying vec3 viewDirection;
varying vec3 lightDir;

varying float noLight;
varying float lifeTimeAlpha;



#IFDEF force130

out vec4 vPos;
out vec3 vertexPos;
flat out vec3 normalVec;

#ELSE
varying vec3 vertexPos;
varying vec4 vPos;
varying vec3 normalVec;
#ENDIF

void main()
{
	
	
	float texIndex = gl_Color.x;
	lifeTimeAlpha = gl_Color.y;
	normal = gl_Normal.xyz;
	lightDir = normalize(gl_LightSource[0].position.xyz);
	
	//decode the side (crude but very practical)
	if(!(
		abs(gl_Normal.x-1.0) < 0.0001 && abs(gl_Normal.y) < 0.0001 && abs(gl_Normal.z) < 0.0001 ||
		abs(gl_Normal.x+1.0) < 0.0001 && abs(gl_Normal.y) < 0.0001 && abs(gl_Normal.z) < 0.0001 ||
		abs(gl_Normal.x) < 0.0001 && abs(gl_Normal.y-1.0) < 0.0001 && abs(gl_Normal.z) < 0.0001 ||
		abs(gl_Normal.x) < 0.0001 && abs(gl_Normal.y+1.0) < 0.0001 && abs(gl_Normal.z) < 0.0001 ||
		abs(gl_Normal.x) < 0.0001 && abs(gl_Normal.y) < 0.0001 && abs(gl_Normal.z-1.0) < 0.0001 ||
		abs(gl_Normal.x) < 0.0001 && abs(gl_Normal.y) < 0.0001 && abs(gl_Normal.z+1.0) < 0.0001 
		)
		){
		//use inner texture if normal is not aligned with any side
		texIndex = innerTexId; //LAVA
		noLight = 0.0;
	}else{
		noLight = 0.0;
	}
	
	float type = mod(texIndex, 256.0);
	
	layer = floor(texIndex/256.0);
	
	float xIndex = mod(type, 16.0);
	float yIndex = floor(type * 0.0625 ); // / 16.0
	vec2 adip = vec2(
	((1.0 -((gl_MultiTexCoord0.x)*adi)) + (abs(gl_MultiTexCoord0.x - 1.0)*adi)), 
	((1.0 -((gl_MultiTexCoord0.y)*adi)) + (abs(gl_MultiTexCoord0.y - 1.0)*adi)));
	
	gl_TexCoord[0].xy = vec2( gl_MultiTexCoord0.x * tiling + tiling * xIndex, gl_MultiTexCoord0.y * tiling + tiling * yIndex);
	
	gl_TexCoord[0].xy += adip;
	
	vertexPos = gl_Vertex.xyz;
	vPos = gl_ModelViewMatrix * gl_Vertex;//vec4(vertexPos,1.0); 
	normalVec = gl_NormalMatrix * normal;
	viewDirection = normalize(gl_ModelViewProjectionMatrix[3].xyz - vPos.xyz);
	gl_Position =  gl_ProjectionMatrix * vPos;
}