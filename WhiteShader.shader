shader_type canvas_item;

//uniform is like export
uniform bool active = true;

// fragment will execute in every single pixel
void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 new_color = previous_color;
	if(active){
		new_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	}
	COLOR = new_color;
}