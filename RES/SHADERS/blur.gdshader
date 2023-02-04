shader_type canvas_item;

uniform vec4 color : hint_color;
uniform float force : hint_range(1.0, 10.0);

void fragment() {
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, 2.0).rgb * force;
	COLOR.a = texture(TEXTURE , UV).a;
}