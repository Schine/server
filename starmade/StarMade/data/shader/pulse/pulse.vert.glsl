#version 120

uniform float m_TexCoordMult;



void main(){

	
	gl_TexCoord[0] = gl_MultiTexCoord0 * m_TexCoordMult;
    gl_Position = gl_ModelViewProjectionMatrix * vec4(gl_Vertex.xyz, 1.0);
}