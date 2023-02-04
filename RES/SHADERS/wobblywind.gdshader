shader_type canvas_item;

uniform sampler2D flowMap; //Displacement map
uniform float strength: hint_range(0, 10);    //Force of the effect
uniform float speed: hint_range(0, 999);      //Speed of the effect
uniform int frames : hint_range(1, 999); //Frames of the effect


// Wind settings.
uniform float windSpeed = 1.0;
uniform float minStrength : hint_range(0.0, 1.0) = 0.05;
uniform float maxStrength : hint_range(0.0, 1.0) = 0.2;
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 2.0;
uniform float distortion : hint_range(0.0, 1.0) = 0.25;
uniform float heightOffset : hint_range(0.0, 1.0);

uniform float windOffset = 0; 


//Returns a value between 0 and 1 depending of the frames -> exemple: frames = 4, frame 1 = 0.25
float clock(float time){
	float fframes = float(frames);
	return floor(mod(time * speed, fframes)) / fframes;
}

void fragment(){
	float c = clock(TIME); //Get clock frame
	vec4 offset = texture(flowMap, vec2(UV.x + c, UV.y + c)) * strength; //Get offset 
	//COLOR = texture(TEXTURE, vec2(UV.x,UV.y) + normal.xy); //Apply offset
	COLOR = texture(TEXTURE, vec2(UV.x,UV.y) + offset.xy - vec2(0.5,0.5)*strength); //We need to remove the displacement 
}


float getWind(vec2 vertex, vec2 uv, float time){
    float diff = pow(maxStrength - minStrength, 2.0);
    float wind_strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
    float wind = (sin(time) + cos(time * detail)) * wind_strength * max(0.0, (1.0-uv.y) - heightOffset);
    
    return wind; 
}

void vertex() {
    vec4 pos = WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0);
    float time = TIME * windSpeed + windOffset;
    //float time = TIME * speed + pos.x * pos.y  ; not working when moving...
    VERTEX.x += getWind(VERTEX.xy, UV, time);
}