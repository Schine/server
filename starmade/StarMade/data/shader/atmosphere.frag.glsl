/*    
 	This file is part of jME Planet Demo.

    jME Planet Demo is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation.

    jME Planet Demo is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with jME Planet Demo.  If not, see <http://www.gnu.org/licenses/>.
*/
const float LOG2 = 1.442695;
uniform vec4 fvAtmoColor;
uniform vec4 fvDiffuse;

uniform float density;
uniform float fAtmoDensity;
uniform float fAbsPower;
uniform float fGlowPower;
uniform float dist;

varying vec3 fvNormal;
varying vec3 fvViewDirection;
varying vec3 fvLightDirection;

vec3 maxVal(vec3 rgb) {
   return rgb/max(rgb.x, max(rgb.y, rgb.z));
}

void main()
{
    vec3 n = normalize(fvNormal);
    vec3 v = normalize(fvViewDirection);
    vec3 l = normalize(fvLightDirection);
    
    float NdotV = dot(n, v);
    float NdotL = dot(n, l);
    
    float glow =  1.0 - pow(cos(abs(NdotV) * 1.57079), fGlowPower);  
    
    vec4 color = fvDiffuse * fvAtmoColor;
    
    float falloff;
    
    falloff = max(0.0,(1.0 - NdotV) *  glow * (max(0.5, min(1.0, NdotL + 0.65)) * 2.0) );
    falloff = pow(falloff, 1.0/(fAtmoDensity / 2.5));

 	float z = gl_FragCoord.z / gl_FragCoord.w;
   float fogFactor = exp2( -density * 
					   density * 
					   z * 
					   z * 
					   LOG2 );
	fogFactor = 1.0 - clamp(fogFactor*2.8, 0.0, 1.0);

    gl_FragColor.xyz = maxVal(color.xyz * falloff);
    gl_FragColor.w = (color.w * falloff) / max(1.0, min(12.0, dist / 2.0));
    //if(dist >= 0.0){
   // 	gl_FragColor.a *= fogFactor;
    //}
    //gl_FragColor = vec4(glow);    
}