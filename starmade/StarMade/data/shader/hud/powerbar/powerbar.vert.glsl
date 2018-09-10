#version 120


uniform float flippedX;
uniform float flippedY;

void main()
{
	gl_Position = ftransform();
	
	
	
	if(flippedX > 0.0){
		gl_TexCoord[0].x = 0.25-gl_MultiTexCoord0.x; //0.25 because its a 4x1 atlas
		gl_TexCoord[0].y = gl_MultiTexCoord0.y;
	}else{
		gl_TexCoord[0] = gl_MultiTexCoord0;
	}
	
	if(flippedY > 0.0){
		gl_TexCoord[0].y = 1.0-gl_MultiTexCoord0.y;
	}
}