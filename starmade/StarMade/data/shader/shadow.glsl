

#IFDEF ULTRA
const float seamZ = 0.0001;
const float seamMultZ = 1.0/(seamZ*2.0);
const float seamY = 0.0009	;
const float seamMultY = 1.0/(seamY*2.0);
const float seamX = 0.002;
const float seamMultX = 1.0/(seamX*2.0);
#ELSEIF shadow
const float seam = 0.0001;
const float seamMult = 1.0/(seam*2.0);
#ENDIF


#IFDEF shadow
#extension GL_EXT_texture_array : enable

const float scale = 2.0/4096.0;

uniform bool shadow;
uniform vec4 far_d;
uniform vec2 texSize;
uniform sampler2DArray stex;
uniform int splits;

#ENDIF



#IFDEF ULTRA

float doOffset(vec4 shadow_coord, vec4 offset, float third){
  vec4 shadow_lookup = shadow_coord + texSize.y*offset*1.6; //scale the offsets to the texture size, and make them twice as large to cover a larger radius
	   
   float shadowDepth = texture2DArray( stex, vec3(shadow_lookup.xy, third)).x;
   float depth = shadow_coord.w / shadowDepth;
    if(depth <= 0.9996){
   	 	return 0.125;
    }else{
    	return 0.0;
    }
}

//8tap random fragment
float shad(int index)
{
	
	// transform this fragment's position from view space to scaled light clip space
	// such that the xy coordinates are in [0;1]
	// note there is no need to divide by w for othogonal light sources
	vec4 shadow_coord = gl_TextureMatrix[index]*vPos;


	shadow_coord.w = shadow_coord.z; //fragDepth
	
	// tell glsl in which layer to do the look up
	shadow_coord.z = float(index);
	
	float ret = 0.0;
	
	float third = float(index);
	ret += doOffset(shadow_coord, vec4(0.000000, 0.000000, 0.0, 0.0), third);
	ret += doOffset(shadow_coord, vec4(0.079821, 0.165750, 0.0, 0.0), third);
	ret += doOffset(shadow_coord, vec4(-0.331500, 0.159642, 0.0, 0.0), third);
	ret += doOffset(shadow_coord, vec4(-0.239463, -0.497250, 0.0, 0.0), third);
	ret += doOffset(shadow_coord, vec4(0.662999, -0.319284, 0.0, 0.0), third);
	ret += doOffset(shadow_coord, vec4(0.399104, 0.828749, 0.0, 0.0), third);
	ret += doOffset(shadow_coord, vec4(-0.994499, 0.478925, 0.0, 0.0), third);
	ret += doOffset(shadow_coord, vec4(-0.558746, -1.160249, 0.0, 0.0), third);
	
	  
	
	return ret;//ret > 0.5 ? 1.0 : 0.0;
	

}
#ELSEIF BEST

float shad(int index)
{
	
	// transform this fragment's position from view space to scaled light clip space
	// such that the xy coordinates are in [0;1]
	// note there is no need to divide by w for othogonal light sources
	vec4 shadow_coord = gl_TextureMatrix[index]*vPos;


	shadow_coord.w = shadow_coord.z; //fragDepth
	
	// tell glsl in which layer to do the look up
	shadow_coord.z = float(index);
	
	float ret = 0.0;
	
	
 	float shadowDepth = texture2DArray( stex, shadow_coord.xyz).x;
	   float depth = shadow_coord.w / shadowDepth;
	    if(depth > 1.0000015){
	   	 	return 0.0;
	    }else{
	    	return 1.0;
	    }
	
}



#ELSEIF shadow
//8tap random fragment
float shad(int index)
{
	// transform this fragment's position from view space to scaled light clip space
	// such that the xy coordinates are in [0;1]
	// note there is no need to divide by w for othogonal light sources
	vec4 shadow_coord = gl_TextureMatrix[index]*vPos;


	shadow_coord.w = shadow_coord.z; //fragDepth
	
	// tell glsl in which layer to do the look up
	shadow_coord.z = float(index);
	
	float ret = 0.0;
	
 	float shadowDepth = texture2DArray( stex, shadow_coord.xyz).x;
   float depth = shadow_coord.w / shadowDepth;
    if(depth > 1.0005){
   	 	return 0.0;
    }else{
    	return 1.0;
    }
	  
}

#ENDIF

#IFDEF VSM


