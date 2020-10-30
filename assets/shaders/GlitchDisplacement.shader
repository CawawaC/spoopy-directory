shader_type canvas_item;
uniform float strength_parameter : hint_range(0,50,0.5);
uniform float height_parameter : hint_range(0,500,0.5);
uniform bool is_chromatic;
uniform bool is_displacement;
uniform bool is_moving;

float rand(float n){return fract(sin(n) * 43758.5453123);}

float noise(float p){
	float fl = floor(p);
	float fc = fract(p);
	return mix(rand(fl), rand(fl + 1.0), fc);
}

void fragment(){
	vec3 color;
	float strength ;
	if (is_moving)
		strength= ((sin(TIME*5.0))+1.0)*(strength_parameter/2.0);
	else
		strength= strength_parameter;
	float band_height = noise(ceil(UV.y*(height_parameter)))*10.0;
	float displacement = (noise(ceil(UV.y*band_height)+10.0)-0.65)*(strength/1000.0);
	vec2 uv;
	if(is_displacement){
		 uv = SCREEN_UV + vec2(displacement,0);
	}
	else{
		 uv = SCREEN_UV;
	}
	if (is_chromatic){
		color.r = textureLod(SCREEN_TEXTURE, vec2(uv.x+displacement,uv.y), 0.0).r;
		color.g = textureLod(SCREEN_TEXTURE, vec2(uv.x,uv.y), 0.0).g;
		color.b = textureLod(SCREEN_TEXTURE, vec2(uv.x-displacement,uv.y), 0.0).b;
	}
	else{
		color.rgb = textureLod(SCREEN_TEXTURE, vec2(uv.x,uv.y), 0.0).rgb;
	}
	COLOR.rgb = color;
}