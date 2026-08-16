shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;

void fragment(){
	float ratio = TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y;
	vec2 scaled_uv = (UV - vec2(0.5,0) ) /vec2(ratio, 1) + vec2(0.5,0);
	float mask = (1.0 -smoothstep(size-0.1,size , length(scaled_uv-center))) *
					smoothstep(size-thickness - 0.1,size-thickness , length(scaled_uv-center));
	vec2 disp = normalize(scaled_uv - center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
	//COLOR.rbg = vec3(mask);
}