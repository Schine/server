varying vec2 uvIn;

void main() {
    uvIn = gl_Vertex.zw;
    //no change needed quad is ident
    gl_Position = vec4(gl_Vertex.xy, 0.0, 1.0);
}