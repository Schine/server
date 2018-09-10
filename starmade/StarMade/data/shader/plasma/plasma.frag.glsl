#version 120


uniform float time;
void main()
{
  
   float x = abs(gl_TexCoord[0].x - 0.5) *1000.0;
   float y = gl_TexCoord[0].y *1000.0;
   float mov0 = x+y+cos(sin(time)*2.0)*100.0+sin(x/100.0)*1000.0;
   float mov1 = y / 512.0 / 0.2 + time;
   float mov2 = x / 512.0 / 0.2;
   
   float c1 = abs(sin(mov1+time)/2.0+mov2/2.0-mov1-mov2+time);
   float c2 = abs(sin(c1+sin(mov0/1000.0+time)+sin(y/40.0+time)+sin((x+y)/100.0)*3.0));
   float c3 = abs(sin(c2+cos(mov1+mov2+c2)+cos(mov2)+sin(x/1000.0)));
   gl_FragColor = vec4( c1*2.0,c2/2.0,c3/2.0,0.2 * (c3+c2));

}