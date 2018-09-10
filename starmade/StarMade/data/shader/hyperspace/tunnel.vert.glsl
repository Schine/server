#version 120

uniform float time;
const float tunnel_len = 4.0; // 80.0
varying float ao;
void main()
{	

	vec2 z_divisor = vec2(0.0001,0.0001); // 10.0, 10.0
  vec4 pos = gl_Vertex;
  pos.x += cos(time + ((gl_Vertex.z)*z_divisor.x))*0.1;  
  pos.y += sin(time + ((gl_Vertex.z)*z_divisor.y))*0.1;  
  
  gl_Position = gl_ModelViewProjectionMatrix * pos;		
  vec4 uv = gl_MultiTexCoord0 ;
  uv.y += time*0.3;
  uv.x -= time*0.1;
  uv.y *= 2.0;
  gl_TexCoord[0] = uv;
  
  
  ao = ((((pos.z*2.3) + tunnel_len) * 6.9)-236.0) / tunnel_len;
}