float linstep(float low, float high, float v){
    return clamp((v-low)/(high-low), 0.0, 1.0);
}
float VSM(sampler2DArray depths, vec3 uvIndex, float compare){
    vec2 moments = texture2DArray(depths, uvIndex).xy;
    float p = smoothstep(compare-0.02, compare, moments.x);
    float variance = max(moments.y - moments.x*moments.x, -0.001);
    float d = compare - moments.x;
    float p_max = linstep(0.2, 1.0, variance / (variance + d*d));
    return clamp(max(p, p_max), 0.0, 1.0);
}
float shadVSM(){

	int index = 3;
	
		// find the appropriate depth map to look up in based on the depth of this fragment
		if(gl_FragCoord.z < far_d.x)
			index = 0;
		else if(gl_FragCoord.z < far_d.y)
			index = 1;
		else if(gl_FragCoord.z < far_d.z)
			index = 1;
	index = 0;
	// transform this fragment's position from view space to scaled light clip space
	// such that the xy coordinates are in [0;1]
	// note there is no need to divide by w for othogonal light sources
	vec4 shadow_coord = gl_TextureMatrix[index]*vPos;
	
	vec4 ShadowCoordPostW = shadow_coord / shadow_coord.w;

	float distance = ShadowCoordPostW.z;

	// We retrive the two moments previously stored (depth and depth*depth)
	
	
	
		vec2 moments = texture2DArray(stex,vec3(ShadowCoordPostW.xy, index)).rg;
		
		/*
		float compare = 0.5;
		 float p = smoothstep(compare-0.02, compare, moments.x);
	    float variance = max(moments.y - moments.x*moments.x, -0.001);
	    float d = compare - moments.x;
	    float p_max = linstep(0.2, 1.0, variance / (variance + d*d));
	    return clamp(max(p, p_max), 0.0, 1.0);
		*/
		
		// Surface is fully lit. as the current fragment is before the light occluder
		if (distance <= moments.x)
			return 1.0 ;
	
		// The fragment is either in shadow or penumbra. We now use chebyshev's upperBound to check
		// How likely this pixel is to be lit (p_max)
		float variance = moments.y - (moments.x*moments.x);
		variance = max(variance,0.002);
	
		float d = distance - moments.x;
		float p_max = variance / (variance + d*d);
	
		return 1.0-p_max;//(p_max > 0.1 ? 1.0 : 0.0);
		
}
float shadowCoef(){
	/*
	float depth = gl_FragCoord.z;
	float seam = 2.0;
	if(depth > far_d.y-seam && depth < far_d.y+seam){
		return mix(shadVSM(2), shadVSM(1), 0.5);
	}else if(depth > far_d.x-seam && depth < far_d.x+seam){
		return mix(shadVSM(1), shadVSM(0), 0.5);
	}else{
	*/
	return shadVSM();
	/*
		int index = splits-1;
	
		// find the appropriate depth map to look up in based on the depth of this fragment
		if(gl_FragCoord.z < far_d.x)
			index = 0;
		else if(gl_FragCoord.z < far_d.y)
			index = min(1, splits-1);
		else if(gl_FragCoord.z < far_d.z)
			index = min(2, splits-1);
			
		return shadVSM(index);
		
		
		 
	}
	*/
	
}
#ELSEIF ULTRA





float shadowCoef(){
	
	
	
	float depth = gl_FragCoord.z;
	
	if(depth > far_d.z - seamZ && depth < far_d.z+ seamZ){
		return mix(shad(3), shad(2), ((far_d.z-depth) + seamZ)*seamMultZ );
	}else 
	if(depth > far_d.y - seamY && depth < far_d.y + seamY){
		return mix(shad(2), shad(1), ((far_d.y-depth) + seamY)*seamMultY );
	}else 
	if(depth > far_d.x - seamX && depth < far_d.x + seamX){
		return mix(shad(1), shad(0), ((far_d.x-depth) + seamX)*seamMultX);
	}else
	
	{
	
		int index = splits-1;
	
		// find the appropriate depth map to look up in based on the depth of this fragment
		if(depth < far_d.x)
			index = 0;
		else if(depth < far_d.y)
			index = min(1, splits-1);
		else if(depth < far_d.z)
			index = min(2, splits-1);
		else if(depth < 0.99986){ //needs a different value for ultra
			index = min(3, splits-1);
		}else{
			return 1.8-depth;
		}
		
	
			
		return shad(index); 
	
	}
	
	
}
#ELSEIF shadow





float shadowCoef(){
	
	
	
	float depth = gl_FragCoord.z;
	
	if(splits > 3 && depth > far_d.z - seam && depth < far_d.z+ seam){
		return mix(shad(3), shad(2), ((far_d.z-depth) + seam)*seamMult );
	}else if(splits > 2 && depth > far_d.y - seam && depth < far_d.y + seam){
		return mix(shad(2), shad(1), ((far_d.y-depth) + seam)*seamMult );
	}else if(splits > 1 && depth > far_d.x - seam && depth < far_d.x + seam){
		return mix(shad(1), shad(0), ((far_d.x-depth) + seam)*seamMult);
	}else{
	
		int index = splits-1;
	
		// find the appropriate depth map to look up in based on the depth of this fragment
		if(depth < far_d.x)
			index = 0;
		else if(depth < far_d.y)
			index = min(1, splits-1);
		else if(depth < far_d.z)
			index = min(2, splits-1);
		else if(depth < 0.9983){
			index = min(3, splits-1);
		}else{
			return 1.0-depth;
		}
		
	
			
		return shad(index); 
	
	}
	
	
}

#ELSEIF shadow





float shadowCoef(){
	
	
	
	float depth = gl_FragCoord.z;
	
	if(splits > 3 && depth > far_d.z - seam && depth < far_d.z+ seam){
		return mix(shad(3), shad(2), ((far_d.z-depth) + seam)*seamMult );
	}else if(splits > 2 && depth > far_d.y - seam && depth < far_d.y + seam){
		return mix(shad(2), shad(1), ((far_d.y-depth) + seam)*seamMult );
	}else if(splits > 1 && depth > far_d.x - seam && depth < far_d.x + seam){
		return mix(shad(1), shad(0), ((far_d.x-depth) + seam)*seamMult);
	}else{
	
		int index = splits-1;
	
		// find the appropriate depth map to look up in based on the depth of this fragment
		if(depth < far_d.x)
			index = 0;
		else if(depth < far_d.y)
			index = min(1, splits-1);
		else if(depth < far_d.z)
			index = min(2, splits-1);
		else if(depth < 0.99977){
			index = min(3, splits-1);
		}else{
			return 1.0-depth;
		}
		
	
			
		return shad(index); 
	
	}
	
	
}


#ENDIF