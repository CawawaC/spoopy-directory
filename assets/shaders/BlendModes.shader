//http://www.deepskycolors.com/archive/2010/04/21/formulas-for-Photoshop-blending-modes.html
//http://www.simplefilter.de/en/basics/mixmods.html
shader_type canvas_item;
render_mode unshaded;
uniform vec4 color_param : hint_color;
uniform float intensity: hint_range(0,1 ,0.1 );
uniform bool color_burn : false;
uniform bool color_dodge : false;
uniform bool ligthen : false;
uniform bool darken : false;
uniform bool multiply : false;
uniform bool hard_light : false;
uniform bool soft_light : false;
uniform bool vivid_light : false;
uniform bool linear_light : false;
uniform bool pin_light : false;

void fragment(){
	vec4 input_color = texture(TEXTURE,UV); //read from texture
	vec3 white = vec3(0,0,0);
	vec3 output_color = vec3(0,0,0);
	float greyscale;
	vec4 color = color_param;
	float intensity_reversed = intensity*-1.0+1.0;
	
	if(color_dodge)
		output_color =  color.rgb + input_color.rgb;
		
	else if (color_burn)
		output_color = white - (white -input_color.rgb) / color.rgb ;
	
	else if (ligthen)
		output_color = max(color.rgb,input_color.rgb);
	
	else if(darken)
		output_color = min(color.rgb,input_color.rgb);
	
	else if(multiply)
		output_color = color.rgb * input_color.rgb;
		
	else if (hard_light){
		greyscale = dot (input_color.rgb, vec3(0.299,0.587,0.114));
		if(greyscale>.5)
			output_color = white - vec3(2,2,2) *(white - input_color.rgb)*(white -color.rgb);
		else
			output_color = vec3(2,2,2) * input_color.rgb*color.rgb;
	}
	
	else if (soft_light){
		greyscale = dot (input_color.rgb, vec3(0.299,0.587,0.114));
		if(greyscale<.5)
			output_color = (vec3(2,2,2) * input_color.rgb - white) *(color.rgb - color.rgb*color.rgb) + color.rgb;
		else
			output_color = (vec3(2,2,2) * input_color.rgb - white) *(sqrt(color.rgb) - color.rgb) + color.rgb;
	}
	
	else if (vivid_light){
		greyscale = dot (input_color.rgb, vec3(0.299,0.587,0.114));
		if(greyscale<.5)
			output_color = white - (white - color.rgb) / (vec3(2,2,2)*input_color.rgb);
		else
			output_color = input_color.rgb/(vec3(2,2,2)*(white- color.rgb));
	}
	
	else if (linear_light)
			output_color =  color.rgb + vec3(2,2,2)*input_color.rgb - white;
	
	else if (pin_light){
		if(dot (color.rgb, vec3(0.299,0.587,0.114)) <  dot (vec3(2,2,2)*input_color.rgb - white, vec3(0.299,0.587,0.114)))
			output_color = vec3(2,2,2)*input_color.rgb - white;
		else if(dot (color.rgb, vec3(0.299,0.587,0.114)) <  dot (vec3(2,2,2)*input_color.rgb, vec3(0.299,0.587,0.114)))
			output_color = vec3(2,2,2)*input_color.rgb;
		else
			output_color = color.rgb;
	}
	
	else
		output_color = input_color.rgb;	
		
	if(output_color.r>1.0)
		output_color.r=1.0;
	if(output_color.g>1.0)
		output_color.g=1.0;
	if(output_color.b>1.0)
		output_color.b=1.0;
		
	COLOR.rgb = (output_color* vec3(intensity,intensity,intensity) + input_color.rgb* vec3(intensity_reversed,intensity_reversed,intensity_reversed));
	COLOR.a =input_color.a;
}
