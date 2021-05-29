shader_type canvas_item;

uniform float clamp_max = 0.5;
uniform float clamp_min = 0.2;

void fragment() {
	float grayscale = clamp(UV.x, clamp_min, clamp_max);
	COLOR = vec4(vec3(grayscale), 1.0);
}