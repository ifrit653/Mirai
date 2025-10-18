shader_type canvas_item;


void fragment() {
	vec4 col = texture(TEXTURE, UV);
	
	// Define outline thickness
	float outline_width = 10.0 / float(textureSize(TEXTURE, 0).x);
	
	// Sample neighboring pixels for outline
	float outline = 0.0;
	outline += texture(TEXTURE, UV + vec2(outline_width, 0.0)).a;
	outline += texture(TEXTURE, UV - vec2(outline_width, 0.0)).a;
	outline += texture(TEXTURE, UV + vec2(0.0, outline_width)).a;
	outline += texture(TEXTURE, UV - vec2(0.0, outline_width)).a;
	
	// Normalize
	outline = min(outline, 1.0);
	
	// If current pixel is transparent but neighbors have content, draw outline
	if (col.a == 0.0 && outline > 0.0) {
		col = vec4(1.0); // White color
	}
	
	COLOR = col;
}
