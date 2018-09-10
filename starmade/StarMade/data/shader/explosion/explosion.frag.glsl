#version 120

uniform sampler2D tex0;
uniform sampler2D tex1;
uniform sampler2D tex2;
uniform sampler2D tex3;
uniform sampler2D tex4;
uniform sampler2D tex5;
uniform sampler2D depthTex;

uniform float zNear;
uniform float zFar;
uniform float particleSize;

uniform vec2 viewport;

varying float time;
varying float distance;
varying vec4 viewPos;

varying vec3 spriteParams;

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

	
	
	vec4 basic;
	
	if(spriteParams.x < 0.5){
		basic = texture2D(tex0,  gl_TexCoord[0].st);
	}else if(spriteParams.x < 1.5){
		basic = texture2D(tex1,  gl_TexCoord[0].st);
	}else if(spriteParams.x < 2.5){
		basic = texture2D(tex2,  gl_TexCoord[0].st);
	}else if(spriteParams.x < 3.5){
		basic = texture2D(tex3,  gl_TexCoord[0].st);
	}else if(spriteParams.x < 4.5){
		basic = texture2D(tex4,  gl_TexCoord[0].st);
	}else {
		basic = texture2D(tex5,  gl_TexCoord[0].st);
	}
	if(time > 0.3){
		basic.w -= time;
	}
	
	if(basic.w < 0.01){
		discard;
	}
	
	
	
	
	vec4 color = basic;
	
	//cc.a -= max(0.0, 1.0-black);
	
	//gl_FragColor = cc;
	
	
	float exp_depth = texture2D(depthTex, gl_FragCoord.xy/viewport).z;


	float znear = zNear;//0.1;
	float zfar = zFar;//10.0;

	
	//float depth = ((2.0 * znear) / (zfar + znear - exp_depth));	
	float depth = exp_depth;//linearDepth(exp_depth, znear, zfar);//(2.0 * znear) / (zfar + znear - exp_depth * (zfar - znear));	
	
  
    float partDepth = depthSample(length(viewPos.xyz), znear, zfar);//(zfar - znear + length(viewPos.xyz)) / (2.0 * znear);//depthSample(gl_FragCoord.z/gl_FragCoord.w, znear, zfar);///(zFar-zNear);//length(viewPos.xyz)/(zFar-zNear);//(gl_FragCoord.z/gl_FragCoord.w)length(viewPos.xyz);//((gl_FragCoord.z/gl_FragCoord.w)/(zFar-zNear));//(length(viewPos.xyz)*0.1);// / gl_FragCoord.w;//length(viewPos.xyz);
   
   
    //if(partDepth < 0.99999){
	//	discard;
	//}
    //vec4 color = texture2D(ParticleTexture, TexCoords);
    float weight = clamp( (depth - partDepth) / particleSize, 0.0, 1.0);

    /* 
    // The "better" version from nvidia's paper
    float Input = (depth - partDepth) / ParticleSize;
    float Output = 0.5 * pow( clamp( 2*(( Input > 0.5) ? 1-Input : Input), 0.0, 1.0 ), ContrastPower);

    float weight = ( Input > 0.5) ? 1-Output : Output;
    */

    color.a *= weight;
    
    gl_FragColor = vec4(color.xyz, color.w*10.0*clamp((depth-partDepth)*30.0,0.0, 1.0)); //texture2D(depthTex, gl_TexCoord[0].xy);
    //gl_FragColor = vec4(vec3(clamp((depth-partDepth)*4.0,0.0, 1.0)), 1.0); //texture2D(depthTex, gl_TexCoord[0].xy);
}

