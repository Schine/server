#version 120
#IFDEF shader4
#extension GL_EXT_gpu_shader4: enable
#ENDIF

/*
#IFDEF threeComp
//threcomp needs index 0 to be 0
uniform vec3 normals[7];
uniform vec3 tangents[7];
uniform vec3 binormals[7];
#ELSE
uniform vec3 normals[6];
#ENDIF

uniform vec3 quadPosMark[6];


void advCube(){
#IFDEF shader4
	
	int indexInfo = int(gl_Vertex.x);
	float vIndex = float((indexInfo ) & 4095);
	
	
	
	
	int info = int(gl_Vertex.y);
	
	float vertNumCodeE = float(info & 3);
	
	int sideId =  (info >> 2) & 7; // /4.0
	
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
	
	float layerE =  floor(texInfoY * 0.03125) ; // / 32.0
	texInfoY -= layerE * 32.0;
	
	float sideId =  (floor(texInfoY * 0.25)); // /4.0
	texInfoY -= sideId * 4.0;
	
	float vertNumCodeE = (floor(texInfoY));
	
	int normalIndex = int(sideId);
	vec3 qpm = quadPosMark[normalIndex];
	
	#ENDIF
	
	
	
	
	
	float oreOverlayE = 0.0;
	float occE = 0.0;
	
	#IFDEF threeComp
	
		float inside = 0.5;
		
		float posInfoZ = gl_Vertex.z;
		
		float zPos = floor(posInfoZ / 65536.0); 
		posInfoZ = posInfoZ - (zPos * 65536.0);
		float yPos = floor(posInfoZ * 0.00390625); //divided by 256 
		float xPos = ( posInfoZ - (yPos * 256)); 
		
		
		vec3 normalPos = normals[normalIndex+1];
		
		
	#ELSE
		float inside = 0.5;
		vec3 normalPos = normals[normalIndex];
	
	#ENDIF

	

	vec2 texCoords;
	
	float mVertNum = (vertNumCodeE) * 0.25;
	float mTex = (extFlag) * 0.25;
	
	
	
	
	
	
	
	
	
	
	
	 //8,8,8 = 8736
	float z = floor(vIndex * 0.00390625); //divided by 256
	vIndex -= z * 256.0;
	float y = floor(vIndex * 0.0625);
	vIndex -= y * 16.0;
	float x = vIndex;
	
	
	vec3 vertexPos = vec3(x-8.0, y-8.0, z-8.0);
	
	
	
	
	float xP = ((1.0 - abs(normalPos.x)) * -0.5) + mod(floor(mVertNum * qpm.x), 2.0);
	float yP = ((1.0 - abs(normalPos.y)) * -0.5) + mod(floor(mVertNum * qpm.y), 2.0);
	float zP = ((1.0 - abs(normalPos.z)) * -0.5) + mod(floor(mVertNum * qpm.z), 2.0);
	
	vertexPos += vec3(xP,yP,zP) + (normalPos * inside);	
	
	
	
	
	
	#IFDEF threeComp
		vertexPos.x += (xPos - 128.0) * 16.0;
		vertexPos.y += (yPos - 128.0) * 16.0;
		vertexPos.z += (zPos - 128.0) * 16.0;
	#ENDIF
	
	
	
	//note: this is a directional light! 

	vec4 vPos = gl_ModelViewMatrix * vec4(vertexPos,1.0); 


	
	gl_Position =  gl_ProjectionMatrix * vPos;
}
*/


void main()
{
	gl_Position =  ftransform();
}

