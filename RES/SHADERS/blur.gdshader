shader_type canvas_item;

uniform vec4 color : hint_color;

void fragment() {
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, 2).rgb * 4.0;
	COLOR.a = texture(TEXTURE , UV).a;
}