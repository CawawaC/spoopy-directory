shader_type canvas_item;
uniform vec4 color_glitch_parameter : hint_color;
uniform float strength_parameter : hint_range(0,50,0.5);
uniform float height_parameter : hint_range(0,50,0.5);
uniform float tolerance_parameter : hint_range(0,1,0.05);
uniform float opacity_parameter : hint_range(0,1,0.05);

float rand(float n){return fract(sin(n) * 43758.5453123);}

float noise(float p){
	float fl = floor(p);
	float fc = fract(p);
	return mix(rand(fl), rand(fl + 1.0), fc);
}

void fragment(){
	vec3 color;
	vec3 input_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	float strength = ((sin(TIME*10.0))+1.0)*(strength_parameter/2.0);

	float band_height = noise(ceil(UV.y*(height_parameter)))*10.0;
	float displacement = (noise(ceil(UV.y*band_height)+10.0)-0.65)*(strength/1000.0);
	vec2 uv;

	uv = SCREEN_UV + vec2(displacement,0);

	color.rgb = textureLod(SCREEN_TEXTURE, vec2(uv.x,uv.y), 0.0).rgb;
	
	vec3 color_offsetted = textureLod(SCREEN_TEXTURE, vec2(uv.x/2.0,uv.y*2.0), 0.0).rgb;
	
	float grayscale = dot (color_offsetted, vec3(0.299,0.587,0.114));
	if(grayscale>tolerance_parameter){
		color.r = rand(uv.y+sin(TIME/4.0));
		color.g = rand(((uv.y+sin(TIME/1.0))/2.0));
		color.b = rand(((uv.y+sin(TIME/4.0))));
	}
	
	float diff = length(vec3(color_glitch_parameter.rgb-color.rgb));
	if(diff<tolerance_parameter && noise((uv.y*rand(sin(TIME)))*10.0+10.0)>.7){
		color.rgb = textureLod(SCREEN_TEXTURE, vec2((sin(TIME)+1.0)/2.0,uv.y), 0.0).rgb;
		color.rgb = color.rgb*opacity_parameter + input_color * (-opacity_parameter+1.0);
	}
	else
		color.rgb =input_color;
	
	COLOR.rgb = color;
}