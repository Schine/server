float xyScaleManip = 0.0;

vec3 normal;
vec3 binormal;
vec3 tangent;

vec3 chunkPos;

float oreOverlayE = 0.0;

float occE = 0.0;

float eleE = 0.0;

float eleEV = 0.0;

vec3 blockLightDir;
#IFDEF INTATT
	int indexInfo = ivert.x;
	
	float vIndex = float((indexInfo ) & 32767);
	
	float red =  float((indexInfo >> 16) & 31);
	
	float green =  float((indexInfo >> 21) & 31);
	
	float blue =  float((indexInfo >> 26) & 31);
	
	
#ELSEIF chunk16
	//old version to debug
	int indexInfo = int(gl_Vertex.x);
	
	float vIndex = float((indexInfo ) & 4095);

	float red =  float((indexInfo >> 12) & 15);
	
	float green =  float((indexInfo >> 16) & 15);
	
	float blue =  float((indexInfo >> 20) & 15);
#ELSEIF shader4
	int indexInfo = int(gl_Vertex.x);
	
	float vIndex = float((indexInfo ) & 32767);
	
	float red =  float((indexInfo >> 16) & 3) * 8.0;
	
	float green =  float((indexInfo >> 18) & 3) * 8.0;
	
	float blue =  float((indexInfo >> 20) & 3) * 8.0;
#ENDIF




#IFDEF INTATT
	int info = ivert.y;
	
	float vertNumCodeE = float(info & 3);
	
	int sideId =  (info >> 2) & 7; 
	
	float layerE =  float((info >> 5) & 7);

	xyScaleManip =  float((info >> 8) & 1);
	
	float typeE =  float((info >> 9) & 255) ;
	
	float hitPointsE =  float((info >> 17) & 7) ;
	
	float animatedE = float((info >> 20) & 1);
	
	float extFlag =  float((info >> 21) & 3);

	bool onlyInBuildMode =  float((info >> 23) & 1) > 0.0;
	
	bool extendedTexture = float((info >> 24) & 1) > 0.0;
	
	int normalIndex = sideId;
	vec3 qpm = quadPosMark[normalIndex];
#ELSEIF shader4

	int info = int(gl_Vertex.y);
	
	float vertNumCodeE = float(info & 3);
	
	int sideId =  (info >> 2) & 7; 
	
	float layerE =  float((info >> 5) & 7);

	xyScaleManip =  float((info >> 8) & 1);
	
	float typeE =  float((info >> 9) & 255) ;
	
	float hitPointsE =  float((info >> 17) & 7) ;
	
	float animatedE = float((info >> 20) & 1);
	
	float extFlag =  float((info >> 21) & 3);

	bool onlyInBuildMode =  float((info >> 23) & 1) > 0.0;
	
	bool extendedTexture = false; 
	
	int normalIndex = sideId;
	vec3 qpm = quadPosMark[normalIndex];


#ELSE


	float colorInfoX = gl_Vertex.x;
	
	
	float blue =  floor(colorInfoX / 1048576.0); // >> 20
	colorInfoX -= blue * 1048576.0;
	
	float green =  floor(colorInfoX / 262144.0); // >> 18
	colorInfoX -= green * 262144.0;
	
	float red =  floor(colorInfoX / 65536.0); // >> 16
	colorInfoX -= red * 65536.0;
	
	blue *= 8.0;
	green *= 8.0;
	red *= 8.0;
	
	float vIndex = floor(colorInfoX);
	

	float texInfoY = gl_Vertex.y;
	
	
	bool onlyInBuildMode =  floor(texInfoY / 8388608.0) > 0.0;
	if(onlyInBuildMode){
		texInfoY -= 8388608.0;
	}
	bool extendedTexture = false; 
	
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






