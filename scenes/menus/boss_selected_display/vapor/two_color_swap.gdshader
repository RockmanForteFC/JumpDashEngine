shader_type canvas_item;

uniform vec4 original_0: hint_color;
uniform vec4 original_1: hint_color;

uniform vec4 replace_0: hint_color;
uniform vec4 replace_1: hint_color;

const float precision = 0.1;

vec4 swap_color(vec4 color){
    // Array initialization is not supported in GLES2.
	vec4 original_colors[2];
    original_colors[0] = original_0;
    original_colors[1] = original_1;
    
	vec4 replace_colors[2];
    replace_colors[0] = replace_0;
    replace_colors[1] = replace_1;
    
	for (int i = 0; i < 2
	; i ++) {
		if (distance(color, original_colors[i]) <= precision){
			return replace_colors[i];
		}
	}
	return color;
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	COLOR = vec4(swap_color(col).rgb, col.a);
}
