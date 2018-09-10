#version 120
varying float time;
varying float distance;
varying vec4 viewPos;

varying vec3 spriteParams;
void main()
{
	
	
	time = gl_Vertex.w;
	
	distance = length(gl_Vertex.xyz - gl_MultiTexCoord0.xyz);
	
	vec2 teCo = vec2(mod(floor(gl_MultiTexCoord0.w * 4.0), 2.0), mod(floor(gl_MultiTexCoord0.w * 2.0), 2.0));
	
	spriteParams.x = float(int(mod(gl_Normal.x, 100.0))); //sprite index; 
	spriteParams.y = 8.0;//float(int(mod(gl_Normal.x, 10000.0) * 0.01)); //x max; 
	spriteParams.z = 4.0;//float(int(gl_Normal.x * 0.0001)); //y max
	
	
	int maxX = int(spriteParams.y);
	int maxY = int(spriteParams.z);
	
	float max = float(maxX)*float(maxY);
	
	float currentSpriteIndex = float(int(min(time*34.0 , max-1.0)));
	
	float column = float(int(mod(currentSpriteIndex, float(maxX))));
	float row = float(int(currentSpriteIndex / maxX));
	
	float columnCoord = column / float(maxX);
	float rowCoord = row / float(maxY);
	
	//teCo = teCo * 2.0 - 1.0;
	
	vec2 tc = vec2(columnCoord + teCo.x * (1.0/float(maxX)), rowCoord + teCo.y * (1.0/float(maxY)));
	
	
	gl_TexCoord[0].st = tc;
	
	
	gl_FrontColor = gl_Color;
	
	viewPos = (gl_ModelViewMatrix * vec4(gl_Vertex.xyz, 1.0));
	
	gl_Position = gl_ProjectionMatrix * viewPos;

	
}