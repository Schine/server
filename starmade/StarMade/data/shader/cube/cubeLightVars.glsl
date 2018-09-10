
uniform mat4 v_inv;

#IFDEF intel130

in vec4 vPos;
in vec3 vertexPos;
varying vec3 normalVec;
varying vec3 binormalVec;
varying vec3 tangentVec;

#ELSEIF force130
in vec4 vPos;
in vec3 vertexPos;
flat in vec3 normalVec;
flat in vec3 binormalVec;
flat in vec3 tangentVec;

#ELSE
varying vec4 vPos;
varying vec3 normalVec;
varying vec3 binormalVec;
varying vec3 tangentVec;
varying vec3 vertexPos;
#ENDIF


#IFDEF INTATT
varying vec3 blockLDir;
#ENDIF
const float shininess = 30.0;
const float attenuation = 1.1;

#IFDEF nospotlights
#ELSEIF vertexLighting
#ELSE 
uniform int spotCount;
#ENDIF 

