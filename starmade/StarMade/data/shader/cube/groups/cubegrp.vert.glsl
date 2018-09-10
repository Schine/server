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
	attribute ivec2 ivert;
#ENDIF

const float S_MAX = 32767.0;

uniform vec3 quadPosMark[6];
uniform vec3 normals[7];
uniform vec3 tangents[7];
uniform vec3 binormals[7];

varying vec4 col;
	
void main()
{
	
	#IFDEF INTATT
		int a = ivert.x;
		int b = ivert.y;
		
		float x = float(a & 0xFFFF) - S_MAX; //65535
		float y = float((a >> 16) & 0xFFFF) - S_MAX; //65535
		float z = float(b & 0xFFFF) - S_MAX; //65535
		
		float vertNumCodeE = float((b >> 16) & 3);
		int sideId =  (b >> 18) & 7; 
		
		
		
		
		
		
		
		vec3 vertexPos = vec3(x, y, z); 
		float mVertNumQuarters = (vertNumCodeE) * 0.25;
		
		int normalIndex = sideId;
		vec3 qpm = quadPosMark[normalIndex];
		vec3 normalPos = normals[normalIndex+1];
		
		vec3 mm = vec3(float(int(mVertNumQuarters * qpm.x) & 1),
		float(int(mVertNumQuarters * qpm.y) & 1),
		float(int(mVertNumQuarters * qpm.z) & 1));
		
		
		vec3 P = vec3(	((((-0.5) - (abs(normalPos.x) * -0.5)))  + mm.x) ,
					((((-0.5) - (abs(normalPos.y) * -0.5)))  + mm.y) ,
					((((-0.5) - (abs(normalPos.z) * -0.5)))  + mm.z) );
	
		vertexPos += P + ((normalPos * 0.5));	
		
		gl_FrontColor = gl_Color;
		
		vec4 vPos = gl_ModelViewMatrix * vec4(vertexPos,1.0); 
		gl_TexCoord[0] = gl_MultiTexCoord0;
		gl_Position = gl_ProjectionMatrix * vPos;
		
	#ELSEIF shader4
		int a = int(gl_Vertex.x);
		int b = int(gl_Vertex.y);
		int c = int(gl_Vertex.z);
		
		float x = float(a & 0xFFFF) - S_MAX; //65535
		float y = float(b & 0xFFFF) - S_MAX; //65535
		float z = float(c & 0xFFFF) - S_MAX; //65535
		
		float vertNumCodeE = float((c >> 16) & 3);
		int sideId =  (c >> 18) & 7; 
		
		
		
		
		
		
		vec3 vertexPos = vec3(x, y, z); 
		float mVertNumQuarters = (vertNumCodeE) * 0.25;
		
		int normalIndex = sideId;
		vec3 qpm = quadPosMark[normalIndex];
		vec3 normalPos = normals[normalIndex+1];
		
		vec3 mm = vec3(float(int(mVertNumQuarters * qpm.x) & 1),
		float(int(mVertNumQuarters * qpm.y) & 1),
		float(int(mVertNumQuarters * qpm.z) & 1));
		
		
		vec3 P = vec3(	((((-0.5) - (abs(normalPos.x) * -0.5)))  + mm.x) ,
					((((-0.5) - (abs(normalPos.y) * -0.5)))  + mm.y) ,
					((((-0.5) - (abs(normalPos.z) * -0.5)))  + mm.z) );
	
		vertexPos += P + ((normalPos * 0.5));	
		
		gl_FrontColor = gl_Color;
		
		vec4 vPos = gl_ModelViewMatrix * vec4(vertexPos,1.0); 
		gl_TexCoord[0] = gl_MultiTexCoord0;
		gl_Position = gl_ProjectionMatrix * vPos;
		
	#ELSE

	#ENDIF
	
	
		
		
}