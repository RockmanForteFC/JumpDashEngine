shader_type canvas_item;
uniform bool is_dark;

void fragment() {
	if(is_dark){
	    COLOR = texture(TEXTURE, UV);
	    float avg = (COLOR.r + COLOR.g + COLOR.b) / 9.0;
	    COLOR.rgb = vec3(0,0,0);
	}
	else {
		 COLOR = texture(TEXTURE, UV);
	}
}