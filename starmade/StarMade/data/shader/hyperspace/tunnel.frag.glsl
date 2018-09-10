#version 120
uniform float time;
uniform sampler2D tex0;
uniform sampler2D noise;
varying float ao;
void main (void)
{
  vec2 uv = gl_TexCoord[0].xy;
  vec4 tex = texture2D(tex0, uv);
  vec4 nTex = texture2D(noise, uv);
  
  vec3 t = tex.rgb * ao;
  
  
  float alpha = min(tex.a*nTex.g*4.0, 1.0);
  alpha = alpha - (1.0 - min(time*2.0, 1.0));
  gl_FragColor = vec4(t, alpha* ao);
}