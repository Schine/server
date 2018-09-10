#version 120
#extension GL_EXT_gpu_shader4: enable


uniform vec4 nearColor = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 farColor = vec4(0.0, 0.0, 0.0, 1.0);
uniform float near = 0.0;
uniform float far = 500.0;
 
 
void main() {
   // gl_FragColor = mix(nearColor, farColor, smoothstep(near, far, gl_FragCoord.z / gl_FragCoord.w));
}