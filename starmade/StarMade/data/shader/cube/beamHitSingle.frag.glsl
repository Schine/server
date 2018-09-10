#version 120

uniform sampler2D mainTexA;
uniform vec4 selectionColor;
uniform float texMult;
void main()
{

	// Current texture coordinate
	vec2 texel = vec2(-(texMult-1.0)*0.5+gl_TexCoord[0].st*texMult);
	vec4 pixel = vec4(texture2D(mainTexA, texel));
/*
	float pixelWidth = texMult;
	float pixelHeight = texMult;

	float glow = 4.0 * ((pixelWidth + pixelHeight) / 2.0);;
	
	vec4 bloom = vec4(0);
	
	// Loop over all the pixels on the texture in the area given by the constant in glow
	int count = 0;
	
	 
	for(float x = texel.x - glow; x < texel.x + glow; x += pixelWidth)
	{
		for(float y = texel.y - glow; y < texel.y + glow; y += pixelHeight)
		{
			// Add that pixel's value to the bloom vector
			bloom += (texture2D(mainTexA, vec2(x, y)) - 0.4) * 30.0;
			// Add 1 to the number of pixels sampled
			count++;
		}
	}
	// Divide by the number of pixels sampled to average out the value
	// The constant being multiplied with count here will dim the bloom effect a bit, with higher values
	// Clamp the value between a 0.0 to 1.0 range
	bloom = clamp(bloom / (count * 30), 0.0, 1.0);
	pixel+=bloom;
	*/
	if(pixel.a <= 0.01){
		discard;
	}
	gl_FragColor = pixel * selectionColor;
}