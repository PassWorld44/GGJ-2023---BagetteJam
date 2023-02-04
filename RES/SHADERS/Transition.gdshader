shader_type canvas_item;

uniform sampler2D transition_effect;
uniform float progress: hint_range(0.0, 1.0) = 0.0;
uniform bool invert = false;

void fragment() {
	float transition_value = texture(transition_effect, UV).r;
	COLOR.a = float(transition_value <= progress) * float(!invert) + float(transition_value > progress) * float(invert);
	COLOR.rgb = texture(TEXTURE,UV).rgb;
}