#IFDEF INTATT
	int pCode = ivert.z;
	chunkPos = vec3(float(pCode & 255), float((pCode >> 8) & 255), float((pCode >> 16) & 255));
	
	int eInfoW = ivert.w;
	
	
	vec3 normalPos = normals[normalIndex+1];
	vec3 binormalPos = binormals[normalIndex+1];
	vec3 tangentPos = tangents[normalIndex+1];
	
	if((eInfoW & 511) == 0){
		normal = normalPos;
		binormal = binormalPos;
		tangent = tangentPos;
	}else{
		normal = normalize(normals[(eInfoW >> 6) & 7]  + normals[(eInfoW >> 3) & 7] + normals[eInfoW & 7]);
		binormal = normalize(binormals[(eInfoW >> 6) & 7]  + binormals[(eInfoW >> 3) & 7] + binormals[eInfoW & 7]);
		tangent = normalize(tangents[(eInfoW >> 6) & 7]  + tangents[(eInfoW >> 3) & 7] + tangents[eInfoW & 7]);
	}
	
	oreOverlayE =  float((eInfoW >> 9) & 63);
	
	occE = float((eInfoW >> 15) & 31); 
	
	eleE =  float((eInfoW >> 20) & 3) ;
	
	eleEV =  float((eInfoW >> 22) & 3) ;
	
	
	
	
#ELSEIF shader4
	int pCode = int(gl_Vertex.z);
	chunkPos = vec3(float(pCode & 255), float((pCode >> 8) & 255), float((pCode >> 16) & 255));
	
	int eInfoW = int(gl_Vertex.w);
	
	
	eleEV =  (eInfoW >> 22) & 3 ;
	
	eleE =  (eInfoW >> 20) & 3 ;
	
	occE = ((eInfoW >> 15) & 15); 
	
	oreOverlayE =  (eInfoW >> 9) & 63;
	
	vec3 normalPos = normals[normalIndex+1];
	vec3 binormalPos = binormals[normalIndex+1];
	vec3 tangentPos = tangents[normalIndex+1];
	
	if((eInfoW & 511) == 0){
		normal = normalPos;
		binormal = binormalPos;
		tangent = tangentPos;
	}else{
		normal = normalize(normals[(eInfoW >> 6) & 7]  + normals[(eInfoW >> 3) & 7] + normals[eInfoW & 7]);
		binormal = normalize(binormals[(eInfoW >> 6) & 7]  + binormals[(eInfoW >> 3) & 7] + binormals[eInfoW & 7]);
		tangent = normalize(tangents[(eInfoW >> 6) & 7]  + tangents[(eInfoW >> 3) & 7] + tangents[eInfoW & 7]);
	}
	
#ELSE
	
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
	
	occE =  floor(sInfoW / 32768.0) ; //32768.0, 65536.0, 131072.0, 262144.0
	
	sInfoW -= occE * 32768.0;
	
	oreOverlayE =  floor(sInfoW / 1024.0) ;
	
	sInfoW -= oreOverlayE * 1024.0;
	
	
	float normalModeE =  sInfoW;
	
	
	
	vec3 normalPos = normals[normalIndex+1];
	vec3 binormalPos = binormals[normalIndex+1];
	vec3 tangentPos = tangents[normalIndex+1];
	
	if(normalModeE == 0.0){
		normal = normalPos;
		binormal = binormalPos;
		tangent = tangentPos;
	}else{
		float nAf = (floor(normalModeE * 0.015625)); // div by 64.0
		normalModeE -= nAf*64.0;
		
		float nBf = (floor(normalModeE * 0.125)); // div by 8.0
		normalModeE -= nBf*8.0;
		
		float nCf = normalModeE; 
		
		normal = normalize(normals[int(nAf)]  + normals[int(nBf)] + normals[int(nCf)]);
		binormal = normalize(binormals[int(nAf)]  + binormals[int(nBf)] + binormals[int(nCf)]);
		tangent = tangents(normals[int(nAf)]  + tangents[int(nBf)] + tangents[int(nCf)]);
	}
	


#ENDIF