#version 120
uniform sampler2D ColorMap;
uniform sampler2D Texture;
uniform vec4 Param;    // StarBrightCoef, StarBrightMin, StarParticleSize, StarParticleFadeOut

varying vec2 TexCoord;
varying vec2 ColBright;
void main()
{
    vec4 Color = texture2D(ColorMap, vec2(ColBright.x, 0));////texture1D(ColorMap, ColBright.x); //
    vec4 tex = texture2D(Texture, TexCoord);
    gl_FragColor.rgb = ColBright.y  * Color.rgb  * tex.rgb;
    gl_FragColor.a = ColBright.y*tex.a;
}


