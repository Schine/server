#version 120

/*
* Toon Lines shader by Luiz Felipe M. Pereira(felipearts)
* Based on Toon Lines shader by Jose I. Romero (cyborg_ar)
* released under the terms of the GNU General Public License version 2
*/

uniform sampler2D bgl_RenderedTexture;
uniform sampler2D bgl_DepthTexture;
uniform float bgl_MeshForce; //how transparent the underlying mesh should be
uniform vec2 bgl_TextureCoordinateOffset[9];
const float near = 0.001;
const float far  = 1.0;
const float farInv = 1.0 / far;
const float edgeForce = 3.0;


// A custom function, which returns the linearized depth value of the a given point in the depth texture,
// linearization seems to be a way of having more uniform values for the fragments far from the camera;
// as it is logical which greater depth values would give greater results, also linearization compensates
// lack of accurancy for fragments distant to the camera, as by default a lot of accurancy is allocated to
// fragments near the camera. 
float depth(in vec2 coo)
{
    vec4 depth =  texture2D(bgl_DepthTexture, coo);
    return -near / (-1.0+float(depth) * ((far-near)*farInv));
}
void main(void)
{
    vec4 sample[9];
    vec4 texcol = texture2D(bgl_RenderedTexture, gl_TexCoord[0].st);
    
    sample[0] = vec4(depth(gl_TexCoord[0].st + bgl_TextureCoordinateOffset[0]));
    sample[1] = vec4(depth(gl_TexCoord[0].st + bgl_TextureCoordinateOffset[1]));
    sample[2] = vec4(depth(gl_TexCoord[0].st + bgl_TextureCoordinateOffset[2]));
    sample[3] = vec4(depth(gl_TexCoord[0].st + bgl_TextureCoordinateOffset[3]));
    sample[4] = vec4(depth(gl_TexCoord[0].st + bgl_TextureCoordinateOffset[4]));
    sample[5] = vec4(depth(gl_TexCoord[0].st + bgl_TextureCoordinateOffset[5]));
    sample[6] = vec4(depth(gl_TexCoord[0].st + bgl_TextureCoordinateOffset[6]));
    sample[7] = vec4(depth(gl_TexCoord[0].st + bgl_TextureCoordinateOffset[7]));
    sample[8] = vec4(depth(gl_TexCoord[0].st + bgl_TextureCoordinateOffset[8]));
    
    // The result fragment sample matrix is as below, where x is the current fragment(4)
    // 0 1 2
    // 3 x 5
    // 6 7 8
    
    vec4 areaMx = max(sample[0], max(sample[1], max(sample[2], max(sample[3], max(sample[5], max(sample[6], max(sample[7], sample [8])))))));
    vec4 areaMn = min(sample[0], min(sample[1], min(sample[2], min(sample[3], min(sample[5], min(sample[6], min(sample[7], sample [8])))))));
    
    float colDifForce = ( ( dot( vec3( areaMx - areaMn ), vec3(1.0) ) ) );
    
    if (colDifForce > 0.1)
    {
       gl_FragColor = vec4(vec3(texcol*edgeForce), 1.0);
    }else{
       gl_FragColor = vec4(texcol.xyz,texcol.x*bgl_MeshForce);
    }
    //gl_FragColor = texture2D(bgl_DepthTexture, gl_TexCoord[0].st);
}