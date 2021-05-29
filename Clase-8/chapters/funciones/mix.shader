shader_type canvas_item;

uniform vec4 colorA: hint_color;
uniform vec4 colorB: hint_color;

void fragment() {
	vec4 color = mix(colorA, colorB, UV.x);
	COLOR = color;
}