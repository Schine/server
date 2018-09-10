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


#IFDEF INTATT
	attribute ivec4 ivert;
#ENDIF

uniform vec3 normals[7];
uniform vec3 tangents[7];
uniform vec3 binormals[7];



#IMPORT data/shader/cube/cubeLightPerVertex.glsl

uniform vec3 shift;
uniform vec3 quadPosMark[6];
const float tiling = 0.0625;
const float tilingH = 0.03;
const float adi = 0.00485;
const float maxadiplus = 0.0119;
const float oreOverlayStartingRow = 1.0;
const float extendedTextureArea = 4.0; 
uniform float lodThreshold;
uniform int animationTime;
uniform int allLight;




#IFDEF INTATT
varying vec3 blockLDir;
#ENDIF

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



#IFDEF intel130
flat out int layer;
flat out  float extraAlphaVert;

out vec4 vPos;
out vec3 vertexPos;

out vec3 vertexLight;
out vec4 occlusion;

varying vec3 normalVec;
varying vec3 binormalVec;
varying vec3 tangentVec;


#ELSEIF force130
flat out int layer;
flat out  float extraAlphaVert;

out vec4 vPos;
out vec3 vertexPos;

out vec3 vertexLight;
out vec4 occlusion;

flat out vec3 normalVec;
flat out vec3 binormalVec;
flat out vec3 tangentVec;

#ELSE
varying float layer;
varying float extraAlphaVert;

varying vec4 vPos;
varying vec3 vertexLight;
varying vec4 occlusion;


varying vec3 normalVec;
varying vec3 binormalVec;
varying vec3 tangentVec;
varying vec3 vertexPos;
#ENDIF

