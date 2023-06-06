shader_type canvas_item;

uniform vec4 color_ar: source_color;
uniform float alpha: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform bool active = false;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 c = vec4(color_ar.rgb, previous_color.a * alpha);
	vec4 new_color = previous_color;
	if (active == true)
	{
		new_color = c;
	}
	COLOR = new_color;
}