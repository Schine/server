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

uniform int animationTime;

#IFDEF INTATT
	attribute ivec4 ivert;
#ENDIF


uniform vec3 normals[7];
uniform vec3 tangents[7];
uniform vec3 binormals[7];

uniform vec3 shift;
uniform vec3 quadPosMark[6];
uniform vec3 texOrder[12];

const float tiling = 0.0625;
const float tilingH = 0.03;
const float adi = 0.00485;


void main()
{

	vec4 vPos;
	
	#IMPORT data/shader/cube/quads13/cubeEncoding.glsl
	
	
	float type = typeE;

	vec2 texCoords;
	
	float mVertNumQuarters = (vertNumCodeE) * 0.25;
	float mTex = (extFlag) * 0.25;
	
	
	
	if(!onlyInBuildMode){
		type += animatedE * animationTime;
	}
	
	#IFDEF shader4
		int typeI = int(type); 
		float xIndex = typeI & 15;
		float yIndex = typeI >> 4; // / 16.0
	#ELSE
		float xIndex = mod(type, 16.0);
		float yIndex = floor(type * 0.0625 ); // / 16.0
	#ENDIF
	
	
	#IFDEF shader4
		 //8,8,8 = 8736
		 
		vec3 cubePos = vec3(	float((int(vIndex) ) & 31), 
						float((int(vIndex) >> 5) & 31),
						float((int(vIndex) >> 10) & 31));
	#ELSE
		 //8,8,8 = 8736
		float z = floor(vIndex / 1024.0); 
		vIndex -= z * 1024.0;
		float y = floor(vIndex * 0.03125); //div by 32
		vIndex -= y * 32.0;
		float x = vIndex;
		
		vec3 cubePos = vec3(x,y,z);
	#ENDIF
	
	vec3 vertexPos = cubePos - 16.0; 
	
	#IFDEF shader4
	vec2 quad = vec2(
			float(int(mTex * 2.0) & 1), 
			float(int(mTex * 4.0) & 1)
			);
	//either 0,0; 0,1; 1,1; 1,0
	#ELSE
	vec2 quad = vec2(
			mod(floor(mTex * (2.0)), 2.0), 
			mod(floor(mTex * (4.0)), 2.0)
			);
	//either 0,0; 0,1; 1,1; 1,0
	#ENDIF
	
	#IFDEF virtual
		quadVar = quad;
	#ENDIF
	
	float eleVertEdge = (eleEV*0.25);
	
	#IFDEF shader4
	
	
	
	vec3 mm = vec3(float(int(mVertNumQuarters * qpm.x) & 1),
		float(int(mVertNumQuarters * qpm.y) & 1),
		float(int(mVertNumQuarters * qpm.z) & 1));
	
	
	#ELSE
	
	vec3 mm = vec3(mod(floor(mVertNumQuarters * qpm.x), 2.0),
		mod(floor(mVertNumQuarters * qpm.y), 2.0),
		mod(floor(mVertNumQuarters * qpm.z), 2.0));
	
	
	#ENDIF
	
	
	vec3 mExtra = vec3(
				(((qpm.x == 4.0 && xyScaleManip > 0.5) || (qpm.x == 2.0 && xyScaleManip < 0.5)) ? eleVertEdge * (mm.x > 0.0 ? 1.0 : -1.0) : 0.0),
				(((qpm.y == 4.0 && xyScaleManip > 0.5) || (qpm.y == 2.0 && xyScaleManip < 0.5)) ? eleVertEdge * (mm.y > 0.0 ? 1.0 : -1.0) : 0.0),
				(((qpm.z == 4.0 && xyScaleManip > 0.5) || (qpm.z == 2.0 && xyScaleManip < 0.5)) ? eleVertEdge * (mm.z > 0.0 ? 1.0 : -1.0) : 0.0));
		
	
	vec3 P = vec3(	((((-0.5) - (abs(normalPos.x) * -0.5)))  + mm.x - mExtra.x) ,
					((((-0.5) - (abs(normalPos.y) * -0.5)))  + mm.y - mExtra.y) ,
					((((-0.5) - (abs(normalPos.z) * -0.5)))  + mm.z - mExtra.z) );
	
	vertexPos += P + ((normalPos * 0.5) - (eleE * normalPos * 0.25));	
	
	
	vertexPos += ((chunkPos - vec3(128.0)) + shift)*32.0;
	
	vPos = gl_ModelViewMatrix * vec4(vertexPos,1.0); 
	
	float adiNorm = adi;
	
	vec2 adip = vec2(
	((1.0 -((quad.x)*adiNorm)) + (abs(quad.x - 1.0)*adiNorm)), 
	((1.0 -((quad.y)*adiNorm)) + (abs(quad.y - 1.0)*adiNorm)));

	texCoords = vec2(quad.x *tiling, quad.y *tiling );

	
	
	vec2 vcord = vec2(texCoords);
	
	gl_TexCoord[0].st = quad;
	
	
	
	gl_Position =  gl_ProjectionMatrix * vPos;
	
	
	
	
	
	
	

	
}