/*
void colorSide(float side){
	if(side == 0.0){
	//left
		light = vec4(1.0, 0.0, 0.0,   1.0);
	}else if(side == 1.0){
	//right
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


vec4 fromtwovectors(vec3 uu, vec3 vv)
{
    vec3 w = cross(uu.xyz, vv.xyz).xyz;
    vec4 q = vec4(dot(uu, vv), w.x, w.y, w.z);
   
    float l = w.x*w.x + w.y*w.y + w.z*w.z;//sqlength(w);
    
    q.w += sqrt(q.w*q.w+l);
    
    return q*(1.0/sqrt(q.w*q.w+l));
}
vec4 slerp4(vec4 p0, vec4 p1, float t)
{
  float dotp = dot(normalize(p0), normalize(p1));
  if ((dotp > 0.9999) || (dotp<-0.9999))
  {
    if (t<=0.5)
      return p0;
    return p1;
  }
  float theta = acos(dotp * 3.14159/180.0);
  vec4 P = ((p0*sin((1-t)*theta) + p1*sin(t*theta)) / sin(theta));
  P.w = 1.0;
  return P;
}
vec3 slerp(vec3 a, vec3 b, float t)
{
	 vec4 qa = vec4(0.0,0.0,0.0,1.0);
	 vec4 qb;
	 //qa = Quaternionf::Identity();
	 qb = fromtwovectors(a,b); 
	return (slerp4(qa, qb, t)).xyz;  // * a ?
}

void main()
{

	#IMPORT data/shader/cube/quads13/cubeEncoding.glsl

	
	float type = typeE;

	vec2 texCoords;
	
	
	float mVertNumQuarters = (vertNumCodeE) * 0.25;
	float mTex = (extFlag) * 0.25;
	
	
	#IFDEF lightall
	if(allLight > 1){
		occlusion =  vec4(0.6,0.6,0.6, 0.7);
		noLight = 1.0;
	}else{
		occlusion = vec4(red * 0.03225, green * 0.03225, blue * 0.03225, occE * 0.03225); // / 15
		noLight = 0.0;
	}
	#ELSE
		occlusion = vec4(red * 0.03225, green * 0.03225, blue * 0.03225, occE * 0.03225); // / 15
	#ENDIF
	
	#IFDEF force130
	layer = int(layerE);
	#ELSEIF shader4
	layer = int(layerE);
	#ELSE
	layer = layerE;
	#ENDIF
	
	
	
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
	
	#IFDEF chunk16
		vertexPos = cubePos - 8.0; 
	#ELSE
		vertexPos = cubePos - 16.0; 
	#ENDIF
	
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
	
	
	#IFDEF INTATT
//		blockLDir = gl_NormalMatrix * normalize(blockLightDir);
//		blockLDir = normalize(blockLightDir);
		
//		blockLDir = (gl_ModelViewMatrix * vec4(normalize(blockLightDir), 1.0)).xyz;
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
	
	#IFDEF singledraw
		float adiNorm = adi;
	#ELSE
		float adiNorm = adi + maxadiplus * min(1.0, pow(max(0.0, (length(vPos) - 60.0)*0.003),2.1));
	#ENDIF
	
	vec2 adip = vec2(
	((1.0 -((quad.x)*adiNorm)) + (abs(quad.x - 1.0)*adiNorm)), 
	((1.0 -((quad.y)*adiNorm)) + (abs(quad.y - 1.0)*adiNorm)));

	
	
	if(extendedTexture){
		
		if(abs(normal.y) > 0.0){ 
			texCoords = vec2((mod(cubePos.x, extendedTextureArea))*tiling + quad.x *tiling , (3.0-mod(cubePos.z, extendedTextureArea))*tiling + quad.y *tiling);
		}else if(abs(normal.x) > 0.0){ 
			texCoords = vec2((3.0-mod(cubePos.z, extendedTextureArea))*tiling + quad.x *tiling , (3.0-mod(cubePos.y, extendedTextureArea))*tiling + quad.y *tiling);
		}else{
			texCoords = vec2((mod(cubePos.x, extendedTextureArea))*tiling + quad.x *tiling , (3.0-mod(cubePos.y, extendedTextureArea))*tiling + quad.y *tiling);
		}
		 
		
	}else{
		texCoords = vec2(quad.x *tiling, quad.y *tiling );
	}
	
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
	vec3 lightDir = normalize(gl_LightSource[0].position.xyz);
	
	normalVec = normalize(gl_NormalMatrix * normal);
	binormalVec = normalize(gl_NormalMatrix * binormal);
	tangentVec = normalize(gl_NormalMatrix * tangent);
	vec3 viewDirection = -vPos.xyz;
	
	//handle the special transparent texture (dispaly in build mode)
	#IFDEF lightall
		extraAlphaVert = 0.0;
	#ELSE
		
		if(onlyInBuildMode && animatedE < 0.001){
			extraAlphaVert = -10.0;
		}else{
			extraAlphaVert = 0.0;
		}
	#ENDIF
	
	float ts = lodThreshold;
	float smoother = ts * 0.125; //one eight of distance is smoothing
	if(onlyInBuildMode && animatedE > 0.0 ){ 
		float len = length(vPos.xyz);
		if(len < ts-smoother){
			extraAlphaVert = -10.0;
		}else if(len < ts){
			float dist = (ts - length(vPos.xyz));
			extraAlphaVert = -dist/smoother;//-((ts)-length(vPos)) * 0.0625 ;
		}else{
			extraAlphaVert = 0.0;
		}
	}
	
	vertexLight = vertexLightFunc(normalVec, lightDir, vPos.xyz,  viewDirection, occlusion);
	#IFDEF vertexLighting
		//vertexLight = vertexLightFunc(normalVec, lightDir, vPos.xyz,  viewDirection, occlusion);
	#ELSEIF lightall
		//vertexLight = vertexLightFunc(normalVec, lightDir, vPos.xyz,  viewDirection, occlusion);
	#ENDIF
	gl_Position =  gl_ProjectionMatrix * vPos;
	
	
}
