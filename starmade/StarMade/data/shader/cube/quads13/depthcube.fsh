#version 120
#extension GL_EXT_gpu_shader4: enable

varying vec2 mainTexCoords;

varying float layer;
varying float extraAlphaVert;
varying vec4 vPos;

uniform float zNear;
uniform float zFar;


// depthSample from depthTexture.r, for instance
float linearDepth(float depthSample, float zNear,float zFar)
{
    depthSample = 2.0 * depthSample - 1.0;
    float zLinear = 2.0 * zNear * zFar / (zFar + zNear - depthSample * (zFar - zNear));
    return zLinear;
}

// result suitable for assigning to gl_FragDepth
float depthSample(float linearDepth, float zNear,float zFar)
{
    float nonLinearDepth = (zFar + zNear - 2.0 * zNear * zFar / linearDepth) / (zFar - zNear);
    nonLinearDepth = (nonLinearDepth + 1.0) / 2.0;
    return nonLinearDepth;
}

void main()
{
	//still gotta write depth component as 8bit values to 32bit depth
	gl_FragDepth = depthSample(length(vPos.xyz), zNear, zFar);//gl_FragCoord.z;
}