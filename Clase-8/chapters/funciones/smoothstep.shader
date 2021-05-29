shader_type canvas_item;

uniform float step_start = 0.5;
uniform float step_size = 0.2;

void fragment() {
	float grayscale = smoothstep(step_start, step_start + step_size, UV.x);
	COLOR = vec4(vec3(grayscale), 1.0);
}