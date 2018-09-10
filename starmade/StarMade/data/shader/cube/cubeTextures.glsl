#IFDEF normaltexarray
uniform sampler2DArray cTex;
uniform sampler2DArray cTexNormal;
#ELSEIF texarray
uniform sampler2DArray cTex;
#ELSEIF normalmap
uniform sampler2D normalTex0;
uniform sampler2D normalTex1;
uniform sampler2D normalTex2;
uniform sampler2D normalTex7;

uniform sampler2D mainTex0;
uniform sampler2D mainTex1;
uniform sampler2D mainTex2;
uniform sampler2D mainTex7;
uniform sampler2D overlayTex;
#ELSE
uniform sampler2D mainTex0;
uniform sampler2D mainTex1;
uniform sampler2D mainTex2;
uniform sampler2D mainTex7;
uniform sampler2D overlayTex;
#ENDIF