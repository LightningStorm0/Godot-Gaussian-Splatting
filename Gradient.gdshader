shader_type spatial;

render_mode unshaded;

render_mode cull_disabled;
render_mode blend_mix;

varying vec3 color;
varying float alpha;

void vertex() {
	color = COLOR.rgb;
	alpha = COLOR.a;
}

void fragment() {
	float distanceFromCenter = length(UV - vec2(0.5, 0.5)) * 2.0;
	
	ALBEDO = color;
	ALPHA = clamp(alpha - distanceFromCenter, 0.0, 1.0);
}
