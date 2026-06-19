shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float aspect = 1.7777777;
uniform vec2 player_pos = vec2(0.5);
uniform float spotlight_range = 0.2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV - player_pos;
	uv = vec2(uv.x, uv.y);
	
	float mask = spotlight_range - length(uv);
	mask = smoothstep(0, 0.12, mask);
	COLOR.rgb = mix(vec3(0.0), texture(SCREEN_TEXTURE, SCREEN_UV).rgb, mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
