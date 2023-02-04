shader_type canvas_item;
render_mode unshaded;




uniform sampler2D gradient: hint_black;
uniform float mix_amount = 1.0;


uniform vec2 dir = vec2(0,0);
uniform int quality = 4;

void vertex(){
	vec2 blurSize = abs(dir) * 2.0;
	VERTEX *= blurSize + 1.0;
	UV = (UV - 0.5) * (blurSize + 1.0) + 0.5;
}

float insideUnitSquare(vec2 v) {
    vec2 s = step(vec2(0.0), v) - step(vec2(1.0), v);
    return s.x * s.y;   
}


void fragment(){
	vec4 input_color = texture(TEXTURE, UV);
	float greyscale_value = dot(input_color.rgb, vec3(0.299, 0.587, 0.114));
	vec3 sampled_color = texture(gradient, vec2(greyscale_value, 0.0)).rgb;

	COLOR.rgb = mix(input_color.rgb, sampled_color, mix_amount);
	COLOR.a = input_color.a;
	
	float inSquare = insideUnitSquare(UV);
	float numSamples = inSquare;
	COLOR.rgb = mix(input_color.rgb, sampled_color, mix_amount) * inSquare;
	vec2 stepSize = dir/(float(quality));
	vec2 uv;
	for(int i = 1; i <= quality; i++){
		uv = UV + stepSize * float(i);
		inSquare = insideUnitSquare(uv);
		numSamples += inSquare;
		COLOR += texture(TEXTURE, uv) * inSquare;
		
		uv = UV - stepSize * float(i);
		inSquare = insideUnitSquare(uv);
		numSamples += inSquare;
		COLOR += texture(TEXTURE, uv) * inSquare;
	}
	COLOR.rgb /= numSamples;
	COLOR.a /= float(quality)*2.0 + 1.0;
}