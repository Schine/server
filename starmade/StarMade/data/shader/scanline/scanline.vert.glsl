#version 120

varying vec4 tCol;

void main(void)
{

	tCol = gl_Color;
	gl_Position = ftransform();
   	gl_TexCoord[0] = gl_MultiTexCoord0;
}

