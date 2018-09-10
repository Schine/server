#version 120
#IFDEF shader4
#extension GL_EXT_gpu_shader4: enable
#ENDIF



#IFDEF threeComp
//threcomp needs index 0 to be 0
uniform vec3 normals[7];
#ELSE
uniform vec3 normals[6];
#ENDIF



#IMPORT data/shader/cube/cubeLightPerVertex.glsl

uniform vec3 shift;
uniform vec3 quadPosMark[6];
const float tiling = 0.0625;
const float tilingH = 0.03;
const float adi = 0.00485;
const float maxadiplus = 0.0099;
const float oreOverlayStartingRow = 1.0;
uniform int animationTime;
uniform int allLight;



varying vec4 occlusion;
varying vec3 lightDir;
varying vec3 viewDirection;
varying vec4 vPos;
varying vec3 normalVec;
varying float extraAlphaVert;
varying vec3 vertexLight;

#IFDEF virtual
	varying vec2 quadVar;
#ENDIF

#IFDEF nospotlights
#ELSEIF vertexLighting
#ELSE 
varying vec3 lightDirSpot;
#ENDIF 

#IFDEF lightall
varying float noLight;
#ENDIF
varying float layer;



/*
void colorSide(float side){
	if(side == 0.0){
	//front
		light = vec4(1.0, 0.0, 0.0,   1.0);
	}else if(side == 1.0){
	//back
		light = vec4(0.0, 1.0, 0.0,   1.0);
	}else if(side == 2.0){
	//top
		//light = vec4(0.0, 0.0, 1.0,   1.0);
	}else if(side == 3.0){
	//bot
		//light = vec4(1.0, 1.0, 0.0,   1.0);
	}else if(side == 4.0){
	//right
		light = vec4(0.0, 0.0, 1.0,   1.0);
	}else if(side == 5.0){
	//left
		light = vec4(0.0, 1.0, 1.0,   1.0);
	} 
	
}
*/
void main()
{

	float xyScaleManip = 0.0;
	
	vec3 normal;
	#IFDEF shader4
	
	int indexInfo = int(gl_Vertex.x);
	
	float vIndex = float((indexInfo ) & 4095);
	
	float red =  float((indexInfo >> 12) & 15);
	
	float green =  float((indexInfo >> 16) & 15);
	
	float blue =  float((indexInfo >> 20) & 15);
	
	
	
	int info = int(gl_Vertex.y);
	
	float vertNumCodeE = float(info & 3);
	
	int sideId =  (info >> 2) & 7; 
	
	float layerE =  float((info >> 5) & 7);

	xyScaleManip =  float((info >> 8) & 1);
	
	float typeE =  float((info >> 9) & 255) ;
	
	float hitPointsE =  float((info >> 17) & 7) ;
	
	float animatedE = float((info >> 20) & 1);
	
	float extFlag =  float(info >> 21);
	
	
	int normalIndex = sideId;
	vec3 qpm = quadPosMark[normalIndex];
	
	
	#ELSE


	float colorInfoX = gl_Vertex.x;
	
	
	float blue =  floor(colorInfoX / 1048576.0);
	colorInfoX -= blue * 1048576.0;
	
	float green =  floor(colorInfoX / 65536.0);
	colorInfoX -= green * 65536.0;
	
	float red =  floor(colorInfoX / 4096.0);
	colorInfoX -= red * 4096.0;
	
	float vIndex = floor(colorInfoX);
	

	float texInfoY = gl_Vertex.y;
	
	float extFlag =  floor(texInfoY / 2097152.0);
	texInfoY -= extFlag * 2097152.0;
	
	float animatedE =  floor(texInfoY / 1048576.0);
	texInfoY -= animatedE * 1048576.0;
	
	float hitPointsE =  floor(texInfoY / 131072.0) ;
	texInfoY -= hitPointsE * 131072.0;
	
	float typeE =  floor(texInfoY / 512.0) ;
	texInfoY -= typeE * 512.0;
	
	
	xyScaleManip =  (floor(texInfoY / 256.0)); // /16.0
	texInfoY -= xyScaleManip * 256.0;
	
	float layerE =  floor(texInfoY * 0.03125) ; // / 32.0
	texInfoY -= layerE * 32.0;
	
	
	
	float sideId =  (floor(texInfoY * 0.25)); // /4.0
	texInfoY -= sideId * 4.0;
	
	float vertNumCodeE = (floor(texInfoY));
	
	int normalIndex = int(sideId);
	vec3 qpm = quadPosMark[normalIndex];
	
	#ENDIF
	
	vec3 chunkPos;
	
	
	
	float oreOverlayE = 0.0;
	float occE = 0.0;
	float eleE = 0.0;
	float eleEV = 0.0;
	#IFDEF shader4
		int pCode = int(gl_Vertex.z);
		chunkPos = vec3(float(pCode & 255), float((pCode >> 8) & 255), float((pCode >> 16) & 255));
		
		int eInfoW = int(gl_Vertex.w);
		
		
		eleEV =  (eInfoW >> 22) & 3 ;
		
		eleE =  (eInfoW >> 20) & 3 ;
		
		occE = (eInfoW >> 16) & 15; 
		
		oreOverlayE =  (eInfoW >> 10) & 63;
		
		vec3 normalPos = normals[normalIndex+1];
		
		if((eInfoW & 511) == 0){
			normal = normalPos;
		}else{
			vec3 com = normals[(eInfoW >> 6) & 7]  + normals[(eInfoW >> 3) & 7] + normals[eInfoW & 7];
			normal = normalize(com);
		}
	
	#ELSEIF threeComp
	
		
		float posInfoZ = gl_Vertex.z;
		
		float zPos = floor(posInfoZ / 65536.0); 
		posInfoZ = posInfoZ - (zPos * 65536.0);
		float yPos = floor(posInfoZ * 0.00390625); //divided by 256 
		float xPos = ( posInfoZ - (yPos * 256)); 
		
		chunkPos = vec3(xPos, yPos, zPos);
		
		float sInfoW = gl_Vertex.w;
		
		eleEV =  floor(sInfoW / 4194304.0) ;

		sInfoW -= eleEV * 4194304.0;
		
		eleE =  floor(sInfoW / 1048576.0) ;
		
		sInfoW -= eleE * 1048576.0;
		
		occE =  floor(sInfoW / 65536.0) ; //32768.0, 65536.0, 131072.0, 262144.0
		
		sInfoW -= occE * 65536.0;
		
		oreOverlayE =  floor(sInfoW / 1024.0) ;
		
		sInfoW -= oreOverlayE * 1024.0;
		
		
		float normalModeE =  sInfoW;
		
		
		
		vec3 normalPos = normals[normalIndex+1];
		
		if(normalModeE == 0.0){
			normal = normalPos;
		}else{
			float nAf = (floor(normalModeE * 0.015625)); // div by 64.0
			normalModeE -= nAf*64.0;
			
			float nBf = (floor(normalModeE * 0.125)); // div by 8.0
			normalModeE -= nBf*8.0;
			
			float nCf = normalModeE; 
			
			vec3 com = normals[int(nAf)]  + normals[int(nBf)] + normals[int(nCf)];
			normal = normalize(com);
		}
		
	#ELSE
		vec3 normalPos = normals[normalIndex];
		normal = normalPos;
	
	#ENDIF

	
	float type = typeE;

	vec2 texCoords;
	
	
	float mVertNumQuarters = (vertNumCodeE) * 0.25;
	float mTex = (extFlag) * 0.25;
	
	
	#IFDEF lightall
	if(allLight > 1){
		occlusion =  vec4(0.6,0.6,0.6, 0.7);
		noLight = 1.0;
	}else{
		occlusion = vec4(red * 0.066666, green * 0.066666, blue * 0.066666, occE * 0.066666); // / 15
		noLight = 0.0;
	}
	#ELSE
	occlusion = vec4(red * 0.066666, green * 0.066666, blue * 0.066666, occE * 0.066666); // / 15
	#ENDIF
	
	occlusion.w = max(0.15, occlusion.w);
	
	layer = layerE;		
	
	
	
	type += animatedE * animationTime;
	
	
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
		vec3 cubePos = vec3(	float((int(vIndex) ) & 15), 
						float((int(vIndex) >> 4) & 15),
						float((int(vIndex) >> 8) & 15));
	#ELSE
		 //8,8,8 = 8736
		float z = floor(vIndex * 0.00390625); //divided by 256
		vIndex -= z * 256.0;
		float y = floor(vIndex * 0.0625);
		vIndex -= y * 16.0;
		float x = vIndex;
		
		vec3 cubePos = vec3(x,y,z);
	#ENDIF
	
	vec3 vertexPos = cubePos - 8.0;
	
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
	
	#IFDEF threeComp
		vertexPos += ((chunkPos - vec3(128.0)) + shift)*16.0;
	#ENDIF
	vPos = gl_ModelViewMatrix * vec4(vertexPos,1.0); 
	
	float adiNorm = adi;// + maxadiplus * min(1.0, (max(0.0, length(vPos) - 60.0)*0.065));
	vec2 adip = vec2(
	((1.0 -((quad.x)*adiNorm)) + (abs(quad.x - 1.0)*adiNorm)), 
	((1.0 -((quad.y)*adiNorm)) + (abs(quad.y - 1.0)*adiNorm)));

	texCoords = vec2(quad.x *tiling, quad.y *tiling );

	
	
	vec2 vcord = vec2(texCoords);
	
	if(oreOverlayE > 0.0){
		gl_TexCoord[2].st = vec2(vcord.x + 0.0625 * mod((oreOverlayE - 1.0), 16.0), vcord.y + 0.0625 * (oreOverlayStartingRow + floor((oreOverlayE-1.0) * 0.0625))); //floor(oreOverlayE/16);
	}else{
		gl_TexCoord[2].st = vec2(0.9);
	}
	if(hitPointsE > 0.0){
		gl_TexCoord[1].st = vec2(vcord.x + 0.0625 * (hitPointsE - 1.0), vcord.y); //hit ovelays are in the first row
	}else{
		gl_TexCoord[1].st = vec2(0.9);
	}
	
	
	gl_TexCoord[0].st = vec2( texCoords.x + tiling * xIndex, texCoords.y + tiling * yIndex);


	
	
	gl_TexCoord[0].st += adip;
	gl_TexCoord[1].st += adip;
	gl_TexCoord[2].st += adip;
	
	//note: this is a directional light! 
	lightDir = normalize(gl_LightSource[0].position.xyz);
	
	#IFDEF nospotlights
	#ELSEIF vertexLighting
	#ELSE
	
	#ENDIF 

	
	normalVec = normalize(gl_NormalMatrix * normal);
	viewDirection = -vPos.xyz;
	
	//handle the special transparent texture (dispaly in build mode)
	#IFDEF lightall
		if(abs(479.0 - (typeE + (layerE * 256.0))) < 0.00001 ){
			extraAlphaVert = 0.5f;
		}else{
			extraAlphaVert = 0.0;
		}
		
	#ELSE
		extraAlphaVert = 0.0;
	#ENDIF
	
	vertexLight = vertexLightFunc(normalVec, lightDir, vPos.xyz,  viewDirection, occlusion);
	#IFDEF vertexLighting
		//vertexLight = vertexLightFunc(normalVec, lightDir, vPos.xyz,  viewDirection, occlusion);
	#ELSEIF lightall
		//vertexLight = vertexLightFunc(normalVec, lightDir, vPos.xyz,  viewDirection, occlusion);
	#ENDIF
	gl_Position =  gl_ProjectionMatrix * vPos;
	
	
}
